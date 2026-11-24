using System.Text;

namespace ClientStructsSal;

/// C# names as Zig has them: fields, statics, parameters and enum values snake_case, methods
/// camelCase. Acronyms count as words, so `GetUIModule` is `getUiModule`.
static class Names {
    /// `UIModule2Ptr` is `UI`, `Module2`, `Ptr`. Underscores split too.
    static List<string> Words(string name) {
        var words = new List<string>();
        var cur = new StringBuilder();
        for (var i = 0; i < name.Length; i++) {
            var c = name[i];
            if (c == '_') {
                Flush();
                continue;
            }
            if (cur.Length > 0 && char.IsUpper(c)) {
                var prev = name[i - 1];
                var nextLower = i + 1 < name.Length && char.IsLower(name[i + 1]);
                if (char.IsLower(prev) || char.IsDigit(prev) || char.IsUpper(prev) && nextLower) Flush();
            }
            cur.Append(c);
        }
        Flush();
        return words;

        void Flush() {
            if (cur.Length > 0) words.Add(cur.ToString());
            cur.Clear();
        }
    }

    public static string Snake(string name) => Valid(string.Join('_', Words(name).Select(w => w.ToLowerInvariant())), name);

    public static string Camel(string name) {
        var sb = new StringBuilder();
        foreach (var (w, i) in Words(name).Select((w, i) => (w, i))) {
            if (i == 0) sb.Append(w.ToLowerInvariant());
            else sb.Append(char.ToUpperInvariant(w[0])).Append(w[1..].ToLowerInvariant());
        }
        return Valid(sb.ToString(), name);
    }

    /// `.sal`'s parameter words, and what can't start a name, like `_1`'s `1`, get an underscore.
    static string Valid(string made, string original) {
        if (made.Length == 0) return original;
        if (made is "keep" or "inout") return made + "_";
        return char.IsDigit(made[0]) ? "_" + made : made;
    }
}
