function [nrm, kappa] = schatten_norm_cond(s, p)
% Norma Schattena (rzad p na wektorze wartosci osobliwych s) oraz
% wspolczynnik uwarunkowania kappa = ||M||_{S,p} * ||M^{-1}||_{S,p}
% przy pelnym rzedzie (wszystkie s > 0).
  nrm = norm(s(:), p);
  if any(s <= 0)
    kappa = inf;
  else
    kappa = norm(s(:), p) * norm(1 ./ s(:), p);
  endif
endfunction
