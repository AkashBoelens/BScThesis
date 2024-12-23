function TTTS = TTestTwoSided(nu, alpha, tstat)
%TTESTTWOSIDED Visualize a two sided Student's t-test 
%   TTTS = TTestTwoSided(NU, ALPHA, TSTAT) plots the theoretical 
%   student's t-distribution with NU degrees of freedom. It calculates the
%   two critical values corresponding to a two sided t-test with NU degrees
%   of freedom at an ALPHA level of significance and plots the related
%   rejection regions. A vertical line representing the manually calculated
%   test statistic valued TSTAT will be plotted, this input argument is 
%   optional.

% -------------------------------------------------------------------------
% Check whether the input is valid.
% -------------------------------------------------------------------------
if (nu <= 0)
    uiwait(warndlg('The degrees of freedom should be larger than zero.'));
    return
elseif (mod(nu, 1) ~= 0)
    uiwait(warndlg(['Please fill in an integer for the degrees of ' ...
        'freedom.']));
    return
elseif (alpha <= 0 || alpha >= 1)
    uiwait(warndlg(['Please fill in a value of alpha between zero and ' ...
        'one.']));
    return
end

% -------------------------------------------------------------------------
% Check if the user wants to plot the test statistic.
% -------------------------------------------------------------------------
if (nargin == 3)
    TTTS.Display = 1;
else 
    TTTS.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical values.
% -------------------------------------------------------------------------
TTTS.CV = icdf('T', 1-alpha/2, nu);
TTTS.CVleft = -TTTS.CV;
TTTS.CVright = TTTS.CV;

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical values as having only one or two degrees of freedom can result
% in large critical values. In most cases however, the critical values are
% relatively small and [-5, 5] is a good interval to display the curve of 
% the student's t-distribution and the crititcal values.
% -------------------------------------------------------------------------
TTTS.xmin = min([TTTS.CVleft-1 -5]);
TTTS.xmax = max([TTTS.CVright+1 5]);
TTTS.x = TTTS.xmin:0.01:TTTS.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
TTTS.y = pdf('T', TTTS.x, nu);

% -------------------------------------------------------------------------
% Calculating the rejection regions, as these areas need to be shown in the
% plot.
% -------------------------------------------------------------------------
TTTS.xleft = TTTS.xmin:0.001:TTTS.CVleft;
TTTS.xright = TTTS.CVright:0.001:TTTS.xmax;
TTTS.yleft = pdf('T', TTTS.xleft, nu);
TTTS.yright = pdf('T', TTTS.xright, nu);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the test statistic
% and calculate the p value. TTTS.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. TTTS.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. The standard 4:3 ratio is
% used. TTTS.scale scales the graph with respect to the monitor size of the
% user. xticks is used as it is necessary to show the exact critical value
% on the horizontal axis.
% -------------------------------------------------------------------------
TTTS.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
TTTS.nodec = sprintf('%%.%df', 0);
TTTS.variables = sprintf(['\\alpha = ', TTTS.alphadec, ', \\nu = ', ...
    TTTS.nodec], alpha, nu);

TTTS.mp = get(0, 'MonitorPositions');
TTTS.mwidth = TTTS.mp(1, 3);
TTTS.mheight = TTTS.mp(1, 4);
TTTS.scale = 0.45;

TTTS.gwidth = TTTS.scale*TTTS.mwidth;
TTTS.gheight = 0.75*TTTS.gwidth;
TTTS.x0 = 0.5*TTTS.mwidth*(1 - TTTS.scale);
TTTS.y0 = (TTTS.mheight - TTTS.gheight - 84)*0.5;

figure
plot(TTTS.x,TTTS.y,'-black');
xticks([TTTS.CVleft 0 TTTS.CVright]);
title("t-distribution");
subtitle({TTTS.variables}, 'Interpreter', 'tex');
xlabel("t-value");
ylabel("Density");
TTTS.fig = gcf;
TTTS.fig.Position = [TTTS.x0, TTTS.y0, TTTS.gwidth, TTTS.gheight];
hold on

