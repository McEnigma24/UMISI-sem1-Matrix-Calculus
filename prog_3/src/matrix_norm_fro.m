function n = matrix_norm_fro(M)
% Norma Frobeniusa ||M||_F = sqrt(sum_{i,j} |m_ij|^2).
  n = sqrt(sum(sum(abs(M) .^ 2)));
endfunction
