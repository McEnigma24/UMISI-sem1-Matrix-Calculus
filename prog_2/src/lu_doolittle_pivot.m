function [L, U, P] = lu_doolittle_pivot(A)
% LU z pivotingiem: P*A = L*U, L jedynki na przekatnej, U gornotrojkatna.
  n = rows(A);
  U = A;
  L = eye(n);
  P = eye(n);
  for k = 1:(n - 1)
    [~, rel] = max(abs(U(k:n, k)));
    piv = rel + k - 1;
    if piv != k
      U([k piv], :) = U([piv k], :);
      P([k piv], :) = P([piv k], :);
      if k > 1
        L([k piv], 1:(k - 1)) = L([piv k], 1:(k - 1));
      endif
    endif
    if abs(U(k, k)) < eps * (1 + norm(U(:, k), inf))
      error('lu_doolittle_pivot: zerowy pivot w kolumnie %d', k);
    endif
    for i = (k + 1):n
      L(i, k) = U(i, k) / U(k, k);
      U(i, k:n) = U(i, k:n) - L(i, k) * U(k, k:n);
    endfor
  endfor
endfunction
