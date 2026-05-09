%% Rachunek Macierzowy, prog. 6
% QR rotacjami Givensa, n = miesiac + dzien

clear all;
clc;

this_dir = fileparts(mfilename('fullpath'));
latex_dir = fullfile(this_dir, '..', 'LaTeX');
fig_dir = fullfile(latex_dir, 'figures');
if ~exist(fig_dir, 'dir')
  mkdir(fig_dir);
endif

miesiac = 5;
dzien = 9;
n = miesiac + dzien;

fprintf('prog. 6: QR Givens, n=%d\n', n);

rng(20260509);
A = rand(n, n);

[Qg, Rg] = qr_givens(A);

err_recon = norm(A - Qg * Rg, 'fro');
err_orth = norm(Qg' * Qg - eye(n), 'fro');
err_upper = norm(tril(Rg, -1), 'fro');

[Ql, Rl] = qr(A);
err_lib = norm(A - Ql * Rl, 'fro');

fprintf('||A-QR||_F (Givens): %.3e\n', err_recon);
fprintf('||Q''Q-I||_F:        %.3e\n', err_orth);
fprintf('||tril(R,-1)||_F:    %.3e\n', err_upper);
fprintf('||A-QR||_F (qr):     %.3e\n', err_lib);

%% czas i srednie bledy vs n (kilka prob losowych na kazde n)
bench_n = 4:4:min(48, n + 20);
bench_n = bench_n(bench_n > 0);
ntrial = 5;
t_ms = zeros(size(bench_n));
mean_aqr = zeros(size(bench_n));
mean_qq = zeros(size(bench_n));
for bi = 1:numel(bench_n)
  nn = bench_n(bi);
  s_aqr = 0;
  s_qq = 0;
  for k = 1:ntrial
    B = rand(nn, nn);
    [Qb, Rb] = qr_givens(B);
    s_aqr += norm(B - Qb * Rb, 'fro');
    s_qq += norm(Qb' * Qb - eye(nn), 'fro');
  endfor
  mean_aqr(bi) = s_aqr / ntrial;
  mean_qq(bi) = s_qq / ntrial;
  B = rand(nn, nn);
  tic;
  qr_givens(B);
  t_ms(bi) = toc * 1000;
endfor

bench_csv = fullfile(latex_dir, 'prog6_czas_vs_n.csv');
dlmwrite(bench_csv, [bench_n(:), t_ms(:)], 'delimiter', ',', 'precision', '%.8f');

blad_csv = fullfile(latex_dir, 'prog6_blad_vs_n.csv');
dlmwrite(blad_csv, [bench_n(:), mean_aqr(:), mean_qq(:)], 'delimiter', ',', 'precision', '%.8e');

out_tex = fullfile(latex_dir, 'wyniki_auto.tex');
fid = fopen(out_tex, 'w');
if fid >= 0
  fprintf(fid, '%% solution.m\n');
  fprintf(fid, '\\newcommand{\\ValN}{%d}\n', n);
  fprintf(fid, '\\newcommand{\\ValMiesiac}{%d}\n', miesiac);
  fprintf(fid, '\\newcommand{\\ValDzien}{%d}\n', dzien);
  fprintf(fid, '\\newcommand{\\ValErrRecon}{%.6e}\n', err_recon);
  fprintf(fid, '\\newcommand{\\ValErrOrth}{%.6e}\n', err_orth);
  fprintf(fid, '\\newcommand{\\ValErrUpper}{%.6e}\n', err_upper);
  fprintf(fid, '\\newcommand{\\ValErrLib}{%.6e}\n', err_lib);
  fclose(fid);
endif

fprintf('\nZapisano: %s, %s, %s\n', out_tex, bench_csv, blad_csv);
