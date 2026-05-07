%% benchmark_svd — pomiar czasu sciezek SVD vs svd(A); zapisuje LaTeX/benchmark_auto.tex
function benchmark_svd()
  this_dir = fileparts(mfilename('fullpath'));
  latex_dir = fullfile(this_dir, '..', 'LaTeX');
  sizes = [4 6; 40 60; 400 600];
  nrep = 5;

  fid = fopen(fullfile(latex_dir, 'benchmark_auto.tex'), 'w');
  if fid < 0
    warning('benchmark_svd: nie mozna zapisac benchmark_auto.tex');
    return;
  endif

  fprintf(fid, '%% auto-generated przez benchmark_svd.m\n');
  fprintf(fid, '\\begin{table}[htbp]\\centering\\small\n');
  fprintf(fid, '\\caption{Sredni czas pojedynczego przebiegu (piec powtorzen; losowa macierz $\\mathcal{N}(0,1)$ na rozmiarze $n\\times m$). ');
  fprintf(fid, 'Sciezki jak w \\texttt{solution.m}; \\texttt{svd(A)} wywoluje biblioteke numeryczna (LAPACK).}\n');
  fprintf(fid, '\\label{tab:benchmark}\n');
  fprintf(fid, '\\begin{tabular}{@{}lrrr@{}}\\toprule\n');
  fprintf(fid, 'Rozmiar & $AA^{\\mathsf T}$ [ms] & $A^{\\mathsf T}A$ [ms] & \\texttt{svd(A)} [ms] \\\\\n');
  fprintf(fid, '\\midrule\n');

  for si = 1:rows(sizes)
    n = sizes(si, 1);
    m = sizes(si, 2);
    ta = zeros(nrep, 1);
    tb = zeros(nrep, 1);
    tc = zeros(nrep, 1);
    for ri = 1:nrep
      rng(1000 * si + ri);
      A = randn(n, m);
      ta(ri) = time_path_aa(A);
      rng(2000 * si + ri);
      A = randn(n, m);
      tb(ri) = time_path_ata(A);
      rng(3000 * si + ri);
      A = randn(n, m);
      tc(ri) = time_path_svd(A);
    endfor
    ma = mean(ta) * 1000;
    mb = mean(tb) * 1000;
    mc = mean(tc) * 1000;
    fprintf(fid, '$%d\\times %d$ & %.3f & %.3f & %.3f \\\\\n', n, m, ma, mb, mc);
  endfor

  fprintf(fid, '\\bottomrule\n\\end{tabular}\n\\end{table}\n');
  fclose(fid);
  fprintf('benchmark_svd: zapisano benchmark_auto.tex\n');
endfunction

function t = time_path_aa(A)
  n = rows(A);
  m = columns(A);
  tic;
  AAT = A * A';
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
  V1 = A' * U1 * Sigma1_pinv;
  recon1 = U1 * Sigma1 * V1';
  dummy = norm(A - recon1, 'fro'); %#ok<NASGU>
  t = toc;
endfunction

function t = time_path_ata(A)
  n = rows(A);
  m = columns(A);
  tic;
  ATA = A' * A;
  [V_e, D_v] = eig(ATA);
  lam_ATA = real(diag(D_v));
  [lam_ATA, ord2] = sort(lam_ATA, 'descend');
  V2 = real(V_e(:, ord2));
  sigma2 = sqrt(max(0, lam_ATA));
  Sigma2 = diag(sigma2);
  tol = max(n, m) * eps * max([max(sigma2); 1e-16]);
  inv_sigma2 = zeros(m, 1);
  for i = 1:m
    if sigma2(i) > tol
      inv_sigma2(i) = 1 / sigma2(i);
    endif
  endfor
  Sigma2_pinv = diag(inv_sigma2);
  U2 = A * V2 * Sigma2_pinv;
  recon2 = U2 * Sigma2 * V2';
  dummy = norm(A - recon2, 'fro'); %#ok<NASGU>
  t = toc;
endfunction

function t = time_path_svd(A)
  tic;
  [Us, Ss, Vs] = svd(A);
  recon_svd = Us * Ss * Vs';
  dummy = norm(A - recon_svd, 'fro'); %#ok<NASGU>
  t = toc;
endfunction
