using System.Reflection;
using System.Reflection.Emit;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;

namespace ClientStructsSal;

/// Something a `.sal` file declares: a struct, union, enum or generic struct.
sealed class Decl {
    public required string Full;
    public required string Keyword;
    /// The namespace of the file it goes in, the one its outermost C# type is in.
    public required string FileNs;
    public string[] Params = [];
    public List<string> Doc = [];
    public List<string> Annotations = [];
    public string? Base;
    public string? Backing;
    public List<Member> Members = [];

    public string Ns => Full.LastIndexOf('.') is var i and >= 0 ? Full[..i] : "";
    public string Leaf => Full[(Full.LastIndexOf('.') + 1)..];
}

enum Kind { Field, Method, Static, Value, Comment }

sealed class Member {
    public required Kind Kind;
    public string Name = "";
    public List<string> Doc = [];
    /// Annotations, like `[0x10] ` or `[Virtual(3)] `.
    public string Prefix = "";
    public bool Static;
    public string Type = "";
    /// A method's `(..)`, a field's own bits or an enum value's `= 3`.
    public string Rest = "";
}

/// Walks ClientStructs' types and writes them as `.sal`. Names are written in full as it goes, marked,
/// and shortened to what resolves where each is written.
sealed partial class Exporter(Assembly assembly, Docs docs) {
    const char TypeMark = '\u0001';
    const char TemplateMark = '\u0003';
    const char EndMark = '\u0002';
    const BindingFlags Instance = BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic;
    const BindingFlags Methods = Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;

    static readonly string[] Roots = ["FFXIVClientStructs.FFXIV", "FFXIVClientStructs.Havok", "FFXIVClientStructs.STD"];
    /// What InteropGenerator makes inside structs, which ClientStructs' users never see.
    static readonly string[] Helpers = ["MemberFunctionPointers", "StaticAddressPointers", "Addresses", "Delegates"];

    readonly HashSet<Type> _wanted = [];
    readonly Queue<Type> _pending = [];
    readonly Dictionary<Type, string> _names = [];
    readonly Dictionary<string, Type> _taken = [];
    readonly List<Decl> _decls = [];
    readonly HashSet<string> _types = [];
    readonly HashSet<string> _templates = [];
    readonly Dictionary<Type, int> _sizes = [];
    public readonly List<string> Warnings = [];

    public int Count => _decls.Count;

    void Warn(string text) => Warnings.Add(text);

    // Finding what to write

    public void Collect() {
        Type[] all;
        try {
            all = assembly.GetTypes();
        } catch (ReflectionTypeLoadException e) {
            all = e.Types.Where(t => t != null).ToArray()!;
        }
        foreach (var t in all.OrderBy(t => t.FullName, StringComparer.Ordinal)) {
            var ns = t.Namespace ?? "";
            if (Roots.Any(r => ns == r || ns.StartsWith(r + "."))) Want(t);
        }
        while (_pending.TryDequeue(out var t)) {
            if (t.IsEnum) BuildEnum(t);
            else BuildStruct(t);
        }
    }

    static bool HasAttr(MemberInfo m, string name) => m.GetCustomAttributes(false).Any(a => a.GetType().Name == name);

    static object? Attr(MemberInfo m, string name) => m.GetCustomAttributes(false).FirstOrDefault(a => a.GetType().Name == name);

    static IEnumerable<object> Attrs(MemberInfo m, string genericName) => m.GetCustomAttributes(false).Where(a => a.GetType().IsGenericType && a.GetType().GetGenericTypeDefinition().Name == genericName);

    static T Prop<T>(object attr, string name) => (T)attr.GetType().GetProperty(name)!.GetValue(attr)!;

    static bool IsPointerWrapper(Type t) => t.IsGenericType && t.GetGenericTypeDefinition().Name is "Pointer`1" or "hkRefPtr`1";

    static int? InlineLength(Type t) => t.GetCustomAttribute<InlineArrayAttribute>()?.Length;

    bool Exportable(Type t) {
        if (t.Assembly != assembly || !t.IsValueType || t.IsPrimitive || t.IsGenericParameter || t.IsByRefLike) return false;
        if (t.IsGenericType && !t.IsGenericTypeDefinition) return false;
        if (t.Name.Contains('<') || t.Name.EndsWith("e__FixedBuffer") || t.Name.EndsWith("VirtualTable")) return false;
        if (Helpers.Contains(t.Name) || InlineLength(t) != null || IsPointerWrapper(t)) return false;
        if (t.IsDefined(typeof(CompilerGeneratedAttribute)) || HasAttr(t, "CExporterIgnoreAttribute")) return false;
        if (typeof(System.Collections.IEnumerator).IsAssignableFrom(t)) return false;
        // Interfaces only name what's in them, like `IStdList<T>.Node`
        var outer = t.DeclaringType;
        return outer == null || outer.IsInterface || outer.IsValueType && (Exportable(outer) || outer.IsGenericTypeDefinition);
    }

