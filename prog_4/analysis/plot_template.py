"""
Rachunek Macierzowy — szablon wykresu (zapis PDF do LaTeX/figures/).
Uruchom z katalogu _template_/analysis/:
    python plot_template.py
albo z korzenia _template_/:
    python analysis/plot_template.py
Wymaga: pip install matplotlib

Przed oddaniem: dostosuj styl wykresu i kod do reszty pracy (naturalny poziom studenta,
bez „gotowych” opisów i nadmiarowych ozdobników typowych dla wyjścia z modeli).
"""
from pathlib import Path

import matplotlib.pyplot as plt

# Katalog _template_/LaTeX/figures/ względem tego pliku
ROOT = Path(__file__).resolve().parent.parent
OUT_DIR = ROOT / "LaTeX" / "figures"
OUT_DIR.mkdir(parents=True, exist_ok=True)

# Przykład „intuicji” kosztu eliminacji Gaussa ~ O(n^3) — dostosuj do własnego eksperymentu
n = list(range(2, 25))
ops_model = [k**3 for k in n]

fig, ax = plt.subplots(figsize=(5, 3.2))
ax.plot(n, ops_model, "o-", lw=1.5, ms=4, label=r"model $\propto n^3$")
ax.set_xlabel("$n$ (rozmiar macierzy)")
ax.set_ylabel("liczba operacji (model)")
ax.set_title("Rachunek Macierzowy — szablon (zamień na własne pomiary)")
ax.grid(True, alpha=0.35)
ax.legend()
fig.tight_layout()
out = OUT_DIR / "szablon_flopy.pdf"
fig.savefig(out, format="pdf", bbox_inches="tight")
print(f"Zapisano: {out}")
