"""
Rachunek Macierzowy - program 2: wykres porownawczy (CSV z benchmark_prog2.m).
Uruchom z prog_2/:  python analysis/plot_template.py
"""
from pathlib import Path

import csv

import matplotlib.pyplot as plt
import numpy as np

ROOT = Path(__file__).resolve().parent.parent
CSV_PATH = ROOT / "LaTeX" / "data" / "prog2_benchmark.csv"
OUT_DIR = ROOT / "LaTeX" / "figures"
OUT_DIR.mkdir(parents=True, exist_ok=True)

if not CSV_PATH.is_file():
    raise SystemExit(f"Brak pliku {CSV_PATH} — najpierw uruchom Octave: benchmark_prog2.m")

with CSV_PATH.open(newline="", encoding="utf-8") as f:
    rows = list(csv.DictReader(f))

labels = [r["label"] for r in rows]
time_ms = np.array([float(r["time_ms"]) for r in rows], dtype=float)
prec = np.array([float(r["precision"]) for r in rows], dtype=float)
ops = np.array([float(r["ops_theory"]) for r in rows], dtype=float)
prec_plot = np.maximum(prec, 1e-20)

y = np.arange(len(labels))

fig, axes = plt.subplots(1, 3, figsize=(11.2, 4.2))

ax0 = axes[0]
ax0.barh(y, prec_plot, color="#4477AA", height=0.55)
ax0.set_xscale("log")
ax0.set_yticks(y)
ax0.set_yticklabels(labels, fontsize=9)
ax0.set_xlabel("blad (norma F, skala log)")
ax0.set_title("Precyzja")
ax0.grid(True, axis="x", alpha=0.35)

ax1 = axes[1]
t_plot = np.maximum(time_ms, 1e-4)
ax1.barh(y, t_plot, color="#CC6677", height=0.55)
ax1.set_xscale("log")
ax1.set_yticks(y)
ax1.set_yticklabels(labels, fontsize=9)
ax1.set_xlabel("czas [ms], skala log")
ax1.set_title("Czas (50x / 2000x lu)")
ax1.grid(True, axis="x", which="both", alpha=0.35)

# Prawy panel: wykres liniowy x = szacunek operacji, y = kolejnosc w CSV — przyblizona oś x
# pokazuje dwa poziomy (~(2/3)n^3 vs + narzut pivotu), bez „potrójnych” identycznych slupkow
ax2 = axes[2]
ax2.plot(ops, y, "o-", color="#228833", lw=2.0, ms=8, zorder=3)
ops_rng = float(np.ptp(ops))
pad = max(350.0, ops_rng * 0.55 + 50.0) if ops_rng > 0 else 400.0
ax2.set_xlim(float(ops.min()) - pad, float(ops.max()) + pad)
ax2.set_yticks(y)
ax2.set_yticklabels(labels, fontsize=9)
ax2.set_xlabel("szac. operacji (teoria)")
ax2.set_title("Koszt — linia miedzy wariantami")
ax2.axvline(float(np.min(ops)), color="#666666", ls=":", lw=1.2, zorder=1)
ax2.grid(True, axis="both", alpha=0.35)

fig.suptitle(
    "Porownanie algorytmow (macierz losowa 32x32, rng(7))",
    fontsize=11,
)
fig.tight_layout()
out = OUT_DIR / "prog2_algorytmy.pdf"
fig.savefig(out, format="pdf", bbox_inches="tight")
print(f"Zapisano: {out}")
