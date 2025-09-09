param(
  [Parameter(Mandatory=$true)][string]$InputFile,
  [Parameter(Mandatory=$true)][string]$Output,
  [string]$Template
)

# Debug: Show what parameters we received
Write-Host "PowerShell Debug: InputFile = '$InputFile'"
Write-Host "PowerShell Debug: Output = '$Output'"


$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$TplPath = if ($Template) {
    if (!(Test-Path $Template)) { Write-Error "Template not found: $Template"; exit 2 }
    (Resolve-Path $Template).Path
} else {
    Join-Path $Root "index.html"
}

# Validate and resolve input path
if ([string]::IsNullOrEmpty($InputFile)) {
    Write-Error "Input parameter is empty or null"; exit 2
}
if (!(Test-Path $InputFile)) {
    Write-Error "Input not found: $InputFile"; exit 2
}
$InPath = (Resolve-Path $InputFile).Path

# Handle output path - create parent directory if it doesn't exist
$OutputDir = Split-Path -Parent $Output
if ($OutputDir -and !(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}
$OutPath = if ($OutputDir) {
    Join-Path (Resolve-Path $OutputDir).Path (Split-Path -Leaf $Output)
} else {
    Join-Path (Get-Location).Path $Output
}

$Pico    = Join-Path $Root "vendor/pico.min.css"
$Mermaid = Join-Path $Root "vendor/mermaid.min.js"
$Marked  = Join-Path $Root "vendor/marked.min.js"

if (!(Test-Path $TplPath)) { Write-Error "Template not found: $TplPath"; exit 2 }
if (!(Test-Path $InPath))  { Write-Error "Input not found: $InPath"; exit 2 }
if (!(Test-Path $Pico))    { Write-Error "Missing vendor: $Pico"; exit 2 }
if (!(Test-Path $Mermaid)) { Write-Error "Missing vendor: $Mermaid"; exit 2 }
if (!(Test-Path $Marked))  { Write-Error "Missing vendor: $Marked"; exit 2 }

function Get-FileText([string]$Path) {
  return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

# Prepare payload (escape </script> just in case)
$ext = [System.IO.Path]::GetExtension($InPath).ToLowerInvariant()
$src = Get-FileText $InPath
$src = $src -replace '</script>','<\/script>'

if ($ext -eq '.md') {
  $payload = "<script type=""text/markdown"" id=""presentation-md""><!--`r`n$src`r`n--></script>`r`n"
} elseif ($ext -eq '.json') {
  $payload = "<script type=""application/json"" id=""presentation-json"">`r`n$src`r`n</script>`r`n"
} else {
  Write-Error "Input must be .md or .json"
  exit 2
}

# Read template and vendors
$html = Get-FileText $TplPath
$picoText = Get-FileText $Pico
$mermText = Get-FileText $Mermaid
$markText = Get-FileText $Marked

# Remove embedded presentation blocks and export button entirely (robust regex)
$html = [System.Text.RegularExpressions.Regex]::Replace(
  $html,
  '<script[^>]*type\s*=\s*"text/markdown"[^>]*id\s*=\s*"presentation-md"[\s\S]*?<\/script>','',
  [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
  -bor [System.Text.RegularExpressions.RegexOptions]::Singleline
)
$html = [System.Text.RegularExpressions.Regex]::Replace(
  $html,
  '<script[^>]*type\s*=\s*"application/json"[^>]*id\s*=\s*"presentation-json"[\s\S]*?<\/script>','',
  [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
  -bor [System.Text.RegularExpressions.RegexOptions]::Singleline
)
$html = [System.Text.RegularExpressions.Regex]::Replace(
  $html,
  'id\s*=\s*"export-html"[\s\S]*?<\/button>','',
  [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
  -bor [System.Text.RegularExpressions.RegexOptions]::Singleline
)

# Inline pico css
$html = $html -replace '<link[^>]+href=["'']vendor/pico\.min\.css["''][^>]*>',
  "<style>`r`n/* inlined pico.min.css */`r`n$picoText`r`n</style>"

# Inline mermaid js
$html = $html -replace '<script[^>]+src=["'']vendor/mermaid\.min\.js["''][^>]*>\s*</script>',
  "<script>`r`n/* inlined mermaid.min.js */`r`n$mermText`r`n</script>"

# Inline marked js
$html = $html -replace '<script[^>]+src=["'']vendor/marked\.min\.js["''][^>]*>\s*</script>',
  "<script>`r`n/* inlined marked.min.js */`r`n$markText`r`n</script>"

# Inject payload before </body> using LastIndexOf to avoid regex pitfalls
$closingIndex = $html.LastIndexOf('</body>')
if ($closingIndex -ge 0) {
  $before = $html.Substring(0, $closingIndex)
  $after  = $html.Substring($closingIndex)
  $html   = $before + $payload + $after
} else {
  $html = $html + $payload
}

# Write out (UTF-8 without BOM)
[System.IO.File]::WriteAllText($OutPath, $html, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "Built: $OutPath"