    /// A type parameter only for picking how a container works, like its allocator, which changes
    /// nothing in memory. `.sal` leaves them out.
    static bool IsPolicy(Type p) => p.IsGenericParameter && p.GetGenericParameterConstraints().Any(c => c.IsInterface && c.Name.StartsWith("IStatic"));

    /// Whether `t` gets written, queueing it if it's new.
    bool Want(Type t) {
        if (t.IsGenericType && !t.IsGenericTypeDefinition) t = t.GetGenericTypeDefinition();
        if (!Exportable(t)) return false;
        if (_wanted.Add(t)) {
            _pending.Enqueue(t);
            (t.IsGenericTypeDefinition && !t.IsEnum ? _templates : _types).Add(Name(t));
        }
        return true;
    }

    // Names

    /// `FFXIVClientStructs.FFXIV.Client.Game` is `Client.Game`, and Havok's and the STD's keep theirs.
    static string NamespaceOf(Type t) {
        var ns = t.Namespace ?? "";
        if (ns.StartsWith("FFXIVClientStructs.")) ns = ns["FFXIVClientStructs.".Length..];
        else if (ns == "FFXIVClientStructs") ns = "";
        if (ns == "FFXIV") return "";
        return ns.StartsWith("FFXIV.") ? ns["FFXIV.".Length..] : ns;
    }

    static string Plain(string clrName) => clrName.IndexOf('`') is var i and >= 0 ? clrName[..i] : clrName;

    static Type Outermost(Type t) {
        while (t.DeclaringType != null) t = t.DeclaringType;
        return t;
    }

    string Name(Type t) {
        if (t.IsGenericType && !t.IsGenericTypeDefinition) t = t.GetGenericTypeDefinition();
        if (_names.TryGetValue(t, out var known)) return known;
        var outer = t.DeclaringType != null ? Name(t.DeclaringType) : NamespaceOf(t);
        var leaf = Plain(t.Name);
        var name = outer.Length == 0 ? leaf : $"{outer}.{leaf}";
        // Like `Foo` and `Foo<T>` in one namespace
        if (_taken.ContainsKey(name)) {
            var n = 2;
            while (_taken.ContainsKey($"{name}{n}")) n++;
            Warn($"{t.FullName} is {name}{n}, since {name} is {_taken[name].FullName}");
            name = $"{name}{n}";
        }
        _taken[name] = t;
        return _names[t] = name;
    }

    static string Mark(string full) => $"{TypeMark}{full}{EndMark}";

    static string MarkTemplate(string full) => $"{TemplateMark}{full}{EndMark}";

    // Types

    static string? Prim(Type t) => t switch {
        _ when t == typeof(bool) => "bool",
        _ when t == typeof(byte) => "u8",
        _ when t == typeof(sbyte) => "i8",
        _ when t == typeof(short) => "i16",
        _ when t == typeof(ushort) || t == typeof(char) || t == typeof(Half) => "u16",
        _ when t == typeof(int) => "i32",
        _ when t == typeof(uint) => "u32",
        _ when t == typeof(long) => "i64",
        _ when t == typeof(ulong) => "u64",
        _ when t == typeof(float) => "f32",
        _ when t == typeof(double) => "f64",
        _ when t == typeof(nint) => "isize",
        _ when t == typeof(nuint) => "usize",
        _ when t == typeof(void) => "void",
        _ => null,
    };

    static string PointerTo(string? r) => r == null || r == "void" ? "void*" : r + "*";

    /// `t` as a `.sal` type, or null if it has no name there.
    string? Ref(Type t) {
        if (t.IsByRef) return PointerTo(Ref(t.GetElementType()!));
        if (t.IsGenericParameter) return t.Name;
        if (t.IsPointer) return PointerTo(Ref(t.GetElementType()!));
        if (t.IsFunctionPointer || t.IsUnmanagedFunctionPointer) return "void*";
        if (Prim(t) is { } p) return p;
        if (t.FullName == "InteropGenerator.Runtime.CStringPointer") return "cstring";
        if (t.Namespace == "System.Numerics") {
            return t.Name switch {
                "Vector2" => "Vec2",
                "Vector3" => "Vec3",
                "Vector4" => "Vec4",
                "Quaternion" => "Quat",
                "Matrix4x4" => "Mat4",
                _ => null,
            };
        }
        if (IsPointerWrapper(t)) return PointerTo(Ref(t.GetGenericArguments()[0]));
        if (InlineLength(t) is int n) return Ref(ElementOf(t)) is { } e && e != "void" ? $"{e}[{n}]" : null;
        if (t.IsEnum) return Want(t) ? Mark(Name(t)) : Prim(Enum.GetUnderlyingType(t));
        if (!t.IsValueType) return null;
        if (t.IsGenericType) {
            // Inside a generic, its own nested ones are the definitions, with its parameters
            var def = t.IsGenericTypeDefinition ? t : t.GetGenericTypeDefinition();
            if (!Want(def)) return null;
            if (def.IsEnum) return Want(def) ? Mark(Name(def)) : Prim(Enum.GetUnderlyingType(def));
            var args = new List<string>();
            foreach (var (param, a) in def.GetGenericArguments().Zip(t.GetGenericArguments())) {
                if (IsPolicy(param)) continue;
                if (Ref(a) is not { } r || r == "void") return null;
                args.Add(r);
            }
            if (args.Count == 0) return null;
            return $"{MarkTemplate(Name(def))}<{string.Join(", ", args)}>";
        }
        return Want(t) ? Mark(Name(t)) : null;
    }

