var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// Stel de luisterpoort in
var port = 8080; // Gebruik een poortnummer naar keuze
app.Urls.Add($"http://localhost:{port}");

// Bestandspad definiëren
var filePath = "data.txt";

// Controleer of bestand bestaat
if (!File.Exists(filePath))
{
    File.WriteAllText(filePath, "EasyDevOps - standaard tekst omdat het bestand ontbrak.");
}

// Map een route om de inhoud van het bestand te tonen
app.MapGet("/", () =>
{
    try
    {
        // Lees de inhoud van het bestand
        var fileContent = File.ReadAllText(filePath);
        return Results.Text(fileContent);
    }
    catch (Exception ex)
    {
        return Results.Text($"Er is een fout opgetreden: {ex.Message}");
    }
});

app.Run();