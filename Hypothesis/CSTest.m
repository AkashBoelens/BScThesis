function CST = CSTest(side, nu, alpha, tstat)
%CSTEST Visualize a Chi-squared test
%   CSTest(SIDE, nu, ALPHA, TSTAT) plots the theoretical
%   Chi-square distribution with NU degrees of freedom. Depending on the
%   input argument for SIDE, it calculates one or two critical values
%   corresponding to a one or two sided Chi-squared test with NU degrees of
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
% when the number of input arguments is equal to three.
% -------------------------------------------------------------------------
if (nargin == 3)
    switch(side)
        case "RightSided"
            CSTestRight(nu, alpha);
        case "LeftSided"
            CSTestLeft(nu, alpha);
        case "TwoSided"
            CSTestTwoSided(nu, alpha);
        otherwise
            uiwait(warndlg(['Please specify the correct side, right, ' ...
                'left or two sided']))
            return
    end
else
    switch(side)
        case "RightSided"
            CSTestRight(nu, alpha, tstat);
        case "LeftSided"
            CSTestLeft(nu, alpha,tstat);
        case "TwoSided"
            CSTestTwoSided(nu, alpha, tstat);
        otherwise
            uiwait(warndlg(['Please specify the correct side, right, ' ...
                'left or two sided']))
            return
    end
end
