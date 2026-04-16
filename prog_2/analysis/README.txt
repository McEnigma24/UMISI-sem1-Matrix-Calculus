Rachunek Macierzowy — katalog analysis/ (prog_2)
================================================

plot_template.py
  Wczytuje ../LaTeX/data/prog2_benchmark.csv (generuje go Octave: src/benchmark_prog2.m).
  Zapis: ../LaTeX/figures/prog2_algorytmy.pdf (precyzja log; czas log; operacje = nadmiar nad min. szacunkiem ~ (2/3)n^3).

Kolejnosc (albo .\generate_ALL.ps1 z korzenia prog_2/):
  1) octave w src/: run('benchmark_prog2.m')
  2) python analysis/plot_template.py
