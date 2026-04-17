%% Rachunek Macierzowy - program 4
% SVD macierzy prostokatnej A (n x m): sciezka przez AA' oraz przez A'A.
% Uruchom z katalogu src/: run('solution.m')

clear all;
clc;

this_dir = fileparts(mfilename('fullpath'));
latex_dir = fullfile(this_dir, '..', 'LaTeX');

diary_file = fullfile(latex_dir, 'octave_out.txt');
if exist(diary_file, 'file')
  delete(diary_file);
endif
diary(diary_file);
diary on;

%% Macierz testowa (prostokatna: n > m)
rng(7);
n = 6;
m = 4;
A = randn(n, m);

fprintf('Rachunek Macierzowy, prog. 4: A ma rozmiar %d x %d (n wierszy, m kolumn)\n', n, m);

% Eksport liczb do wykresow (Python, headless) - ten sam katalog co diary
data_pfx = fullfile(latex_dir, 'prog4_');

%% --- 1) Macierz A (spy / wizualizacja) ---
fprintf('\n--- 1) Macierz A ---\n');
disp(A);
dlmwrite([data_pfx 'A.txt'], A, 'delimiter', ' ', 'precision', '%.14e');

%% --- 2) AA' (n x n) ---
AAT = A * A';
fprintf('\n--- 2) AA^T (%d x %d) ---\n', n, n);
disp(AAT);
dlmwrite([data_pfx 'AAT.txt'], AAT, 'delimiter', ' ', 'precision', '%.14e');

%% --- 3-5) Wartosci i wektory wlasne AA' -> U, S = sqrt(lambda) ---
[U_e, D_e] = eig(AAT);
lam_AAT = real(diag(D_e));
[lam_AAT, ord] = sort(lam_AAT, 'descend');
U1 = real(U_e(:, ord));
sigma1 = sqrt(max(0, lam_AAT));
Sigma1 = diag(sigma1);
tol = max(n, m) * eps * max([max(sigma1); 1e-16]);
inv_sigma1 = zeros(n, 1);
for i = 1:n
  if sigma1(i) > tol
    inv_sigma1(i) = 1 / sigma1(i);
  endif
endfor
Sigma1_pinv = diag(inv_sigma1);

fprintf('\n--- 3-4) U (z AA^T), wartosci wlasne lambda, sigma = sqrt(lambda) ---\n');
fprintf('lambda (malejaco): ');
fprintf('%.6g ', lam_AAT);
fprintf('\nsigma: ');
fprintf('%.6g ', sigma1);
fprintf('\n');
disp('U (kolumny = wektory wlasne):');
disp(U1);
disp('Sigma (diagonalna z sqrt(lambda)):');
disp(Sigma1);

