%% Laboratorium 3 — eliminacja Gaussa i faktoryzacja LU
% Zadanie: macierz n×n, n = miesiąc urodzenia + dzień urodzenia.
% Uzupełnij poniższe wartości swoimi danymi:
miesiac_ur = 4;
dzien_ur   = 16;
n = miesiac_ur + dzien_ur;

fprintf('Rozmiar macierzy n = %d (miesiąc + dzień)\n\n', n);

rng(1);
% Macierz z silną dominacją przekątniową — eliminacja bez pivotingu jest stabilna
A = rand(n, n) + n * eye(n);

%% 1) Eliminacja Gaussa bez pivotingu, jedynki na przekątnej (slajd 14)
U1 = gauss_no_pivot_unit_diag(A);
fprintf('1) Gauss bez pivotingu: ||U - triu(U)||_F = %.3e\n', ...
    norm(U1 - triu(U1), 'fro'));
fprintf('   Jedynki na przekątnej: max|diag(U)-1| = %.3e\n\n', ...
    max(abs(diag(U1) - 1)));

%% 2) Eliminacja Gaussa z pivotingiem częściowym (slajd 26)
U2 = gauss_partial_pivot_unit_diag(A);
fprintf('2) Gauss z pivotingiem: ||U - triu(U)||_F = %.3e\n', ...
    norm(U2 - triu(U2), 'fro'));
fprintf('   Jedynki na przekątnej: max|diag(U)-1| = %.3e\n\n', ...
    max(abs(diag(U2) - 1)));

%% 4) LU bez pivotingu (slajd 33)
[L4, U4] = lu_factor_no_pivot(A);
err_lu4 = norm(A - L4 * U4, 'fro');
fprintf('4) LU bez pivotingu: ||A - L*U||_F = %.3e\n', err_lu4);
fprintf('   L dolnotrójkątna (diag=1), U górnotrójkątna\n\n');

%% 5) LU z pivotingiem: P*A = L*U (slajd 36)
[L5, U5, P5] = lu_factor_with_pivot(A);
err_lu5 = norm(P5 * A - L5 * U5, 'fro');
fprintf('5) LU z pivotingiem: ||P*A - L*U||_F = %.3e\n', err_lu5);

%% Porównanie z wbudowanym [L,U,P] = lu(A)
[Lm, Um, Pm] = lu(A);
% MATLAB: Pm*A = Lm*Um; Lm ma permutowane wiersze — porównaj rezydual
fprintf('   MATLAB lu: ||P*A - L*U||_F = %.3e\n', norm(Pm * A - Lm * Um, 'fro'));

%% --- Funkcje lokalne ---

function U = gauss_no_pivot_unit_diag(A)
    % Eliminacja w przód: w każdej kolumnze k najpierw skalujemy wiersz k,
    % aby uzyskać 1 na przekątnej, potem zerujemy elementy poniżej.
    U = A;
    n = size(U, 1);
    tol = 1e-12;
    for k = 1:n
        p = U(k, k);
        if abs(p) < tol
            error('gauss_no_pivot_unit_diag:ZeroPivot', ...
                'Zerowy pivot w kroku %d — bez pivotingu algorytm nie działa.', k);
        end
        U(k, :) = U(k, :) / p;
        for i = k + 1:n
            U(i, :) = U(i, :) - U(i, k) * U(k, :);
        end
    end
end

function U = gauss_partial_pivot_unit_diag(A)
    U = A;
    n = size(U, 1);
    tol = 1e-12;
    for k = 1:n
        [~, r] = max(abs(U(k:n, k)));
        r = r + k - 1;
        if r ~= k
            tmp = U(k, :);
            U(k, :) = U(r, :);
            U(r, :) = tmp;
        end
        p = U(k, k);
        if abs(p) < tol
            error('gauss_partial_pivot_unit_diag:Singular', ...
                'Macierz osobliwa lub pivot bliski zeru w kroku %d.', k);
        end
        U(k, :) = U(k, :) / p;
        for i = k + 1:n
            U(i, :) = U(i, :) - U(i, k) * U(k, :);
        end
    end
end

function [L, U] = lu_factor_no_pivot(A)
    % Doolittle: L jednostkowa na przekątnej, A = L*U (bez zamian wierszy).
    n = size(A, 1);
    U = A;
    L = eye(n);
    tol = 1e-14;
    for k = 1:n - 1
        if abs(U(k, k)) < tol
            error('lu_factor_no_pivot:ZeroPivot', ...
                'U(%d,%d)=0 — LU bez pivotingu nie istnieje (minor zerowy).', k, k);
        end
        for i = k + 1:n
            L(i, k) = U(i, k) / U(k, k);
            U(i, k:n) = U(i, k:n) - L(i, k) * U(k, k:n);
        end
    end
end

function [L, U, P] = lu_factor_with_pivot(A)
    % PA = LU, P — macierz permutacji (wierszowa), L dolna z jedynkami na diag.
    n = size(A, 1);
    U = A;
    L = eye(n);
    P = eye(n);
    tol = 1e-14;
    for k = 1:n - 1
        [~, r] = max(abs(U(k:n, k)));
        r = r + k - 1;
        if r ~= k
            U([k, r], :) = U([r, k], :);
            P([k, r], :) = P([r, k], :);
            if k > 1
                L([k, r], 1:k - 1) = L([r, k], 1:k - 1);
            end
        end
        if abs(U(k, k)) < tol
            error('lu_factor_with_pivot:Singular', 'Pivot zerowy w kroku %d.', k);
        end
        for i = k + 1:n
            L(i, k) = U(i, k) / U(k, k);
            U(i, k:n) = U(i, k:n) - L(i, k) * U(k, k:n);
        end
    end
end
