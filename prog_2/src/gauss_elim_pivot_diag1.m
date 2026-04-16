function U = gauss_elim_pivot_diag1(A)
% Gauss z czesciowym pivotingiem wierszowym; jedynki na przekatnej po skalowaniu.
  U = A;
  n = rows(U);
  for k = 1:n
    [~, rel] = max(abs(U(k:n, k)));
    piv = rel + k - 1;
    if piv != k
      tmp = U(k, :);
      U(k, :) = U(piv, :);
      U(piv, :) = tmp;
    endif
    p = U(k, k);
    if abs(p) < eps * (1 + norm(U(:, k), inf))
      error('gauss_elim_pivot_diag1: zly pivot w kolumnie %d', k);
    endif
    U(k, :) = U(k, :) / p;
    for i = (k + 1):n
      U(i, :) = U(i, :) - U(i, k) * U(k, :);
    endfor
  endfor
endfunction