    static Type ElementOf(Type inline) => inline.IsGenericType ? inline.GetGenericArguments()[0] : inline.GetFields(Instance)[0].FieldType;

    int SizeOf(Type t) {
        if (t.IsPointer || t.IsByRef || t.IsFunctionPointer || t.IsUnmanagedFunctionPointer) return 8;
        if (t.ContainsGenericParameters) return -1;
        if (_sizes.TryGetValue(t, out var known)) return known;
        var size = (int)typeof(Unsafe).GetMethod(nameof(Unsafe.SizeOf))!.MakeGenericMethod(t).Invoke(null, null)!;
        return _sizes[t] = size;
    }

    /// Where the runtime itself puts `f`, so it's right whatever the layout.
    static int OffsetOf(FieldInfo f) {
        var t = f.DeclaringType!;
        var dm = new DynamicMethod("offset", typeof(int), Type.EmptyTypes, t.Module, true);
        var il = dm.GetILGenerator();
        var v = il.DeclareLocal(t);
        il.Emit(OpCodes.Ldloca, v);
        il.Emit(OpCodes.Ldflda, f);
        il.Emit(OpCodes.Ldloca, v);
        il.Emit(OpCodes.Sub);
        il.Emit(OpCodes.Conv_I4);
        il.Emit(OpCodes.Ret);
        return (int)dm.Invoke(null, null)!;
    }

    /// `f`'s type, with fixed buffers and inline arrays as arrays and text as text.
    string? FieldType(FieldInfo f) {
        var t = f.FieldType;
        if (t.Name.EndsWith("e__FixedBuffer")) {
            var e = t.GetFields(Instance)[0].FieldType;
            // Inside a generic its size is only in its layout
            var bytes = t.StructLayoutAttribute is { Size: > 0 } l ? l.Size : SizeOf(t);
            return Ref(e) is { } r && bytes > 0 ? $"{r}[{bytes / SizeOf(e)}]" : null;
        }
        if (InlineLength(t) is int n) {
            var e = ElementOf(t);
            var text = Attr(f, "FixedSizeArrayAttribute") is { } a && Prop<bool>(a, "IsString");
            if (text && e == typeof(byte)) return $"utf8[{n}]";
            if (text && e == typeof(char)) return $"utf16[{n}]";
            return Ref(e) is { } r && r != "void" ? $"{r}[{n}]" : null;
        }
        return Ref(t);
    }

    // Inheritance, as ClientStructs' own exporter works it out

    static List<(Type Type, int Offset)> InheritsOf(Type t) =>
        Attrs(t, "InheritsAttribute`1").Select(a => (a.GetType().GetGenericArguments()[0], Prop<int>(a, "ParentOffset"))).ToList();

    /// A field InteropGenerator copied in from a base, which the base already has.
    static bool IsInheritedCopy(Type t, FieldInfo f) {
        foreach (var (b, _) in InheritsOf(t)) {
            if (InBase(b, f) || IsInheritedCopy(b, f)) return true;
        }
        return false;
    }

    static bool InBase(Type b, FieldInfo f) {
        var parts = f.Name.Split('_');
        var i = Array.IndexOf(parts, b.Name);
        var fields = b.GetFields(Instance);
        if (i <= 0) return fields.Any(x => x.Name == f.Name && x.FieldType == f.FieldType);
        var rest = string.Join("_", parts[(i + 1)..]);
        return fields.Any(x => (x.Name == rest || x.Name == f.Name) && x.FieldType == f.FieldType);
    }

    static bool IsBaseField(Type t, FieldInfo f, Type b) =>
        f.FieldType == b && f.Name == (b.Name == t.Name ? b.Name + "Base" : b.Name) || HasAttr(f, "CExporterBaseTypeAttribute");

    static bool Skipped(FieldInfo f) => f.IsStatic || f.Name.Contains('<') || HasAttr(f, "ObsoleteAttribute") || HasAttr(f, "CExporterIgnoreAttribute");

