function U = gauss_elim_diag1(A)
% Gauss bez pivotingu: skalowanie wiersza pivotu do 1 na przekatnej.
  U = A;
  n = rows(U);
  for k = 1:n
    p = U(k, k);
    if abs(p) < eps * (1 + norm(U(:, k), inf))
      error('gauss_elim_diag1: zerowy pivot w kolumnie %d', k);
    endif
    U(k, :) = U(k, :) / p;
    for i = (k + 1):n
      U(i, :) = U(i, :) - U(i, k) * U(k, :);
    endfor
  endfor
endfunction
