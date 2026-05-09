function [Q, R] = qr_givens(A)
% QR przez obroty Givensa (lewa strona). A prostokatna m x n.
  [m, n] = size(A);
  R = A;
  Q = eye(m);
  for j = 1:min(m, n)
    for i = m:-1:(j + 1)
      a = R(j, j);
      b = R(i, j);
      if hypot(a, b) == 0
        continue;
      endif
      r = hypot(a, b);
      c = a / r;
      s = b / r;
      row_j = c * R(j, :) + s * R(i, :);
      row_i = -s * R(j, :) + c * R(i, :);
      R(j, :) = row_j;
      R(i, :) = row_i;
      col_j = c * Q(:, j) + s * Q(:, i);
      col_i = -s * Q(:, j) + c * Q(:, i);
      Q(:, j) = col_j;
      Q(:, i) = col_i;
    endfor
  endfor
endfunction
