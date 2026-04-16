function ms = bench_ms(fn, repeats)
  fn();
  tic;
  for r = 1:repeats
    fn();
  endfor
  ms = toc / repeats * 1000;
endfunction
