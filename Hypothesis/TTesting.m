% -------------------------------------------------------------------------
% When using TTest(SIDE, NU, ALPHA, TSTAT), 
% 
% SIDE indicates the side of the hypothesis test. Input for SIDE can be any
% of the three following:
%   - 'RightSided' for a right-tailed t-test
%   - 'LeftSided' for a left-tailed t-test
%   - 'TwoSided' for a two-tailed t-test
% 
% NU is the degrees of freedom and can be any positive valued integer.
%
% ALPHA denotes the significance level. The input for ALPHA can be any real
% valued number on the interval (0,1).
% 
% TSTAT is the manually derived t-statistic, which can take on any finite
% value. This input argument is optional and in case input is given, the
% function plots the manually calculated test statistic valued TSTAT and
% show whether the null hypothesis can or cannot be rejected.
%
% The size of the plot is predetermined and can be customized by changing
% the values of TTR.scale, TTL.scale, TTTS.scale in their corresponding
% function files.
%
% TTest(SIDE, NU, ALPHA, TSTAT)
% -------------------------------------------------------------------------
% Example
TTest('TwoSided', 35, 0.05, -2.3)