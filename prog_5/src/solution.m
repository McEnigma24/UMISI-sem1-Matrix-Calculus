%% Rachunek Macierzowy - program 5
% Metoda potegowa 3x3 (deflacja), SVD z AA^T, eksport pod wykresy i raport.
% Uruchom z katalogu src/: run('solution.m')

clear all;
clc;

this_dir = fileparts(mfilename('fullpath'));
latex_dir = fullfile(this_dir, '..', 'LaTeX');
fig_dir = fullfile(latex_dir, 'figures');
if ~exist(fig_dir, 'dir')
  mkdir(fig_dir);
endif

data_pfx = fullfile(latex_dir, 'prog5_');

%% Unikalna macierz symetryczna 3x3 (inny student = inne ziarno)
rng(20260417);
B = rand(3, 3);
A = (B + B') / 2;

fprintf('Rachunek Macierzowy, prog. 5: symetryczna A 3x3\n');
dlmwrite([data_pfx 'A.txt'], A, 'delimiter', ' ', 'precision', '%.14e');

%% Wartosci wlasne referencyjne (porownanie)
[Ve, De] = eig(A);
lam_ref = sort(real(diag(De)), 'descend');
fprintf('lambda (eig, malejaco): %.8f %.8f %.8f\n', lam_ref(1), lam_ref(2), lam_ref(3));

%% Metoda potegowa + deflacja: 3 pary, historia bledu w normach 1,2,3,4,Inf
eps_stop = 1e-4;
precheck = 1e-8;
p_names = {'1', '2', '3', '4', 'inf'};
Awork = A;
lam_pow = zeros(3, 1);
V_pow = zeros(3, 3);

for k = 1:3
  [lamk, vk, histk] = power_method_symmetric(Awork, eps_stop, precheck);
  lam_pow(k) = lamk;
  V_pow(:, k) = vk;
  % 15 plikow: iteracja, blad w danej normie
  for pi = 1:5
    fn = sprintf('%sconv_k%d_p%s.txt', data_pfx, k, p_names{pi});
    dlmwrite(fn, [histk(:, 1), histk(:, pi + 1)], 'delimiter', ' ', 'precision', '%.14e');
  endfor
  if k < 3
    Awork = Awork - lamk * (vk * vk');
  endif
endfor

fprintf('lambda (metoda potegowa + deflacja): %.8f %.8f %.8f\n', lam_pow(1), lam_pow(2), lam_pow(3));
fprintf('max |lambda_ref - lambda_pow|: %.3e\n', max(abs(lam_ref - lam_pow)));

%% SVD z AA^T: U, D (sigma), V = A'' U D^+
AAT = A * A';
[U_e, D_e] = eig(AAT);
lam_aat = real(diag(D_e));
[lam_aat, ord] = sort(lam_aat, 'descend');
U_svd = real(U_e(:, ord));
sigma = sqrt(max(0, lam_aat));
Sigma = diag(sigma);
tol = 3 * eps * max([max(sigma); 1e-16]);
inv_sig = zeros(3, 1);
for i = 1:3
  if sigma(i) > tol
    inv_sig(i) = 1 / sigma(i);
  endif
endfor
Sigma_pinv = diag(inv_sig);
V_svd = A' * U_svd * Sigma_pinv;

dlmwrite([data_pfx 'U.txt'], U_svd, 'delimiter', ' ', 'precision', '%.14e');
dlmwrite([data_pfx 'Sigma.txt'], Sigma, 'delimiter', ' ', 'precision', '%.14e');
dlmwrite([data_pfx 'V.txt'], V_svd, 'delimiter', ' ', 'precision', '%.14e');

recon = U_svd * Sigma * V_svd';
fprintf('||A - U Sigma V''||_F (SVD z AA''T): %.3e\n', norm(A - recon, 'fro'));

%% Porownanie z bibliotecznym svd(A) - normy macierzy roznicy E
[Us, Ss, Vs] = svd(A);
E = U_svd * Sigma * V_svd' - Us * Ss * Vs';
err1 = norm(E, 1);
err2 = norm(E, 2);
err3 = matrix_norm_schatten(E, 3);
err4 = matrix_norm_schatten(E, 4);
errinf = norm(E, Inf);

%% Makra LaTeX + fragmenty macierzy (bmatrix)
out_tex = fullfile(latex_dir, 'wyniki_auto.tex');
fid = fopen(out_tex, 'w');
if fid >= 0
  fprintf(fid, '%% auto-generated przez solution.m\n');
  fprintf(fid, '\\newcommand{\\ValErrSvdOne}{%.6e}\n', err1);
  fprintf(fid, '\\newcommand{\\ValErrSvdTwo}{%.6e}\n', err2);
  fprintf(fid, '\\newcommand{\\ValErrSvdThree}{%.6e}\n', err3);
  fprintf(fid, '\\newcommand{\\ValErrSvdFour}{%.6e}\n', err4);
  fprintf(fid, '\\newcommand{\\ValErrSvdInf}{%.6e}\n', errinf);
  fprintf(fid, '\\newcommand{\\ValLamRefOne}{%.8f}\n', lam_ref(1));
  fprintf(fid, '\\newcommand{\\ValLamRefTwo}{%.8f}\n', lam_ref(2));
  fprintf(fid, '\\newcommand{\\ValLamRefThree}{%.8f}\n', lam_ref(3));
  fprintf(fid, '\\newcommand{\\ValLamPowOne}{%.8f}\n', lam_pow(1));
  fprintf(fid, '\\newcommand{\\ValLamPowTwo}{%.8f}\n', lam_pow(2));
  fprintf(fid, '\\newcommand{\\ValLamPowThree}{%.8f}\n', lam_pow(3));
  fclose(fid);
endif

write_bmatrix(fullfile(latex_dir, 'matrix_A_bmat.tex'), A);
write_bmatrix(fullfile(latex_dir, 'matrix_U_bmat.tex'), U_svd);
write_bmatrix(fullfile(latex_dir, 'matrix_Sigma_bmat.tex'), Sigma);
write_bmatrix(fullfile(latex_dir, 'matrix_V_bmat.tex'), V_svd);

fprintf('\nZapisano: %s, prog5_*.txt, matrix_*_bmat.tex\n', out_tex);
fprintf('Wykresy: python analysis/plot_prog5.py z katalogu prog_5/\n');
