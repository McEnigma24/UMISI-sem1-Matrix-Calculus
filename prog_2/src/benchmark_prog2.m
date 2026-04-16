% benchmark_prog2 - pomiar czasu, bledow i szacunek operacji dla prog_2.
% Zapis: ../LaTeX/data/prog2_benchmark.csv  (uruchom z katalogu src/)

m_ur = 8;
d_ur = 24;
n = m_ur + d_ur;
rng(7);
A = rand(n, n);
repeats = 50;

flops_gauss = round((2 * n^3) / 3);
flops_lu = flops_gauss;
flops_lu_pivot = flops_lu + round(n * (n - 1) / 2);
flops_gauss_pivot = flops_gauss + round(n * (n - 1) / 2);

t1 = bench_ms(@() gauss_elim_diag1(A), repeats);
t2 = bench_ms(@() gauss_elim_pivot_diag1(A), repeats);
t4 = bench_ms(@() lu_doolittle_nopivot(A), repeats);
t5 = bench_ms(@() lu_doolittle_pivot(A), repeats);
% Wbudowane lu() jest znacznie szybsze — wiecej powtorzen dla sensownej sredniej [ms]
t0 = bench_ms(@() lu(A), 2000);

U1 = gauss_elim_diag1(A);
prec1 = norm(tril(U1, -1), 'fro') + max(abs(diag(U1) - 1));
U2 = gauss_elim_pivot_diag1(A);
prec2 = norm(tril(U2, -1), 'fro') + max(abs(diag(U2) - 1));
[L4, U4] = lu_doolittle_nopivot(A);
prec4 = norm(A - L4 * U4, 'fro');
[L5, U5, P5] = lu_doolittle_pivot(A);
prec5 = norm(P5 * A - L5 * U5, 'fro');
[L0, U0, P0] = lu(A);
prec0 = norm(P0 * A - L0 * U0, 'fro');

thisdir = fileparts(mfilename('fullpath'));
outdir = fullfile(thisdir, '..', 'LaTeX', 'data');
if !exist(outdir, 'dir')
  mkdir(outdir);
endif
csvpath = fullfile(outdir, 'prog2_benchmark.csv');
fid = fopen(csvpath, 'w');
if fid < 0
  error('benchmark_prog2: nie mozna zapisac %s', csvpath);
endif
fprintf(fid, 'label,time_ms,precision,ops_theory\n');
tbl = {
  'Gauss bez pivotu', t1, prec1, flops_gauss;
  'Gauss z pivotem', t2, prec2, flops_gauss_pivot;
  'LU bez pivotu', t4, prec4, flops_lu;
  'LU z pivotem', t5, prec5, flops_lu_pivot;
  'lu Octave', t0, prec0, flops_lu_pivot
};
for i = 1:size(tbl, 1)
  fprintf(fid, '"%s",%.12g,%.12g,%.12g\n', tbl{i, 1}, tbl{i, 2}, tbl{i, 3}, tbl{i, 4});
endfor
fclose(fid);
fprintf('benchmark_prog2: zapisano %s\n', csvpath);
