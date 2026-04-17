%% Rachunek Macierzowy - program 3
% Normy macierzowe (1, 2, p, inf), wspolczynniki uwarunkowania, SVD, wartosci wlasne (eig).
% Uruchom z katalogu src/:  run('solution.m')

clear all;
clc;

m_ur = 8;
d_ur = 24;
n = m_ur + d_ur;
p_schat = 4;

fprintf('Rachunek Macierzowy, prog. 3: macierz %dx%d, n = miesiac+dzien = %d+%d\n', n, n, m_ur, d_ur);

rng(11);
M = rand(n, n);
rc = rcond(M);
fprintf('rcond(M) = %.3e\n', rc);
if rc < 1e-14
  error('macierz zle uwarunkowana - zmien ziarno RNG');
endif

%% Normy indukowane (subordynowane) 1, 2, inf - Octave norm(M, p)
n1 = norm(M, 1);
n2 = norm(M, 2);
ninf = norm(M, Inf);

%% Wspolczynniki uwarunkowania w normach 1, 2, inf - Octave cond
c1 = cond(M, 1);
c2 = cond(M, 2);
cinf = cond(M, Inf);

%% Porownanie: ||M||*||M^{-1}|| (te same normy)
Minv = inv(M);
c1_def = n1 * norm(Minv, 1);
c2_def = n2 * norm(Minv, 2);
cinf_def = ninf * norm(Minv, Inf);

%% Norma Schattena rzedu p na wartosciach osobliwych (dla punktu ||M||_p w poleceniu)
s = svd(M);
[n_schat, k_schat] = schatten_norm_cond(s, p_schat);

fprintf('\n--- Normy macierzowe ---\n');
fprintf('||M||_1     = %.12e\n', n1);
fprintf('||M||_2     = %.12e\n', n2);
fprintf('||M||_inf   = %.12e\n', ninf);
fprintf('||M||_{S,%d} (Schatten, z SVD) = %.12e\n', p_schat, n_schat);

fprintf('\n--- Wspolczynniki uwarunkowania ---\n');
fprintf('cond(M,1)   = %.12e  (def.: ||M||_1||M^{-1}||_1 = %.12e)\n', c1, c1_def);
fprintf('cond(M,2)   = %.12e  (def.: ||M||_2||M^{-1}||_2 = %.12e)\n', c2, c2_def);
fprintf('cond(M,inf) = %.12e  (def.: ||M||_inf||M^{-1}||_inf = %.12e)\n', cinf, cinf_def);
fprintf('kappa_{S,%d} = ||M||_{S,%d}||M^{-1}||_{S,%d} = %.12e\n', p_schat, p_schat, p_schat, k_schat);

fprintf('\n--- SVD: M = U*S*V'' ---\n');
[U, Sdiag, V] = svd(M);
dlmwrite('../LaTeX/singular_values.txt', diag(Sdiag), 'precision', 12);
res_svd = norm(M - U * Sdiag * V', 'fro');
fprintf('wymiary U: %d x %d, S: %d x %d, V: %d x %d\n', ...
        rows(U), columns(U), rows(Sdiag), columns(Sdiag), rows(V), columns(V));
fprintf('sigma_min = %.6e, sigma_max = %.6e\n', min(diag(Sdiag)), max(diag(Sdiag)));
fprintf('||M - U*S*V''||_F = %.3e\n', res_svd);

fprintf('\n--- Wartosci i wektory wlasne (eig) ---\n');
[Vw, D] = eig(M);
lam = diag(D);
fprintf('wymiary V (wektory w kolumnach): %d x %d\n', rows(Vw), columns(Vw));
fprintf('min Re(lambda) = %.6e, max Re(lambda) = %.6e\n', min(real(lam)), max(real(lam)));
fprintf('max |Im(lambda)| = %.6e\n', max(abs(imag(lam))));
r_eig = norm(M * Vw - Vw * D, 'fro');
fprintf('||M*V - V*D||_F = %.3e (residuum spektralne)\n', r_eig);

%% Zapis liczb do LaTeX (wiersze tabeli)
out_tex = '../LaTeX/wyniki_auto.tex';
fid = fopen(out_tex, 'w');
if fid < 0
  warning('nie udalo sie zapisac %s', out_tex);
else
  fprintf(fid, '%% auto-generated przez solution.m\n');
  fprintf(fid, '\\newcommand{\\ValNOne}{%.6e}\n', n1);
  fprintf(fid, '\\newcommand{\\ValNTwo}{%.6e}\n', n2);
  fprintf(fid, '\\newcommand{\\ValNInf}{%.6e}\n', ninf);
  fprintf(fid, '\\newcommand{\\ValNSchat}{%.6e}\n', n_schat);
  fprintf(fid, '\\newcommand{\\ValCOne}{%.6e}\n', c1);
  fprintf(fid, '\\newcommand{\\ValCTwo}{%.6e}\n', c2);
  fprintf(fid, '\\newcommand{\\ValCInf}{%.6e}\n', cinf);
  fprintf(fid, '\\newcommand{\\ValCSchat}{%.6e}\n', k_schat);
  fprintf(fid, '\\newcommand{\\ValSigmaMin}{%.6e}\n', min(diag(Sdiag)));
  fprintf(fid, '\\newcommand{\\ValSigmaMax}{%.6e}\n', max(diag(Sdiag)));
  fprintf(fid, '\\newcommand{\\ValSVDRes}{%.6e}\n', res_svd);
  fprintf(fid, '\\newcommand{\\ValRcond}{%.6e}\n', rc);
  fprintf(fid, '\\newcommand{\\ValEigRes}{%.6e}\n', r_eig);
  fprintf(fid, '\\newcommand{\\ValCOneDef}{%.6e}\n', c1_def);
  fprintf(fid, '\\newcommand{\\ValCTwoDef}{%.6e}\n', c2_def);
  fprintf(fid, '\\newcommand{\\ValCInfDef}{%.6e}\n', cinf_def);
  fclose(fid);
  fprintf('\nZapisano fragment tabeli: %s\n', out_tex);
endif

%% Dane pod wykresy (Python): normy macierzy M oraz rozklad cond(A,2) dla losowych A
dlmwrite('../LaTeX/norms_bar.txt', [n1; n2; ninf; n_schat], 'precision', 12);
ns = 250;
c2samp = zeros(ns, 1);
for kk = 1:ns
  rng(1000 + kk);
  Atry = rand(n, n);
  if rcond(Atry) >= 1e-14
    c2samp(kk) = cond(Atry, 2);
  else
    c2samp(kk) = NaN;
  endif
endfor
c2samp = c2samp(~isnan(c2samp));
dlmwrite('../LaTeX/cond_samples.txt', c2samp, 'precision', 8);
fprintf('Zapisano norms_bar.txt, cond_samples.txt (%d prob)\n', length(c2samp));