    // Building

    sealed record Entry(FieldInfo F, int Offset, int Size, Member M, int Order);

    void BuildStruct(Type t) {
        var generic = t.IsGenericTypeDefinition;
        var full = Name(t);
        var d = new Decl { Full = full, Keyword = "struct", FileNs = NamespaceOf(Outermost(t)) };
        if (generic) d.Params = t.GetGenericArguments().Where(a => !IsPolicy(a)).Select(a => a.Name).ToArray();
        d.Doc.AddRange(Docs.Lines(docs.Type(t)));
        var layout = t.StructLayoutAttribute;
        var explicitLayout = layout?.Value == LayoutKind.Explicit;
        var size = generic ? (explicitLayout && layout!.Size > 0 ? layout.Size : -1) : SizeOf(t);
        if (size > 0) d.Annotations.Add($"Size(0x{size:X})");
        if (Attr(t, "VirtualTableAttribute") is { } vt) {
            d.Annotations.Add(Sigs.Annotation("VirtualTable", Prop<string>(vt, "Signature"), Prop<ushort[]>(vt, "RelativeFollowOffsets")));
        }

        var fields = t.GetFields(Instance).Where(f => !Skipped(f) && !IsInheritedCopy(t, f)).ToList();
        // Like `StdVector<T>`, which only holds a `StdVector<T, Default>`. It gets what that has.
        if (generic && fields.Count == 1 && fields[0].FieldType is { IsGenericType: true } held && held.GetGenericTypeDefinition() is var inner && inner != t && Plain(inner.Name) == Plain(t.Name))
            fields = inner.GetFields(Instance).Where(f => !Skipped(f)).ToList();
        int Offset(FieldInfo f) => generic ? (f.GetCustomAttribute<FieldOffsetAttribute>()?.Value ?? -1) : OffsetOf(f);

        // The first base becomes `: Base`, if nothing of its own is inside it
        var first = InheritsOf(t).FirstOrDefault(i => i.Offset == 0).Type;
        if (first != null && !generic && !first.IsEnum) {
            var baseField = fields.FirstOrDefault(f => IsBaseField(t, f, first) && OffsetOf(f) == 0);
            // Its vtable pointer is the base's, which has its own
            bool Inside(FieldInfo f) => f == baseField || f.Name == "VirtualTable" && OffsetOf(f) == 0;
            if (baseField != null && Want(first) && fields.Where(f => !Inside(f)).All(f => OffsetOf(f) >= SizeOf(first))) {
                fields.RemoveAll(Inside);
                d.Base = Mark(Name(first));
            }
        }

        var nested = new HashSet<string>(t.GetNestedTypes(BindingFlags.Public | BindingFlags.NonPublic).Select(n => Plain(n.Name)));
        var entries = new List<Entry>();
        foreach (var (f, order) in fields.Select((f, i) => (f, i))) {
            var m = new Member { Kind = Kind.Field, Name = Names.Snake(FieldName(f, fields)), Doc = Docs.Lines(docs.Field(f)).ToList() };
            var type = FieldType(f);
            var fsize = generic ? -1 : SizeOf(f.FieldType);
            if (type == null) {
                if (generic) {
                    Warn($"{full}.{f.Name}: {f.FieldType} has no .sal type, so it's left out");
                    continue;
                }
                m.Doc.Add($"// A {f.FieldType.Name}, which has no .sal type");
                type = $"u8[{fsize}]";
            }
            m.Type = type;
            if (Bits(full, f, m, nested)) nested.Add(m.Name);
            entries.Add(new Entry(f, Offset(f), fsize, m, order));
        }

        // A union of its own, unless it has code, which a .sal union can't
        var hasCode = t.GetMethods(Methods).Any(m => HasAttr(m, "VirtualFunctionAttribute") || HasAttr(m, "MemberFunctionAttribute") || HasAttr(m, "StaticAddressAttribute"));
        var union = explicitLayout && entries.Count > 1 && d.Base == null && !hasCode && entries.All(e => e.Offset == 0);
        if (union) {
            d.Keyword = "union";
            d.Members.AddRange(entries.Select(e => e.M));
        } else if (generic) {
            var seen = new HashSet<int>();
            foreach (var e in entries) {
                if (e.Offset >= 0 && !seen.Add(e.Offset)) {
                    d.Members.Add(new Member { Kind = Kind.Comment, Name = $"// {e.M.Name} is at 0x{e.Offset:X} too" });
                    continue;
                }
                if (e.Offset >= 0) e.M.Prefix = $"[0x{e.Offset:X}] ";
                d.Members.Add(e.M);
            }
        } else {
            Place(d, entries, size, nested);
        }

        if (!generic) Code(t, d);
        _decls.Add(d);
    }

