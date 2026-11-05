pkg load econometrics
addpath("~/google-svn/octave/matdcd/inst");

# file_list = argv (); 
gl = glob("/scratch2/polysol/pdata/poly.*");
file_list = gl;
ncut=1;
domain = [600, 31, 10];
ysize = domain(2);
XcmStore = [];
YcmStore = [];
XStore = [];

for n=1:length(file_list)
  dcdfile=file_list{n};
  warning("processing: %s\n", dcdfile);
  try 
    R = polymer_readpunto(dcdfile);
  catch
    continue
  end_try_catch
  R = R(ncut:end, :, :);
  R = polymer_unwrap_one(R, domain);
  Rcm = polymer_cm (R);
  Xcm = Rcm(:, 1)';  
  Ycm = Rcm(:, 2)';
  [X, Y, Z] = polymer_extension (R);

  idx = (Ycm > 0.2*ysize ) & (Ycm < 0.8*ysize);

  YcmStore = [YcmStore Ycm(idx)];
  XcmStore = [XcmStore Xcm(idx)];
  XStore = [XStore X(idx)];
  size(XStore)
endfor

fit = kernel_regression((1:600)', XStore', XcmStore', 0.01);
plot((1:600)/600.0, fit, 'rx');