function write_bmatrix(path, M)
  fid = fopen(path, 'w');
  if fid < 0
    return;
  endif
  [r, c] = size(M);
  fprintf(fid, '\\begin{bmatrix}\n');
  for i = 1:r
    for j = 1:c - 1
      fprintf(fid, '%.6f & ', M(i, j));
    endfor
    fprintf(fid, '%.6f \\\\\n', M(i, c));
  endfor
  fprintf(fid, '\\end{bmatrix}\n');
  fclose(fid);
endfunction
