"""
Rachunek Macierzowy — program 4: heatmapy z eksportu Octave (prog4_*.txt).
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
        raise FileNotFoundError(
            f"Missing {p} -- run src/solution.m in Octave first."
        )
    return np.loadtxt(p)


def heatmap(M: np.ndarray, title: str, fname: str) -> None:
    fig, ax = plt.subplots(figsize=(4.2, 3.4))
    im = ax.imshow(M, aspect="auto", cmap="viridis")
    fig.colorbar(im, ax=ax, fraction=0.046, pad=0.04)
    ax.set_title(title)
    fig.tight_layout()
    dest = OUT / fname
    fig.savefig(dest, format="pdf", bbox_inches="tight")
    plt.close(fig)
    print(f"Wrote {dest}")


def figure_matrix_a_intro(A: np.ndarray, fname: str) -> None:
    """Macierz A: |A| oraz A z kolormapą dwubiegunową."""
    n, m = A.shape
    extent = (0.5, m + 0.5, 0.5, n + 0.5)
    fig, axes = plt.subplots(1, 2, figsize=(7.0, 3.35), sharey=True)
    abs_a = np.abs(A)
    im0 = axes[0].imshow(
        abs_a, origin="lower", cmap="Blues", aspect="equal", extent=extent
    )
    axes[0].set_title(r"$|A_{ij}|$")
    fig.colorbar(im0, ax=axes[0], fraction=0.046, pad=0.04)
    lim = float(np.max(np.abs(A))) if A.size else 1.0
    im1 = axes[1].imshow(
        A,
        origin="lower",
        cmap="RdBu_r",
        aspect="equal",
        extent=extent,
        vmin=-lim,
        vmax=lim,
    )
    axes[1].set_title(r"$A_{ij}$")
    fig.colorbar(im1, ax=axes[1], fraction=0.046, pad=0.04)
    ticks_j = np.arange(1, m + 1)
    ticks_i = np.arange(1, n + 1)
    for ax in axes:
        ax.set_xlabel("column $j$")
        ax.set_xticks(ticks_j)
        ax.set_yticks(ticks_i)
    axes[0].set_ylabel("row $i$")
    fig.suptitle(f"Macierz testowa A ({n}x{m})", fontsize=11, y=1.02)
    fig.tight_layout()
    dest = OUT / fname
    fig.savefig(dest, format="pdf", bbox_inches="tight")
    plt.close(fig)
    print(f"Wrote {dest}")


def main() -> None:
    A = load_matrix("A")
    figure_matrix_a_intro(A, "fig_A_intro.pdf")

    heatmap(load_matrix("AAT"), r"$AA^{\mathsf{T}}$", "imagesc_AAT.pdf")
    heatmap(load_matrix("ATA"), r"$A^{\mathsf{T}}A$", "imagesc_ATA.pdf")
    heatmap(
        load_matrix("V1T"),
        r"$V^{\mathsf{T}}$ (path $AA^{\mathsf{T}}$)",
        "imagesc_V1T.pdf",
    )
    heatmap(
        load_matrix("V2T"),
        r"$V^{\mathsf{T}}$ (path $A^{\mathsf{T}}A$)",
        "imagesc_V2T.pdf",
    )
    heatmap(
        load_matrix("U2"),
        r"$U$ from $A^{\mathsf{T}}A$ ($n \times m$)",
        "imagesc_U2.pdf",
    )


if __name__ == "__main__":
    main()
