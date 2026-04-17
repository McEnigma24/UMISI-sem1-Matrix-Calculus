"""
Rachunek Macierzowy - prog. 3: wykresy do sprawozdania.
Wymaga uruchomienia Octave (solution.m) wczesniej - pliki w LaTeX/.
"""
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np

ROOT = Path(__file__).resolve().parent.parent
LATEX = ROOT / "LaTeX"
OUT_DIR = LATEX / "figures"
OUT_DIR.mkdir(parents=True, exist_ok=True)

SIGMA_FILE = LATEX / "singular_values.txt"
NORMS_FILE = LATEX / "norms_bar.txt"
COND_FILE = LATEX / "cond_samples.txt"


def load_sigma():
    if SIGMA_FILE.is_file():
        s = np.loadtxt(SIGMA_FILE)
        return np.atleast_1d(s).flatten()
    s = np.sort(np.random.default_rng(11).random(32))[::-1] * 15.0
    s[s < 0.05] += 0.02
    return s


def fig_singular_values(sigma: np.ndarray) -> None:
    idx = np.arange(1, len(sigma) + 1)
    fig, ax = plt.subplots(figsize=(5.2, 3.4))
    ax.semilogy(idx, sigma, "s-", ms=3, lw=1.2, color="0.2")
    ax.set_xlabel("indeks $i$")
    ax.set_ylabel(r"$\sigma_i$")
    ax.set_title(r"Wartosci osobliwe macierzy $M$ ($n \times n$)")
    ax.grid(True, which="both", alpha=0.35)
    fig.tight_layout()
    out = OUT_DIR / "wartosci_osobliwe.pdf"
    fig.savefig(out, format="pdf", bbox_inches="tight")
    plt.close(fig)
    print(f"Zapisano: {out}")


def fig_cumulative_energy(sigma: np.ndarray) -> None:
    """Jaki ulamek ||M||_F^2 pochodzi od pierwszych k wartosci osobliwych."""
    s2 = sigma**2
    total = np.sum(s2)
    cum = np.cumsum(s2) / total
    k = np.arange(1, len(sigma) + 1)
    fig, ax = plt.subplots(figsize=(5.2, 3.4))
    ax.plot(k, cum, "-", lw=1.5, color="0.25")
    ax.axhline(0.9, color="0.55", ls="--", lw=1, label="90% energii Frobeniusa")
    ax.set_xlabel(r"$k$ (liczba najwiekszych $\sigma_i$)")
    ax.set_ylabel(r"$\sum_{i=1}^k \sigma_i^2 \,/\, \sum_j \sigma_j^2$")
    ax.set_title("Skumulowany udzial energii w normie Frobeniusa")
    ax.set_ylim(0, 1.02)
    ax.grid(True, alpha=0.35)
    ax.legend(loc="lower right", fontsize=8)
    fig.tight_layout()
    out = OUT_DIR / "energia_frobeniusa_skumulowana.pdf"
    fig.savefig(out, format="pdf", bbox_inches="tight")
    plt.close(fig)
    print(f"Zapisano: {out}")


def fig_norms_bar() -> None:
    if not NORMS_FILE.is_file():
        return
    v = np.loadtxt(NORMS_FILE)
    v = np.atleast_1d(v).flatten()
    if v.size < 4:
        return
    labels = (r"$\|M\|_1$", r"$\|M\|_2$", r"$\|M\|_\infty$", r"$\|M\|_{S,4}$")
    fig, ax = plt.subplots(figsize=(5.0, 3.5))
    x = np.arange(4)
    ax.bar(x, v[:4], color="0.35", width=0.65)
    ax.set_xticks(x)
    ax.set_xticklabels(labels, fontsize=10)
    ax.set_ylabel("wartosc normy")
    ax.set_title("Porownanie norm macierzy $M$ (ta sama macierz)")
    ax.grid(True, axis="y", alpha=0.35)
    fig.tight_layout()
    out = OUT_DIR / "normy_porownanie.pdf"
    fig.savefig(out, format="pdf", bbox_inches="tight")
    plt.close(fig)
    print(f"Zapisano: {out}")


def fig_cond_histogram() -> None:
    if not COND_FILE.is_file():
        return
    c = np.loadtxt(COND_FILE)
    c = np.atleast_1d(c).flatten()
    c = c[np.isfinite(c) & (c > 0)]
    if c.size == 0:
        return
    fig, ax = plt.subplots(figsize=(5.2, 3.4))
    ax.hist(np.log10(c), bins=22, color="0.4", edgecolor="0.2", alpha=0.85)
    ax.set_xlabel(r"$\log_{10}(\mathrm{cond}(A,2))$")
    ax.set_ylabel("liczba macierzy")
    ax.set_title(
        r"Rozklad uwarunkowania $\mathrm{cond}(A,2)$ dla losowych $A \in \mathbb{R}^{n \times n}$"
    )
    ax.grid(True, axis="y", alpha=0.35)
    fig.tight_layout()
    out = OUT_DIR / "rozklad_cond2_losowe.pdf"
    fig.savefig(out, format="pdf", bbox_inches="tight")
    plt.close(fig)
    print(f"Zapisano: {out}")


if __name__ == "__main__":
    sigma = load_sigma()
    fig_singular_values(sigma)
    fig_cumulative_energy(sigma)
    fig_norms_bar()
    fig_cond_histogram()
