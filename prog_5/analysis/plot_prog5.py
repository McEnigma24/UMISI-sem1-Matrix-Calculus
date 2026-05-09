"""
Rachunek Macierzowy - program 5: 15 wykresow pojedynczych + 3 laczone (wszystkie p).
Uruchom po solution.m z katalogu prog_5/:
  python analysis/plot_prog5.py
"""
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np

ROOT = Path(__file__).resolve().parent.parent
LATEX = ROOT / "LaTeX"
OUT = LATEX / "figures"
OUT.mkdir(parents=True, exist_ok=True)


def plot_one(path_data: Path, path_out: Path, k: int, p_title: str) -> None:
    d = np.loadtxt(path_data)
    if d.ndim == 1:
        d = d.reshape(1, -1)
    it = d[:, 0]
    err = np.maximum(d[:, 1], 1e-20)
    fig, ax = plt.subplots(figsize=(4.0, 2.8))
    ax.semilogy(it, err, "-", lw=1.2, color="C0")
    ax.set_xlabel("iteracja")
    ax.set_ylabel(r"blad residuum $\|Az - \mu z\|$ (norma $p$)")
    ax.set_title(f"Zbieznosc: para k={k}, norma p={p_title}")
    ax.grid(True, which="both", alpha=0.35)
    fig.tight_layout()
    fig.savefig(path_out, format="pdf", bbox_inches="tight")
    plt.close(fig)
    print(f"Zapisano: {path_out}")


def plot_all_p_on_one(k: int) -> None:
    """Wszystkie normy p na jednym wykresie (rozne kolory)."""
    p_suffixes = ["1", "2", "3", "4", "inf"]
    labels = [r"$p=1$", r"$p=2$", r"$p=3$", r"$p=4$", r"$p=\infty$"]
    colors = ["#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd"]
    fig, ax = plt.subplots(figsize=(5.6, 3.4))
    for su, lab, c in zip(p_suffixes, labels, colors):
        src = LATEX / f"prog5_conv_k{k}_p{su}.txt"
        if not src.exists():
            raise FileNotFoundError(f"Brak {src} - uruchom najpierw src/solution.m w Octave.")
        d = np.loadtxt(src)
        if d.ndim == 1:
            d = d.reshape(1, -1)
        it = d[:, 0]
        err = np.maximum(d[:, 1], 1e-20)
        ax.semilogy(it, err, "-", lw=1.35, color=c, label=lab)
    ax.set_xlabel("iteracja")
    ax.set_ylabel(r"blad residuum $\|Az - \mu z\|_p$")
    ax.set_title(f"Zbieznosc (para $k={k}$): wszystkie normy $p$")
    ax.grid(True, which="both", alpha=0.35)
    ax.legend(loc="best", fontsize=9)
    fig.tight_layout()
    path_out = OUT / f"conv_k{k}_all_p.pdf"
    fig.savefig(path_out, format="pdf", bbox_inches="tight")
    plt.close(fig)
    print(f"Zapisano: {path_out}")


def main() -> None:
    p_suffixes = ["1", "2", "3", "4", "inf"]
    for k in (1, 2, 3):
        for su in p_suffixes:
            src = LATEX / f"prog5_conv_k{k}_p{su}.txt"
            if not src.exists():
                raise FileNotFoundError(f"Brak {src} - uruchom najpierw src/solution.m w Octave.")
            dst = OUT / f"conv_k{k}_p{su}.pdf"
            plot_one(src, dst, k, "infty" if su == "inf" else su)
        plot_all_p_on_one(k)


if __name__ == "__main__":
    main()