%% --- 5-6) V = A'' * U * Sigma^+ (pseudoodwrotnosc diagonalna) ---
V1 = A' * U1 * Sigma1_pinv;
fprintf('\n--- 5-6) V z wlasnosci V = A^T U Sigma^+ (wymiary %d x %d)\n', rows(V1), columns(V1));
fprintf('V jako macierz (kolumny V_i); wierszami (V.'') do porownania z poleceniem:\n');
disp(V1');

recon1 = U1 * Sigma1 * V1';
res1 = norm(A - recon1, 'fro');
fprintf('||A - U Sigma V^T||_F (sciezka AA'') = %.3e\n', res1);
dlmwrite([data_pfx 'V1T.txt'], V1', 'delimiter', ' ', 'precision', '%.14e');

%% --- 7) A'A (m x m) ---
ATA = A' * A;
fprintf('\n--- 7) A^T A (%d x %d) ---\n', m, m);
disp(ATA);
dlmwrite([data_pfx 'ATA.txt'], ATA, 'delimiter', ' ', 'precision', '%.14e');

%% --- 8-9) eig(A'A) -> V, sigma ---
[V_e, D_v] = eig(ATA);
lam_ATA = real(diag(D_v));
[lam_ATA, ord2] = sort(lam_ATA, 'descend');
V2 = real(V_e(:, ord2));
sigma2 = sqrt(max(0, lam_ATA));
Sigma2 = diag(sigma2);
inv_sigma2 = zeros(m, 1);
for i = 1:m
  if sigma2(i) > tol
    inv_sigma2(i) = 1 / sigma2(i);
  endif
endfor
Sigma2_pinv = diag(inv_sigma2);

fprintf('\n--- 8-9) V (z A^T A), lambda, sigma ---\n');
fprintf('lambda (malejaco): ');
fprintf('%.6g ', lam_ATA);
fprintf('\nsigma: ');
fprintf('%.6g ', sigma2);
fprintf('\n');
disp('V (kolumny = wektory wlasne A^T A):');
disp(V2);
disp('Sigma (diagonalna):');
disp(Sigma2);
fprintf('V wierszami (V''):\n');
disp(V2');
dlmwrite([data_pfx 'V2T.txt'], V2', 'delimiter', ' ', 'precision', '%.14e');

%% --- 10-11) U = A V Sigma^+ ---
U2 = A * V2 * Sigma2_pinv;
fprintf('\n--- 10-11) U z U = A V Sigma^+ (wymiary %d x %d)\n', rows(U2), columns(U2));
disp(U2);

recon2 = U2 * Sigma2 * V2';
res2 = norm(A - recon2, 'fro');
fprintf('||A - U Sigma V^T||_F (sciezka A''A) = %.3e\n', res2);
dlmwrite([data_pfx 'U2.txt'], U2, 'delimiter', ' ', 'precision', '%.14e');

%% --- 12) Porownanie z svd(A) ---
[Us, Ss, Vs] = svd(A);
recon_svd = Us * Ss * Vs';
res_svd = norm(A - recon_svd, 'fro');
s_svd = diag(Ss);
s_svd = s_svd(1:min(n, m));

fprintf('\n--- 12) Porownanie z bibliotecznym svd ---\n');
fprintf('||A - U_svd S_svd V_svd''||_F = %.3e\n', res_svd);

% Porownanie sigma: pierwsze min(n,m) (rzeczywisty rank co najwyzej tyle)
k = min(n, m);
fprintf('sigma z AA'' (pierwsze %d, malejaco): ', k);
fprintf('%.6g ', sigma1(1:k));
fprintf('\nsigma z A''A (pierwsze %d): ', k);
fprintf('%.6g ', sigma2(1:k));
fprintf('\nsvd(A): ');
fprintf('%.6g ', s_svd);
fprintf('\n');

err_sig_1 = max(abs(sigma1(1:k) - s_svd(:)));
err_sig_2 = max(abs(sigma2(1:k) - s_svd(:)));
fprintf('max |sigma - svd|, sciezka AA'': %.3e\n', err_sig_1);
fprintf('max |sigma - svd|, sciezka A''A: %.3e\n', err_sig_2);

dlmwrite([data_pfx 'sigma1.txt'], sigma1(:), 'precision', '%.14e');
dlmwrite([data_pfx 'sigma2.txt'], sigma2(:), 'precision', '%.14e');
dlmwrite([data_pfx 'sigma_svd.txt'], s_svd(:), 'precision', '%.14e');

%% --- 13) dim R(A), dim N(A) ---
r = rank(A);
dim_range = r;
dim_null = m - r;
fprintf('\n--- 13) Wymiary obrazu i jadra (A: R^%d -> R^%d) ---\n', m, n);
fprintf('rank(A) (prog numeryczny) = %d\n', r);
fprintf('dim R(A) = %d\n', dim_range);
fprintf('dim N(A) = %d\n', dim_null);

%% Zapis makr do LaTeX (tabela)
out_tex = fullfile(latex_dir, 'wyniki_auto.tex');
fid = fopen(out_tex, 'w');
if fid < 0
  warning('nie udalo sie zapisac %s', out_tex);
else
  fprintf(fid, '%% auto-generated przez solution.m\n');
  fprintf(fid, '\\newcommand{\\ValN}{%d}\n', n);
  fprintf(fid, '\\newcommand{\\ValM}{%d}\n', m);
  fprintf(fid, '\\newcommand{\\ValRank}{%d}\n', r);
  fprintf(fid, '\\newcommand{\\ValDimRange}{%d}\n', dim_range);
  fprintf(fid, '\\newcommand{\\ValDimNull}{%d}\n', dim_null);
  fprintf(fid, '\\newcommand{\\ValResAA}{%.6e}\n', res1);
  fprintf(fid, '\\newcommand{\\ValResATA}{%.6e}\n', res2);
  fprintf(fid, '\\newcommand{\\ValResSVD}{%.6e}\n', res_svd);
  fprintf(fid, '\\newcommand{\\ValErrSigAA}{%.6e}\n', err_sig_1);
  fprintf(fid, '\\newcommand{\\ValErrSigATA}{%.6e}\n', err_sig_2);
  fclose(fid);
endif

diary off;
fprintf('\nZapisano: %s oraz prog4_*.txt (PDF: python analysis/plot_prog4.py z katalogu prog_4)\n', diary_file);
