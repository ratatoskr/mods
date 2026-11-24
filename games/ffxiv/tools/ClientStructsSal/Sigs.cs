namespace ClientStructsSal;

/// ClientStructs' signatures as Wraith's `[Sig]`. ClientStructs reads a rel32 at each offset in turn,
/// and an `E8` or `E9` one with none follows its call. Each is `Offset(n), Rel32` in Wraith. Its
/// resolver takes the first match, so they're written for that, and each gets `FirstMatch`.
static class Sigs {
    public static string Annotation(string name, string pattern, ushort[] offsets) {
        pattern = pattern.Trim();
        if (offsets.Length == 0 && (pattern.StartsWith("E8") || pattern.StartsWith("E9"))) offsets = [1];
        var steps = offsets.SelectMany(o => o == 0 ? ["Rel32"] : new[] { $"Offset({o})", "Rel32" });
        return string.Join(", ", new[] { $"{name}(\"{pattern}\"", "FirstMatch" }.Concat(steps)) + ")";
    }
}
