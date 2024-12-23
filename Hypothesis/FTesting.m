% -------------------------------------------------------------------------
% When using  FTest(SIDE, NU1, NU2, ALPHA, TSTAT),
%
% SIDE indicates the side of the hypothesis test. Input for SIDE can be any
% of the three following:
%   - 'RightSided' for a right-tailed F-test
%   - 'LeftSided' for a left-tailed F-test
%   - 'TwoSided' for a two-tailed F-test
% 
% NU1 and NU2 are the degrees of freedom and can be any positive valued
% integer.
%
% ALPHA denotes the significance level. The input for ALPHA can be any real
% valued number on the interval (0,1).
%
% TSTAT is the manually derived F-statistic, which can take on any
% nonnegative value. This input argument is optional and in case input is
% given, the function plots the manually calculated test statistic valued
% TSTAT and show whether the null hypothesis can or cannot be rejected.
%
% The size of the plot is predetermined and can be customized by changing
% the values of FTR.scale, FTL.scale, FTTS.scale in their corresponding
% function files.
%
% FTest(SIDE, NU1, NU2, ALPHA, TSTAT)
% -------------------------------------------------------------------------
% Example
FTest('RightSided', 30, 20, 0.05, 1.8)