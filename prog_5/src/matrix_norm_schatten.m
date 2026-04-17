function s = matrix_norm_schatten(E, p)
  sv = svd(E);
  s = (sum(sv.^p))^(1 / p);
endfunction
