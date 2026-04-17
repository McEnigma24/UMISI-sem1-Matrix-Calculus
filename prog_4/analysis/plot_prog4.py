"""
Rachunek Macierzowy — program 4: heatmapy z eksportu Octave + porownanie wartosci osobliwych.
Uruchom po solution.m z katalogu prog_4/:
  python analysis/plot_prog4.py
"""
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np

ROOT = Path(__file__).resolve().parent.parent
LATEX = ROOT / "LaTeX"
OUT = LATEX / "figures"
OUT.mkdir(parents=True, exist_ok=True)


def load_matrix(name: str) -> np.ndarray:
    p = LATEX / f"prog4_{name}.txt"
    if not p.exists():
        raise FileNotFoundError(f"Brak pliku {p} — najpierw uruchom src/solution.m w Octave.")
    return np.loadtxt(p)


def load_column(name: str) -> np.ndarray:
    return load_matrix(name).ravel()


def heatmap(M: np.ndarray, title: str, fname: str) -> None:
    fig, ax = plt.subplots(figsize=(4.2, 3.4))
    im = ax.imshow(M, aspect="auto", cmap="viridis")
    fig.colorbar(im, ax=ax, fraction=0.046, pad=0.04)
    ax.set_title(title)
    fig.tight_layout()
    dest = OUT / fname
    fig.savefig(dest, format="pdf", bbox_inches="tight")
    plt.close(fig)
    print(f"Zapisano: {dest}")


def figure_matrix_A_intro(A: np.ndarray, fname: str) -> None:
    """Rysunek 1: dwa panele imshow (bez spy dla macierzy gestej)."""
    n, m = A.shape
    extent = (0.5, m + 0.5, 0.5, n + 0.5)
    fig, axes = plt.subplots(1, 2, figsize=(7.0, 3.35), sharey=True)
    absA = np.abs(A)
    im0 = axes[0].imshow(absA, origin="lower", cmap="Blues", aspect="equal", extent=extent)
    axes[0].set_title(r"$|A_{ij}|$")
    fig.colorbar(im0, ax=axes[0], fraction=0.046, pad=0.04)
    lim = float(np.max(np.abs(A))) if A.size else 1.0
    im1 = axes[1].imshow(
        A, origin="lower", cmap="RdBu_r", aspect="equal", extent=extent, vmin=-lim, vmax=lim
    )
    axes[1].set_title(r"$A_{ij}$")
    fig.colorbar(im1, ax=axes[1], fraction=0.046, pad=0.04)
    ticks_j = np.arange(1, m + 1)
    ticks_i = np.arange(1, n + 1)
    for ax in axes:
        ax.set_xlabel("kolumna $j$")
        ax.set_xticks(ticks_j)
        ax.set_yticks(ticks_i)
    axes[0].set_ylabel("wiersz $i$")
    fig.suptitle(rf"Macierz testowa $A$ ({n}\times{m})", fontsize=11, y=1.02)
    fig.tight_layout()
    dest = OUT / fname
    fig.savefig(dest, format="pdf", bbox_inches="tight")
    plt.close(fig)
    print(f"Zapisano: {dest}")


def main() -> None:
    A = load_matrix("A")
    figure_matrix_A_intro(A, "fig_A_intro.pdf")

    heatmap(load_matrix("AAT"), r"$AA^{\mathsf{T}}$", "imagesc_AAT.pdf")
    heatmap(load_matrix("ATA"), r"$A^{\mathsf{T}}A$", "imagesc_ATA.pdf")
    heatmap(load_matrix("V1T"), r"$V^{\mathsf{T}}$ (sciezka $AA^{\mathsf{T}}$)", "imagesc_V1T.pdf")
    heatmap(load_matrix("V2T"), r"$V^{\mathsf{T}}$ (sciezka $A^{\mathsf{T}}A$)", "imagesc_V2T.pdf")
    heatmap(load_matrix("U2"), r"$U$ z $A^{\mathsf{T}}A$ ($n \times m$)", "imagesc_U2.pdf")

    s1 = load_column("sigma1")
    s2 = load_column("sigma2")
    s0 = load_column("sigma_svd")
    k = min(len(s1), len(s2), len(s0))
    s1 = s1[:k]
    s2 = s2[:k]
    s0 = s0[:k]
    x = np.arange(1, k + 1)
    w = 0.25
    fig, ax = plt.subplots(figsize=(5.0, 3.2))
    ax.bar(x - w, s1, width=w, label=r"$\sigma$ z $AA^{\mathsf{T}}$")
    ax.bar(x, s2, width=w, label=r"$\sigma$ z $A^{\mathsf{T}}A$")
    ax.bar(x + w, s0, width=w, label=r"$\sigma$ z svd(A)")
    ax.set_xlabel("indeks (malejaco)")
    ax.set_ylabel("wartosc osobliwa")
    ax.set_title("Porownanie wartosci osobliwych")
    ax.legend(fontsize=8)
    ax.grid(True, axis="y", alpha=0.35)
    fig.tight_layout()
    dest = OUT / "sigma_compare.pdf"
    fig.savefig(dest, format="pdf", bbox_inches="tight")
    plt.close(fig)
    print(f"Zapisano: {dest}")


if __name__ == "__main__":
    main()
