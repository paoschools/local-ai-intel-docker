$ErrorActionPreference = "Stop"

$base = "D:\Local-AI"
$folders = @(
  "$base\open-webui\data",
  "$base\postgres\data",
  "$base\nodered\data",
  "$base\documents\original",
  "$base\documents\ocr",
  "$base\documents\processed"
)

foreach ($folder in $folders) {
  New-Item -ItemType Directory -Force -Path $folder | Out-Null
}

Write-Host "Folders created under $base"
Write-Host "Install and start Ollama for Windows before starting Docker."
Write-Host "Then run: docker compose up -d"
