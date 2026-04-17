function [lam, v, hist] = power_method_symmetric(Awork, eps_stop, precheck)
% Jedna para wlasna symetrycznej Awork; historia bledu ||A z - mu z||_p w kolumnach 2..6.
  maxit = 400;
  z = rand(3, 1);
  for guard = 1:80
    zn = z / norm(z, 2);
    mu = (zn' * Awork * zn) / (zn' * zn);
    pre = norm(Awork * zn - mu * zn, 2);
    if pre >= precheck
      z = zn;
      break;
    endif
    z = rand(3, 1);
  endfor

  hist = zeros(maxit, 6);
  z = z / norm(z, 2);
  for it = 1:maxit
    mu = (z' * Awork * z) / (z' * z);
    r = Awork * z - mu * z;
    hist(it, 1) = it;
    hist(it, 2) = norm(r, 1);
    hist(it, 3) = norm(r, 2);
    hist(it, 4) = norm(r, 3);
    hist(it, 5) = norm(r, 4);
    hist(it, 6) = norm(r, Inf);
    if hist(it, 3) < eps_stop
      hist = hist(1:it, :);
      break;
    endif
    z = Awork * z;
    nz = norm(z, 2);
    if nz < 1e-300
      break;
    endif
    z = z / nz;
  endfor
  z = z / norm(z, 2);
  lam = (z' * Awork * z) / (z' * z);
  v = z;
endfunction
