%% Generuje matrix_tables_auto.tex — tabele liczb dla raportu LaTeX.
function write_matrix_tables(latex_dir, A, AAT, ATA, V1T, V2T, U2, n, m)
  fname = fullfile(latex_dir, 'matrix_tables_auto.tex');
  fid = fopen(fname, 'w');
  if fid < 0
    warning('write_matrix_tables: nie mozna zapisac %s', fname);
    return;
  endif
  fprintf(fid, '%% auto-generated przez solution.m\n');
  cap_A = sprintf('Macierz testowa $A$ ($%d\\times %d$)', n, m);
  latex_matrix_table(fid, A, cap_A, 'tab:matrixA');
  cap_aat = sprintf('$AA^{\\mathsf T}$ ($%d\\times %d$)', n, n);
  latex_matrix_table(fid, AAT, cap_aat, 'tab:matrixAAT');
  cap_ata = sprintf('$A^{\\mathsf T}A$ ($%d\\times %d$)', m, m);
  latex_matrix_table(fid, ATA, cap_ata, 'tab:matrixATA');
  cap_v1 = sprintf('$V^{\\mathsf T}$ ze ścieżki $AA^{\\mathsf T}$');
  latex_matrix_table(fid, V1T, cap_v1, 'tab:matrixV1T');
  cap_v2 = sprintf('$V^{\\mathsf T}$ ze ścieżki $A^{\\mathsf T}A$');
  latex_matrix_table(fid, V2T, cap_v2, 'tab:matrixV2T');
  cap_u2 = sprintf('$U$ ze ścieżki $A^{\\mathsf T}A$ ($%d\\times %d$)', n, m);
  latex_matrix_table(fid, U2, cap_u2, 'tab:matrixU2');
  fclose(fid);
endfunction
