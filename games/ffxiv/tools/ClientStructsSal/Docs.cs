using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml.Linq;

namespace ClientStructsSal;

/// The XML docs ClientStructs builds with, as `//` lines.
sealed partial class Docs {
    readonly Dictionary<string, string> _members = [];
    /// Methods by name without their parameters, the first overload's.
    readonly Dictionary<string, string> _methods = [];

    public static Docs Load(Assembly assembly) {
        var docs = new Docs();
        var path = Path.ChangeExtension(assembly.Location, ".xml");
        if (!File.Exists(path)) return docs;
        foreach (var member in XDocument.Load(path).Descendants("member")) {
            var name = member.Attribute("name")?.Value;
            if (name == null) continue;
            var text = string.Join(" ", new[] { member.Element("summary"), member.Element("remarks") }.Where(e => e != null).Select(e => Flatten(e!)));
            text = Spaces().Replace(text, " ").Trim();
            if (text.Length == 0) continue;
            docs._members.TryAdd(name, text);
            if (name.StartsWith("M:")) docs._methods.TryAdd(name.Split('(')[0], text);
        }
        return docs;
    }

    static string Flatten(XElement e) {
        var sb = new StringBuilder();
        foreach (var node in e.Nodes()) {
            switch (node) {
                case XText t:
                    sb.Append(t.Value);
                    break;
                case XElement c when c.Name == "see" || c.Name == "seealso" || c.Name == "paramref" || c.Name == "typeparamref":
                    var cref = c.Attribute("cref")?.Value ?? c.Attribute("name")?.Value ?? c.Attribute("langword")?.Value ?? "";
                    cref = cref.Split('(')[0].Split('`')[0];
                    var leaf = cref[(cref.LastIndexOfAny(['.', ':']) + 1)..];
                    // As it's named here, for the fields and methods this writes
                    if (cref.StartsWith("F:")) leaf = Names.Snake(leaf);
                    else if (cref.StartsWith("M:")) leaf = Names.Camel(leaf);
                    else if (c.Name == "paramref") leaf = Names.Snake(leaf);
                    var shown = c.Value.Length > 0 ? c.Value : leaf;
                    sb.Append('`').Append(shown).Append('`');
                    break;
                case XElement c when c.Name == "br":
                    sb.Append(' ');
                    break;
                case XElement c when c.Name == "c" || c.Name == "code":
                    sb.Append('`').Append(c.Value).Append('`');
                    break;
                case XElement c:
                    sb.Append(' ').Append(Flatten(c)).Append(' ');
                    break;
            }
        }
        return sb.ToString();
    }

    [GeneratedRegex(@"\s+")]
    private static partial Regex Spaces();

    public string? Type(Type t) => Get("T:" + Id(t));

    public string? Field(FieldInfo f) => Get("F:" + Id(f.DeclaringType!) + "." + f.Name);

    public string? Method(MethodInfo m) => _methods.GetValueOrDefault("M:" + Id(m.DeclaringType!) + "." + m.Name);

    string? Get(string id) => _members.GetValueOrDefault(id);

    static string Id(Type t) => (t.IsGenericType && !t.IsGenericTypeDefinition ? t.GetGenericTypeDefinition() : t).FullName!.Replace('+', '.');

    /// `// ` lines, wrapped.
    public static IEnumerable<string> Lines(string? text, int width = 100) {
        if (string.IsNullOrEmpty(text)) yield break;
        var line = new StringBuilder();
        foreach (var word in text.Split(' ')) {
            if (line.Length > 0 && line.Length + word.Length + 1 > width) {
                yield return "// " + line;
                line.Clear();
            }
            if (line.Length > 0) line.Append(' ');
            line.Append(word);
        }
        if (line.Length > 0) yield return "// " + line;
    }
}
