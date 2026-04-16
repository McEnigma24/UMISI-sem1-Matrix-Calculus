function [L, U] = lu_doolittle_nopivot(A)
% LU (Doolittle): L dolnotrojkatna z jedynkami na przekatnej, U gornotrojkatna.
  n = rows(A);
  U = A;
  L = eye(n);
  for k = 1:(n - 1)
    if abs(U(k, k)) < eps * (1 + norm(U(:, k), inf))
      error('lu_doolittle_nopivot: zerowy pivot U(%d,%d)', k, k);
    endif
    for i = (k + 1):n
      L(i, k) = U(i, k) / U(k, k);
      U(i, k:n) = U(i, k:n) - L(i, k) * U(k, k:n);
    endfor
  endfor
endfunction
