function c = matrix_cond_induced(M, p)
% Wspolczynnik uwarunkowania w normie indukowanej: kappa_p(M) = ||M||_p ||M^{-1}||_p.
% Dla p=2: sigma_max/sigma_min (bez jawnego odwracania macierzy).
  if p == 2
    s = svd(M);
    smin = min(s);
    if smin <= 0
      c = inf;
    else
      c = max(s) / smin;
    endif
  elseif p == 1 || isinf(p)
    Minv = inv(M);
    c = matrix_norm_induced(M, p) * matrix_norm_induced(Minv, p);
  else
    error('matrix_cond_induced: obslugiwane jest tylko p = 1, 2 lub Inf');
  endif
endfunction
