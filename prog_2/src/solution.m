%% Rachunek Macierzowy - program 2
% Gauss (z/bez pivotingu, jedynki na przekatnej) oraz LU (z/bez pivotingu).
% Uruchom z katalogu src/:  run('solution.m')

clear all;
clc;

% n = miesiac + dzien urodzenia (wg polecenia; tutaj 8+24).
m_ur = 8;
d_ur = 24;
n = m_ur + d_ur;

fprintf('Rachunek Macierzowy, prog. 2: n = %d (miesiac=%d + dzien=%d)\n', n, m_ur, d_ur);

rng(7);
A = rand(n, n);
if rcond(A) < 1e-14
  error('losowa macierz zle uwarunkowana - zmien ziarno lub n');
endif

fprintf('\n--- 1) Gauss bez pivotingu (jedynki na przekatnej) ---\n');
U1 = gauss_elim_diag1(A);
fprintf('||tril(U1,-1)||_F = %.3e (oczekiwane ~0)\n', norm(tril(U1, -1), 'fro'));
fprintf('max|diag(U1)-1| = %.3e\n', max(abs(diag(U1) - 1)));

fprintf('\n--- 2) Gauss z pivotingiem (jedynki na przekatnej) ---\n');
U2 = gauss_elim_pivot_diag1(A);
fprintf('||tril(U2,-1)||_F = %.3e\n', norm(tril(U2, -1), 'fro'));
fprintf('max|diag(U2)-1| = %.3e\n', max(abs(diag(U2) - 1)));

fprintf('\n--- 4) LU bez pivotingu ---\n');
[L4, U4] = lu_doolittle_nopivot(A);
res4 = norm(A - L4 * U4, 'fro');
fprintf('||A - L*U||_F = %.3e\n', res4);

fprintf('\n--- 5) LU z pivotingiem (P*A = L*U) ---\n');
[L5, U5, P5] = lu_doolittle_pivot(A);
res5 = norm(P5 * A - L5 * U5, 'fro');
fprintf('||P*A - L*U||_F = %.3e\n', res5);

fprintf('\n--- Porownanie z lu(A) ---\n');
[L0, U0, P0] = lu(A);
fprintf('||P0*A - L0*U0||_F = %.3e\n', norm(P0 * A - L0 * U0, 'fro'));

fprintf('\n--- Przyklad 2x2 wymagajacy pivotingu ---\n');
B = [eps, 1; 1, 1];
fprintf('B = [eps, 1; 1, 1], Gauss z pivotingiem:\n');
Ub = gauss_elim_pivot_diag1(B);
disp(Ub);
