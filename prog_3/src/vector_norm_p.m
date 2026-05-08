function n = vector_norm_p(x, p)
% Norma wektorowa lp: (sum |x_i|^p)^(1/p); dla p=Inf: max |x_i|.
  x = x(:);
  if isinf(p) && p > 0
    n = max(abs(x));
  else
    n = (sum(abs(x) .^ p)) ^ (1 / p);
  endif
endfunction
