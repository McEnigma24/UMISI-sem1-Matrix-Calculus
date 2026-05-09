# Wykresy z CSV wygenerowanych w Octave (solution.m).
from pathlib import Path

import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parent.parent
OUT_DIR = ROOT / "LaTeX" / "figures"
OUT_DIR.mkdir(parents=True, exist_ok=True)

czas_csv = ROOT / "LaTeX" / "prog6_czas_vs_n.csv"
blad_csv = ROOT / "LaTeX" / "prog6_blad_vs_n.csv"
if not czas_csv.is_file():
    raise SystemExit("Brak prog6_czas_vs_n.csv — najpierw Octave.")
if not blad_csv.is_file():
    raise SystemExit("Brak prog6_blad_vs_n.csv — najpierw Octave.")

def load2(path):
    rows = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            rows.append([float(x) for x in line.split(",")])
    return rows

r1 = load2(czas_csv)
n_c = [x[0] for x in r1]
t_ms = [x[1] for x in r1]

fig, ax = plt.subplots(figsize=(5.2, 3.3))
ax.plot(n_c, t_ms, "o-", lw=1.2, ms=4, color="tab:blue")
ax.set_xlabel(r"$n$")
ax.set_ylabel("czas [ms]")
ax.set_title("qr_givens: czas jednego wywołania")
ax.grid(True, alpha=0.35)
fig.tight_layout()
out1 = OUT_DIR / "prog6_czas_vs_n.pdf"
fig.savefig(out1, format="pdf", bbox_inches="tight")

r2 = load2(blad_csv)
n_b = [x[0] for x in r2]
e_aqr = [x[1] for x in r2]
e_qq = [x[2] for x in r2]

fig, ax = plt.subplots(figsize=(5.2, 3.3))
ax.semilogy(n_b, e_aqr, "s-", lw=1.2, ms=4, label=r"$\|A-QR\|_F$ (śr. z 5 los.)")
ax.semilogy(n_b, e_qq, "^-", lw=1.2, ms=4, label=r"$\|Q^{\mathsf{T}}Q-I\|_F$")
ax.set_xlabel(r"$n$")
ax.set_ylabel("wartość (skala log)")
ax.set_title("Jakość numeryczna vs rozmiar")
ax.grid(True, which="both", alpha=0.35)
ax.legend(fontsize=8)
fig.tight_layout()
out2 = OUT_DIR / "prog6_blad_vs_n.pdf"
fig.savefig(out2, format="pdf", bbox_inches="tight")

print(out1)
print(out2)
