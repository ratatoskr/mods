using System.Reflection;

namespace ClientStructsSal;

static class Program {
    static int Main(string[] args) {
        if (args.Length != 1) {
            Console.Error.WriteLine("usage: ClientStructsSal <out dir>");
            return 2;
        }
        var assembly = Assembly.Load("FFXIVClientStructs");
        var exporter = new Exporter(assembly, Docs.Load(assembly));
        exporter.Collect();
        var files = exporter.Write();

        var outDir = Path.GetFullPath(args[0]);
        if (Directory.Exists(outDir)) Directory.Delete(outDir, true);
        foreach (var (path, text) in files) {
            var full = Path.Combine(outDir, path);
            Directory.CreateDirectory(Path.GetDirectoryName(full)!);
            File.WriteAllText(full, text);
        }
        Console.WriteLine($"Wrote {exporter.Count} types in {files.Count} files to {outDir}");
        foreach (var w in exporter.Warnings.Order()) Console.WriteLine($"warning: {w}");
        return 0;
    }
}
