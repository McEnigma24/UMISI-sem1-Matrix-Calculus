# Rachunek Macierzowy: Octave (solution.m + diary) -> Python (wykresy) -> LaTeX (latexmk).
# Uruchom z katalogu zadania (np. prog_N/):  .\generate_ALL.ps1

$ErrorActionPreference = "Stop"
$Root = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }

$src = Join-Path $Root "src"
$latex = Join-Path $Root "LaTeX"
$plotPy = Join-Path $Root "analysis\plot_template.py"

Write-Host "== Octave: solution.m + LaTeX/octave_out.txt ==" -ForegroundColor Cyan
Set-Location $src
& octave-cli --eval "diary('../LaTeX/octave_out.txt'); diary on; run('solution.m'); diary off;"
if ($LASTEXITCODE -ne 0) { Write-Error "Octave zakonczyl sie kodem $LASTEXITCODE"; exit $LASTEXITCODE }

if (Test-Path $plotPy) {
  Write-Host "== Python: wykresy -> LaTeX/figures/ ==" -ForegroundColor Cyan
  & python $plotPy
  if ($LASTEXITCODE -ne 0) { Write-Error "Python zakonczyl sie kodem $LASTEXITCODE"; exit $LASTEXITCODE }
} else {
  Write-Host "== Python: brak analysis/plot_template.py - pomijam ==" -ForegroundColor Yellow
}

Write-Host "== LaTeX: latexmk raport.pdf ==" -ForegroundColor Cyan
Set-Location $latex
& latexmk -pdf -interaction=nonstopmode raport.tex
if ($LASTEXITCODE -ne 0) { Write-Error "latexmk zakonczyl sie kodem $LASTEXITCODE"; exit $LASTEXITCODE }

Write-Host ("Gotowe: " + (Join-Path $latex "raport.pdf")) -ForegroundColor Green