    /// A field's name, `_name` as `Name` for the fixed arrays ClientStructs shows that way.
    static string FieldName(FieldInfo f, List<FieldInfo> all) {
        var n = f.Name;
        if (n.Length > 1 && n[0] == '_' && InlineLength(f.FieldType) != null) {
            var shown = char.ToUpperInvariant(n[1]) + n[2..];
            if (all.All(o => o.Name != shown)) return shown;
        }
        return n;
    }

    /// Fields at their offsets. Ones sharing an offset become a union of them, and ones only partly
    /// overlapping keep the biggest.
    void Place(Decl d, List<Entry> entries, int size, HashSet<string> nested) {
        var sorted = entries.OrderBy(e => e.Offset).ThenBy(e => e.Order).ToList();
        var i = 0;
        while (i < sorted.Count) {
            var group = new List<Entry> { sorted[i] };
            var end = sorted[i].Offset + Math.Max(sorted[i].Size, 1);
            i++;
            while (i < sorted.Count && sorted[i].Offset < end) {
                group.Add(sorted[i]);
                end = Math.Max(end, sorted[i].Offset + Math.Max(sorted[i].Size, 1));
                i++;
            }
            foreach (var e in group.Where(e => e.Offset + e.Size > size).ToList()) {
                Warn($"{d.Full}.{e.M.Name} goes past its end, so it's left out");
                group.Remove(e);
            }
            if (group.Count == 0) continue;
            if (group.Count == 1) {
                group[0].M.Prefix = $"[0x{group[0].Offset:X}] ";
                d.Members.Add(group[0].M);
            } else if (group.All(e => e.Offset == group[0].Offset)) {
                d.Members.Add(UnionOf(d, group, nested));
            } else {
                var kept = group.OrderByDescending(e => e.Size).ThenBy(e => e.Order).First();
                kept.M.Prefix = $"[0x{kept.Offset:X}] ";
                foreach (var e in group.Where(e => e != kept).OrderBy(e => e.Offset)) {
                    kept.M.Doc.Add($"// {e.M.Name} ({Unmark(e.M.Type)}) is at 0x{e.Offset:X} inside it");
                }
                d.Members.Add(kept.M);
            }
        }
    }

    /// A union of fields at one offset, declared inside the struct's namespace.
    Member UnionOf(Decl d, List<Entry> group, HashSet<string> nested) {
        var names = group.Select(e => Attr(e.F, "CExporterUnionAttribute") is { } a ? Prop<string>(a, "Union") : null).Distinct().ToList();
        var name = names.Count == 1 && names[0] is { Length: > 0 } given ? given : $"Union{group[0].Offset:X}";
        // The field has the name, and its type a name of its own, since Zig can't have both in one struct
        var unique = name;
        string TypeName(string field) => field + (field.EndsWith("Union") ? "Fields" : "Union");
        for (var n = 2; nested.Contains(unique) || nested.Contains(TypeName(unique)) || _taken.ContainsKey($"{d.Full}.{TypeName(unique)}"); n++) unique = $"{name}{n}";
        nested.Add(unique);
        nested.Add(TypeName(unique));
        var full = $"{d.Full}.{TypeName(unique)}";
        _taken[full] = group[0].F.DeclaringType!;
        _types.Add(full);
        var u = new Decl { Full = full, Keyword = "union", FileNs = d.FileNs };
        var seen = new HashSet<string>();
        foreach (var e in group) {
            if (!seen.Add(e.M.Name)) continue;
            e.M.Prefix = "";
            u.Members.Add(e.M);
        }
        _decls.Add(u);
        return new Member { Kind = Kind.Field, Name = unique, Prefix = $"[0x{group[0].Offset:X}] ", Type = Mark(full), Doc = [$"// One of {string.Join(", ", u.Members.Select(m => m.Name))}"] };
    }

    /// `[BitField<T>]`s as the field's own bits, if it's an unsigned int.
    bool Bits(string owner, FieldInfo f, Member m, HashSet<string> nested) {
        var defs = Attrs(f, "BitFieldAttribute`1").ToList();
        if (defs.Count == 0) return false;
        if (m.Type is not ("u8" or "u16" or "u32" or "u64")) {
            Warn($"{owner}.{f.Name}: its bits are left out, since it's a {m.Type}");
            return false;
        }
        if (nested.Contains(m.Name)) return false;
        var width = SizeOf(f.FieldType) * 8;
        var used = new List<(int From, int To)>();
        var names = new HashSet<string>();
        var parts = new List<string>();
        foreach (var a in defs.OrderBy(a => Prop<int>(a, "Index"))) {
            var name = Names.Snake(Prop<string>(a, "Name"));
            var at = Prop<int>(a, "Index");
            var len = Prop<int>(a, "Length");
            if (at + len > width || used.Any(u => at < u.To && u.From < at + len)) continue;
            var unique = name;
            for (var n = 2; !names.Add(unique); n++) unique = $"{name}_{n}";
            name = unique;
            used.Add((at, at + len));
            var t = a.GetType().GetGenericArguments()[0];
            string type;
            if (t == typeof(bool)) type = len == 1 ? "bool" : $"bool";
            else if (t.IsEnum && Want(t) && FitsIn(t, len) && !AsBitfield(t)) type = Mark(Name(t));
            else type = len <= 8 ? "u8" : len <= 16 ? "u16" : len <= 32 ? "u32" : "u64";
            var widthText = type == "bool" && len == 1 ? "" : $" : {len}";
            parts.Add($"[Bit({at})] {type} {name}{widthText};");
        }
        if (parts.Count == 0) return false;
        m.Rest = " { " + string.Join(" ", parts) + " }";
        return true;
    }

