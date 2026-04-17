# Rachunek Macierzowy, prog. 4: Octave (solution.m) -> Python (wykresy) -> LaTeX (latexmk).
# Uruchom z katalogu prog_4/:  .\generate_ALL.ps1

$ErrorActionPreference = "Stop"
$Root = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }

$src = Join-Path $Root "src"
$latex = Join-Path $Root "LaTeX"
$plotPy = Join-Path $Root "analysis\plot_prog4.py"

Write-Host "== Octave: solution.m ==" -ForegroundColor Cyan
Set-Location $src
& octave-cli --eval "run('solution.m');"
if ($LASTEXITCODE -ne 0) { Write-Error "Octave zakonczyl sie kodem $LASTEXITCODE"; exit $LASTEXITCODE }

if (Test-Path $plotPy) {
  Write-Host "== Python: plot_prog4.py -> LaTeX/figures/ ==" -ForegroundColor Cyan
  Set-Location $Root
  & python $plotPy
  if ($LASTEXITCODE -ne 0) { Write-Error "Python zakonczyl sie kodem $LASTEXITCODE"; exit $LASTEXITCODE }
} else {
  Write-Host "== Python: brak analysis/plot_prog4.py - pomijam ==" -ForegroundColor Yellow
}

Write-Host "== LaTeX: latexmk raport.pdf ==" -ForegroundColor Cyan
Set-Location $latex
& latexmk -pdf -interaction=nonstopmode raport.tex
if ($LASTEXITCODE -ne 0) { Write-Error "latexmk zakonczyl sie kodem $LASTEXITCODE"; exit $LASTEXITCODE }

Write-Host ("Gotowe: " + (Join-Path $latex "raport.pdf")) -ForegroundColor Green
