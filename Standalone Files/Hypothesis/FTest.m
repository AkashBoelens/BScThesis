function FT = FTest(side, nu1, nu2, alpha, tstat)
%FTEST Visualize an F-test
%   FTest(SIDE, NU1, NU2, ALPHA, TSTAT) plots the theoretical
%   F-distribution with NU1 and NU2 degrees of freedom. Depending on the
%   input argument for SIDE, it calculates one or two critical values
%   corresponding to a one or two sided F-test with NU1 and NU2 degrees of
%   freedom at an ALPHA level of significance and plots the related
%   rejection region(s). A vertical line representing the manually
%   calculated test statistic valued TSTAT will be plotted as well, this
%   input argument is optional.
%
%   SIDE can be:
%      'RightSided',
%      'LeftSided',
%      'TwoSided'.

% -------------------------------------------------------------------------
% Check if the user does not want to plot the test statistic, which happens
% when the number of input arguments is equal to four.
% -------------------------------------------------------------------------
if (nargin == 4)
    switch(side)
        case "RightSided"
            FTestRight(nu1, nu2, alpha);
        case "LeftSided"
            FTestLeft(nu1, nu2, alpha);
        case "TwoSided"
            FTestTwoSided(nu1, nu2, alpha);
        otherwise
            uiwait(warndlg(['Please specify the correct side, right, ' ...
                'left or two sided']))
            return
    end
else
    switch(side)
        case "RightSided"
            FTestRight(nu1, nu2, alpha, tstat);
        case "LeftSided"
            FTestLeft(nu1, nu2, alpha,tstat);
        case "TwoSided"
            FTestTwoSided(nu1, nu2, alpha, tstat);
        otherwise
            uiwait(warndlg(['Please specify the correct side, right, ' ...
                'left or two sided']))
            return
    end
end