    static bool FitsIn(Type e, int bits) {
        foreach (var v in Enum.GetValues(e)) {
            var n = Convert.ToDecimal(v);
            if (n < 0 || n >= (decimal)Math.Pow(2, bits)) return false;
        }
        return true;
    }

    /// Its functions and globals.
    void Code(Type t, Decl d) {
        foreach (var m in t.GetMethods(Methods).OrderBy(m => m.MetadataToken)) {
            if (m.IsGenericMethodDefinition) continue;
            var vf = Attr(m, "VirtualFunctionAttribute");
            var mf = Attr(m, "MemberFunctionAttribute");
            var sa = Attr(m, "StaticAddressAttribute");
            if (vf == null && mf == null && sa == null) continue;
            var doc = Docs.Lines(docs.Method(m)).ToList();
            if (sa != null) {
                if (!m.IsStatic || !m.ReturnType.IsPointer) continue;
                var sig = Sigs.Annotation("Sig", Prop<string>(sa, "Signature"), Prop<ushort[]>(sa, "RelativeFollowOffsets"));
                var target = Ref(m.ReturnType.GetElementType()!);
                if (target == null || target == "void") target = "u8";
                var name = m.Name.Length > 3 && m.Name.StartsWith("Get") && char.IsUpper(m.Name[3]) ? m.Name[3..] : m.Name;
                d.Members.Add(new Member {
                    Kind = Kind.Static, Name = Names.Snake(name), Doc = doc, Prefix = $"[{sig}] ", Static = true,
                    Type = Prop<bool>(sa, "IsPointer") ? target + "*" : target,
                });
                continue;
            }
            var ret = Ref(m.ReturnType);
            var ps = new List<string>();
            var ok = ret != null && !ret.EndsWith(']');
            foreach (var (p, i) in m.GetParameters().Select((p, i) => (p, i))) {
                var r = Ref(p.ParameterType);
                if (r == null || r == "void" || r.EndsWith(']')) {
                    ok = false;
                    break;
                }
                var pn = Names.Snake(p.Name is { Length: > 0 } given ? given : $"a{i + 1}");
                ps.Add($"{r} {pn}");
            }
            if (!ok) {
                Warn($"{d.Full}.{m.Name} is left out, since a type it takes or gives has no .sal type");
                continue;
            }
            var member = new Member { Kind = Kind.Method, Name = Names.Camel(m.Name), Doc = doc, Type = ret!, Rest = $"({string.Join(", ", ps)})" };
            if (vf != null && !m.IsStatic) {
                member.Prefix = $"[Virtual({Prop<uint>(vf, "Index")})] ";
            } else if (mf != null) {
                member.Prefix = $"[{Sigs.Annotation("Sig", Prop<string>(mf, "Signature"), Prop<ushort[]>(mf, "RelativeFollowOffsets"))}] ";
                member.Static = m.IsStatic;
            } else continue;
            d.Members.Add(member);
        }
    }

    void BuildEnum(Type t) {
        if (AsBitfield(t) && BuildFlags(t)) return;
        var backing = Prim(Enum.GetUnderlyingType(t)) ?? "i32";
        var d = new Decl { Full = Name(t), Keyword = "enum", FileNs = NamespaceOf(Outermost(t)), Backing = backing };
        d.Doc.AddRange(Docs.Lines(docs.Type(t)));
        var seen = new Dictionary<string, string>();
        var names = new HashSet<string>();
        foreach (var f in t.GetFields(BindingFlags.Public | BindingFlags.Static)) {
            if (HasAttr(f, "ObsoleteAttribute")) continue;
            var value = Convert.ToDecimal(f.GetRawConstantValue()).ToString(System.Globalization.CultureInfo.InvariantCulture);
            if (seen.TryGetValue(value, out var other)) {
                d.Members.Add(new Member { Kind = Kind.Comment, Name = $"// {Names.Snake(f.Name)} is {other} too" });
                continue;
            }
            // Names that differed only by case or underscores can be the same now
            var vn = Names.Snake(f.Name);
            for (var n = 2; !names.Add(vn); n++) vn = $"{Names.Snake(f.Name)}_{n}";
            seen[value] = vn;
            d.Members.Add(new Member { Kind = Kind.Value, Name = vn, Rest = $" = {value}", Doc = Docs.Lines(docs.Field(f)).ToList() });
        }
        _decls.Add(d);
    }

