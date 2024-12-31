% -------------------------------------------------------------------------
% When using CSTest(SIDE, NU, ALPHA, TSTAT),
%
% SIDE indicates the side of the hypothesis test. Input for SIDE can be any
% of the three following:
%   - 'RightSided' for a right-tailed Chi-squared test
%   - 'LeftSided' for a left-tailed Chi-squared test
%   - 'TwoSided' for a two-tailed Chi-squared test
% 
% NU is the degrees of freedom and can be any positive valued integer.
%
% ALPHA denotes the significance level. The input for ALPHA can be any real
% valued number on the interval (0,1).
%
% TSTAT is the manually derived Chi-square statistic, which can take on
% any nonnegative value. This input argument is optional and in case input
% is given, the function plots the manually calculated test statistic
% valued TSTAT and show whether the null hypothesis can or cannot be
% rejected.
%
% The size of the plot is predetermined and can be customized by changing
% the values of CSTR.scale, CSTL.scale, CSTTS.scale in their corresponding
% function files.
%
% CSTest(SIDE, NU, ALPHA, TSTAT)
% -------------------------------------------------------------------------
% Example
CSTest('RightSided', 6, 0.05, 9)