% -------------------------------------------------------------------------
% Marking the critical values in the plot.
% -------------------------------------------------------------------------
xline([TTTS.CVleft TTTS.CVright], 'LineStyle', ':', 'Color', '#9a9afc', ...
    'LineWidth', 1.4);

% -------------------------------------------------------------------------
% Filling the areas of the rejection region.
% -------------------------------------------------------------------------
TTTS.arleft = area(TTTS.xleft, TTTS.yleft);
TTTS.arleft.FaceColor = 'blue';
TTTS.arleft.FaceAlpha = 0.15;
TTTS.arleft.EdgeColor = 'none';

TTTS.arright = area(TTTS.xright, TTTS.yright);
TTTS.arright.FaceColor = 'blue';
TTTS.arright.FaceAlpha = 0.15;
TTTS.arright.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated test statistic
% and compute the corresponding p value. This part of the code will only
% run when there is input for the third argument (the value of the test
% statistic). In the case that there is no input for the third argument,
% the p value will not be calculated and the function has finished running.
% 
% The first nested if else statement will check, on the condition that the
% user gave input for the third argument, if the absolute value of the test
% statistic is smaller than the critical value. If this is the case, the
% null hypothesis cannot be rejected and a vertical light purple dotted
% line corresponding to the value of the test statistic and light purple
% shaded areas representing the p value will be added to the plot. Else,
% the null can be rejected and a purple vertical dotted line corresponding
% to the value of the test statistic and dark purple shaded areas
% displaying the p value will be plotted.
%
% Afterwards the subtitle will be updated and the code has finished 
% running.
% -------------------------------------------------------------------------
if (TTTS.Display == 1)
    if (abs(tstat) < TTTS.CV)
        xline(tstat, 'LineStyle', ':', 'Color', '#ae9ab5', 'LineWidth', ...
            1.4);
        TTTS.tintleft = TTTS.CVleft:0.001:-abs(tstat);
        TTTS.tintright = abs(tstat):0.001:TTTS.CVright;

        TTTS.tyl = pdf('T', TTTS.tintleft, nu);
        TTTS.tlar = area(TTTS.tintleft, TTTS.tyl);
        TTTS.tlar.FaceColor = '#8a22b3';
        TTTS.tlar.FaceAlpha = 0.04;
        TTTS.tlar.EdgeColor = 'none';

        TTTS.tyr = pdf('T', TTTS.tintright, nu);
        TTTS.trar = area(TTTS.tintright, TTTS.tyr);
        TTTS.trar.FaceColor = '#8a22b3';
        TTTS.trar.FaceAlpha = 0.04;
        TTTS.trar.EdgeColor = 'none';
    else
        xline(tstat, 'LineStyle', ':', 'Color','#8a22b3', 'LineWidth', ...
            1.4);
        TTTS.tintleft = TTTS.xmin:0.001:-abs(tstat);
        TTTS.tintright = abs(tstat):0.001:TTTS.xmax;
            
        TTTS.tyl = pdf('T', TTTS.tintleft, nu);
        TTTS.tlar = area(TTTS.tintleft, TTTS.tyl);
        TTTS.tlar.FaceColor = '#8a22b3';
        TTTS.tlar.FaceAlpha = 1;
        TTTS.tlar.EdgeColor = 'none';

        TTTS.tyr = pdf('T', TTTS.tintright, nu);
        TTTS.trar = area(TTTS.tintright, TTTS.tyr);
        TTTS.trar.FaceColor = '#8a22b3';
        TTTS.trar.FaceAlpha = 1;
        TTTS.trar.EdgeColor = 'none';
    end
    TTTS.pval = 2*cdf('T', -abs(tstat), nu);
    TTTS.empdec = sprintf('%%.%df', 4);
    TTTS.pdec = sprintf('%%.%df', 4);
    TTTS.tp = sprintf(['Test statistic = ', TTTS.empdec,', p value = ', ...
        TTTS.pdec], tstat, TTTS.pval);
    subtitle({TTTS.variables, TTTS.tp}, 'Interpreter', 'tex');
end