    /// A `[Flags]` enum with at least one single-bit value, written as a bitfield.
    static bool AsBitfield(Type t) {
        if (!t.IsEnum || !HasAttr(t, "FlagsAttribute")) return false;
        return t.GetFields(BindingFlags.Public | BindingFlags.Static).Any(f => {
            if (HasAttr(f, "ObsoleteAttribute")) return false;
            var raw = f.GetRawConstantValue()!;
            var value = raw is ulong u ? u : unchecked((ulong)Convert.ToInt64(raw));
            return System.Numerics.BitOperations.PopCount(value) == 1;
        });
    }

    /// A `[Flags]` enum as a bitfield, a bool per bit. None, and ones of several bits, can't be
    /// members since they'd overlap, so they're comments. False if it has no single bits at all.
    bool BuildFlags(Type t) {
        var underlying = Enum.GetUnderlyingType(t);
        var size = Marshal.SizeOf(underlying);
        var backing = $"u{size * 8}";
        var mask = size == 8 ? ulong.MaxValue : (1UL << (size * 8)) - 1;
        var d = new Decl { Full = Name(t), Keyword = "bitfield", FileNs = NamespaceOf(Outermost(t)), Backing = backing };
        d.Doc.AddRange(Docs.Lines(docs.Type(t)));
        var bits = new Dictionary<int, string>();
        var names = new HashSet<string>();
        var later = new List<Member>();
        foreach (var f in t.GetFields(BindingFlags.Public | BindingFlags.Static)) {
            if (HasAttr(f, "ObsoleteAttribute")) continue;
            var raw = f.GetRawConstantValue()!;
            var value = (raw is ulong u ? u : unchecked((ulong)Convert.ToInt64(raw))) & mask;
            var vn = Names.Snake(f.Name);
            if (value == 0) {
                later.Add(new Member { Kind = Kind.Comment, Name = $"// {vn} is none of them" });
                continue;
            }
            if (System.Numerics.BitOperations.PopCount(value) != 1) {
                var parts = Enumerable.Range(0, size * 8).Where(b => (value & (1UL << b)) != 0).Select(b => bits.TryGetValue(b, out var n) ? n : $"bit {b}");
                later.Add(new Member { Kind = Kind.Comment, Name = $"// {vn} is 0x{value:X}, {string.Join(" and ", parts)}" });
                continue;
            }
            var bit = System.Numerics.BitOperations.TrailingZeroCount(value);
            if (bits.TryGetValue(bit, out var other)) {
                later.Add(new Member { Kind = Kind.Comment, Name = $"// {vn} is {other} too" });
                continue;
            }
            for (var n = 2; !names.Add(vn); n++) vn = $"{Names.Snake(f.Name)}_{n}";
            bits[bit] = vn;
            d.Members.Add(new Member { Kind = Kind.Field, Prefix = $"[Bit({bit})] ", Type = "bool", Name = vn, Doc = Docs.Lines(docs.Field(f)).ToList() });
        }
        if (bits.Count == 0) return false;
        // Ones of several bits say what's in them, so they go after
        d.Members.AddRange(later);
        _decls.Add(d);
        return true;
    }

    // Writing

    /// Gives each name inside a struct once, its bases' fields counted, as `.sal` checks.
    void Unclash() {
        var byName = _decls.ToDictionary(d => d.Full);
        IEnumerable<string> BaseFields(Decl d) {
            for (var b = d.Base; b != null && byName.TryGetValue(Unmark(b), out var bd); b = bd.Base) {
                foreach (var m in bd.Members.Where(m => m.Kind is Kind.Field or Kind.Method or Kind.Static)) yield return m.Name;
            }
        }
        // Zig has a struct's nested types in it too
        var inside = _decls.GroupBy(d => d.Ns).ToDictionary(g => g.Key, g => g.Select(d => d.Leaf).ToList());
        foreach (var d in _decls.Where(d => d.Keyword is "struct" or "union")) {
            // Zig puts these in a struct with code, and its bases' code too
            var taken = new HashSet<string>(BaseFields(d)) { "addresses", "slots", "Fns", "vtable" };
            taken.UnionWith(inside.GetValueOrDefault(d.Full) ?? []);
            foreach (var kind in new[] { Kind.Field, Kind.Method, Kind.Static }) {
                foreach (var m in d.Members.Where(m => m.Kind == kind)) {
                    var name = m.Name;
                    for (var n = 2; !taken.Add(name); n++) name = $"{m.Name}{n}";
                    m.Name = name;
                }
            }
        }
    }

