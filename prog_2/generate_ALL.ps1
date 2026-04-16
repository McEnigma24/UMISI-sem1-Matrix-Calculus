# Rachunek Macierzowy, prog_2: Octave -> benchmark CSV -> Python -> LaTeX.
# Uruchom z katalogu prog_2/:  .\generate_ALL.ps1

$ErrorActionPreference = "Stop"
$Root = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }

$src = Join-Path $Root "src"
$latex = Join-Path $Root "LaTeX"
$plotPy = Join-Path $Root "analysis\plot_template.py"

Write-Host "== Octave: solution.m ==" -ForegroundColor Cyan
Set-Location $src
& octave-cli --eval "run('solution.m');"
if ($LASTEXITCODE -ne 0) { Write-Error "Octave solution.m kod $LASTEXITCODE"; exit $LASTEXITCODE }

Write-Host "== Octave: benchmark_prog2.m -> LaTeX/data/ ==" -ForegroundColor Cyan
& octave-cli --eval "run('benchmark_prog2.m');"
if ($LASTEXITCODE -ne 0) { Write-Error "Octave benchmark_prog2.m kod $LASTEXITCODE"; exit $LASTEXITCODE }

Write-Host "== Python: wykresy -> LaTeX/figures/ ==" -ForegroundColor Cyan
& python $plotPy
if ($LASTEXITCODE -ne 0) { Write-Error "Python kod $LASTEXITCODE"; exit $LASTEXITCODE }

Write-Host "== LaTeX: latexmk raport.pdf ==" -ForegroundColor Cyan
Set-Location $latex
& latexmk -pdf -interaction=nonstopmode raport.tex
if ($LASTEXITCODE -ne 0) { Write-Error "latexmk kod $LASTEXITCODE"; exit $LASTEXITCODE }

Write-Host "Gotowe: $(Join-Path $latex 'raport.pdf')" -ForegroundColor Green
