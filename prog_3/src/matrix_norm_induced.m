function n = matrix_norm_induced(M, p)
% Norma macierzowa indukowana (operatorowa) ||M||_p dla p w {1, 2, Inf}.
% ||M||_1  = max_j sum_i |M_ij|   (maks. suma kolumnowa modulow)
% ||M||_inf = max_i sum_j |M_ij| (maks. suma wierszowa modulow)
% ||M||_2  = sigma_max(M)       (najwieksza wartosc osobliwa; SVD z biblioteki)
  if p == 1
    n = max(sum(abs(M), 1));
  elseif p == 2
    n = max(svd(M));
  elseif isinf(p)
    n = max(sum(abs(M), 2));
  else
    error('matrix_norm_induced: obslugiwane jest tylko p = 1, 2 lub Inf');
  endif
endfunction
