%% Zapisuje macierz liczbową jako fragment LaTeX (tabular + resizebox).
function latex_matrix_table(fid, M, caption, label)
  if fid < 0
    return;
  endif
  [nr, nc] = size(M);
  fprintf(fid, '\\begin{table}[htbp]\\centering\\small\n');
  fprintf(fid, '\\caption{%s}\\label{%s}\n', caption, label);
  fprintf(fid, '\\resizebox{\\linewidth}{!}{%%\n');
  fprintf(fid, '\\begin{tabular}{%s}\n', repmat('r', 1, nc));
  fprintf(fid, '\\toprule\n');
  for i = 1:nr
    fprintf(fid, '%.5f', M(i, 1));
    for j = 2:nc
      fprintf(fid, ' & %.5f', M(i, j));
    endfor
    fprintf(fid, ' \\\\\n');
  endfor
  fprintf(fid, '\\bottomrule\n\\end{tabular}}\n\\end{table}\n\n');
endfunction
