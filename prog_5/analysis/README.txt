Rachunek Macierzowy — katalog analysis/ (wykresy, proste benchmarki)
====================================================================

Zalecenie do sprawozdania (patrz SZABLON_CZYTAJ.txt w _template_/):
  - wykresy zapisuj do ../LaTeX/figures/ (PDF lub PNG),
  - w raporcie: \includegraphics{...} oraz opis osi / co mierzono.

Szablon: plot_template.py
  Uruchom z tego katalogu:
    python plot_template.py
  Powstanie m.in. LaTeX/figures/szablon_flopy.pdf (modelowy wykres n vs. n^3).

Oddawany kod i figury mają wyglądać jak praca własna (spójnie z raportem i Octave),
bez oczywistych śladów po generatorach — patrz sekcja w SZABLON_CZYTAJ.txt.

Dalsze pomysły (gdy ma to sens w zadaniu):
  - czas wykonania vs. rozmiar macierzy n,
  - szacowana liczba operacji (+, -, *, /) w zależności od n,
  - porównanie wariantu z/bez pivotingu itd.