    [GeneratedRegex("([\u0001\u0003])([^\u0002]*)\u0002")]
    private static partial Regex Marked();

    static string Unmark(string text) => Marked().Replace(text, m => m.Groups[2].Value);

    /// What `written` means in `ns`, the way `.sal` looks: from there outward, then the top.
    string? Resolve(string ns, string written, bool template) {
        var known = template ? _templates : _types;
        for (var p = ns; ; p = p.LastIndexOf('.') is var i and >= 0 ? p[..i] : "") {
            var candidate = p.Length == 0 ? written : $"{p}.{written}";
            if (known.Contains(candidate)) return candidate;
            if (p.Length == 0) return null;
        }
    }

    /// The shortest name for `full` that means it in `ns`.
    string Shortest(string full, string ns, bool template, string[] parameters) {
        var parts = full.Split('.');
        for (var i = parts.Length - 1; i >= 0; i--) {
            var candidate = string.Join('.', parts[i..]);
            if (parameters.Contains(candidate)) continue;
            if (Resolve(ns, candidate, template) == full) return candidate;
        }
        Warn($"{full} can't be named from {ns}, something nearer has its name");
        return full;
    }

    string Short(string text, Decl d) => Marked().Replace(text, m => Shortest(m.Groups[2].Value, d.Ns, m.Groups[1].Value[0] == TemplateMark, d.Params));

    public Dictionary<string, string> Write() {
        Unclash();
        var files = new Dictionary<string, string>();
        foreach (var file in _decls.GroupBy(d => d.FileNs).OrderBy(g => g.Key, StringComparer.Ordinal)) {
            var sb = new StringBuilder();
            sb.Append("// Made from FFXIVClientStructs by tools/ClientStructsSal. Change that and run `zig build client-structs`,\n");
            sb.Append("// since this is written again.\n\n");
            if (file.Key.Length > 0) sb.Append($"namespace {file.Key};\n");
            foreach (var block in file.GroupBy(d => d.Ns).OrderBy(g => g.Key, StringComparer.Ordinal)) {
                var inner = block.Key != file.Key;
                var indent = inner ? "    " : "";
                sb.Append('\n');
                if (inner) {
                    var rel = file.Key.Length == 0 ? block.Key : block.Key[(file.Key.Length + 1)..];
                    sb.Append($"namespace {rel} {{\n");
                }
                var firstDecl = true;
                foreach (var d in block.OrderBy(d => d.Full, StringComparer.Ordinal)) {
                    if (!firstDecl) sb.Append('\n');
                    firstDecl = false;
                    Render(sb, d, indent);
                }
                if (inner) sb.Append("}\n");
            }
            var path = file.Key.Length == 0 ? "Global.sal" : file.Key.Replace('.', '/') + ".sal";
            files[path] = sb.ToString();
        }
        return files;
    }

    void Render(StringBuilder sb, Decl d, string indent) {
        foreach (var line in d.Doc) sb.Append(indent).Append(line).Append('\n');
        if (d.Annotations.Count > 0) sb.Append(indent).Append('[').Append(string.Join(", ", d.Annotations)).Append("]\n");
        sb.Append(indent).Append(d.Keyword).Append(' ').Append(d.Leaf);
        if (d.Params.Length > 0) sb.Append('<').Append(string.Join(", ", d.Params)).Append('>');
        if (d.Backing != null) sb.Append(" : ").Append(d.Backing);
        if (d.Base != null) sb.Append(" : ").Append(Short(d.Base, d));
        sb.Append(" {\n");
        var inner = indent + "    ";
        foreach (var m in d.Members) {
            foreach (var line in m.Doc) sb.Append(inner).Append(line).Append('\n');
            sb.Append(inner);
            switch (m.Kind) {
                case Kind.Comment:
                    sb.Append(m.Name);
                    break;
                case Kind.Value:
                    sb.Append(m.Name).Append(m.Rest).Append(',');
                    break;
                case Kind.Field:
                    sb.Append(m.Prefix).Append(Short(m.Type, d)).Append(' ').Append(m.Name);
                    sb.Append(m.Rest.Length > 0 ? Short(m.Rest, d) : ";");
                    break;
                case Kind.Method:
                    sb.Append(m.Prefix).Append(m.Static ? "static " : "").Append(Short(m.Type, d)).Append(' ').Append(m.Name).Append(Short(m.Rest, d)).Append(';');
                    break;
                case Kind.Static:
                    sb.Append(m.Prefix).Append("static ").Append(Short(m.Type, d)).Append(' ').Append(m.Name).Append(';');
                    break;
            }
            sb.Append('\n');
        }
        sb.Append(indent).Append("}\n");
    }
}
