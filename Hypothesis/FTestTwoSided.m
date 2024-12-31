function FTTS = FTestTwoSided(nu1, nu2, alpha, tstat)
%FTESTTWOSIDED Visualize a two sided F-test
%   FTTS = FTestTwoSided(NU1, NU2, ALPHA, TSTAT) plots the theoretical
%   F-distribution with NU1 and NU2 degrees of freedom. It calculates the
%   two critical values corresponding to a two sided F-test with NU1 and
%   NU2 degrees of freedom at an ALPHA level of significance and plots the
%   related rejection regions. A vertical line representing the manually
%   calculated test statistic valued TSTAT will be plotted, this input
%   argument is optional.

% -------------------------------------------------------------------------
% Check whether the input is valid.
% -------------------------------------------------------------------------
if (nu1 <= 0)
    uiwait(warndlg(['The degrees of freedom of the first population' ...
        ' should be larger than zero.']));
    return
elseif (nu2 <= 0)
    uiwait(warndlg(['The degrees of freedom of the second population' ...
        ' should be larger than zero.']));
    return
elseif (mod(nu1, 1) ~= 0)
    uiwait(warndlg(['Please fill in an integer for the degrees of' ...
        ' freedom of the first population.']));
    return
elseif (mod(nu2, 1) ~= 0)
    uiwait(warndlg(['Please fill in an integer for the degrees of' ...
        ' freedom of the second population.']));
    return
elseif (alpha <= 0 || alpha >= 1)
    uiwait(warndlg(['Please fill in a value of alpha between zero and' ...
        ' one.']));
    return
end

% -------------------------------------------------------------------------
% Check if the user wants to plot the test statistic and make sure that the
% test statistic is nonnegative valued.
% -------------------------------------------------------------------------
if (nargin == 4)
    if (tstat < 0)
        uiwait(warndlg(['The test statistic cannot be negative valued,' ...
            ' please make sure that the test statistic is correctly' ...
            ' calculated.']));
        return
    end
    FTTS.Display = 1;
else 
    FTTS.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical values.
% -------------------------------------------------------------------------
FTTS.CVleft = icdf('F', alpha/2, nu1, nu2);
FTTS.CVright = icdf('F', 1-alpha/2, nu1, nu2);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical values as having only one or two degrees of freedom can result
% in large critical value. In most cases however, the critical values are
% relatively small and [0, 9] is a good interval to display the curve of
% the F-distribution and the crititcal values.
% -------------------------------------------------------------------------
FTTS.xmin = 0;
FTTS.xmax = min([FTTS.CVright+3 9]);
FTTS.x = FTTS.xmin:0.01:FTTS.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
FTTS.y = pdf('F', FTTS.x, nu1, nu2);

% -------------------------------------------------------------------------
% Calculating the rejection regions, as these areas need to be shown in the
% plot.
% -------------------------------------------------------------------------
FTTS.xleft = FTTS.xmin:0.001:FTTS.CVleft;
FTTS.xright = FTTS.CVright:0.001:FTTS.xmax;
FTTS.yleft = pdf('F', FTTS.xleft, nu1, nu2);
FTTS.yright = pdf('F', FTTS.xright, nu1, nu2);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the test statistic
% and calculate the p value. FTTS.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. FTTS.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. The standard 4:3 ratio is
% used. FTTS.scale scales the graph with respect to the monitor size of the
% user. xticks is used as it is necessary to show the exact critical value
% on the horizontal axis.
% -------------------------------------------------------------------------
FTTS.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
FTTS.nodec = sprintf('%%.%df', 0);
FTTS.variables = sprintf(['\\alpha = ', FTTS.alphadec, ', \\nu_{1} = ', ...
    FTTS.nodec, ', \\nu_{2} = ' FTTS.nodec], alpha, nu1, nu2);

FTTS.mp = get(0, 'MonitorPositions');
FTTS.mwidth = FTTS.mp(1, 3);
FTTS.mheight = FTTS.mp(1, 4);
FTTS.scale = 0.45;

FTTS.gwidth = FTTS.scale*FTTS.mwidth;
FTTS.gheight = 0.75*FTTS.gwidth;
FTTS.x0 = 0.5*FTTS.mwidth*(1 - FTTS.scale);
FTTS.y0 = (FTTS.mheight - FTTS.gheight - 84)*0.5;

figure
plot(FTTS.x,FTTS.y,'-black');
xticks([FTTS.CVleft FTTS.CVright]);
title("F-distribution");
subtitle({FTTS.variables}, 'Interpreter', 'tex');
xlabel("F-value");
ylabel("Density");
xlim([0 FTTS.xmax]);
FTTS.fig = gcf;
FTTS.fig.Position = [FTTS.x0, FTTS.y0, FTTS.gwidth, FTTS.gheight];
hold on

% -------------------------------------------------------------------------
% Marking the critical values in the plot.
% -------------------------------------------------------------------------
xline([FTTS.CVleft FTTS.CVright], 'LineStyle', ':', 'Color', '#9a9afc', ...
    'LineWidth', 1.4);

% -------------------------------------------------------------------------
% Filling the areas of the rejection region.
% -------------------------------------------------------------------------
FTTS.arleft = area(FTTS.xleft, FTTS.yleft);
FTTS.arleft.FaceColor = 'blue';
FTTS.arleft.FaceAlpha = 0.15;
FTTS.arleft.EdgeColor = 'none';

FTTS.arright = area(FTTS.xright, FTTS.yright);
FTTS.arright.FaceColor = 'blue';
FTTS.arright.FaceAlpha = 0.15;
FTTS.arright.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated test statistic
% and compute the corresponding p value. This part of the code will only
% run when there is input for the fourth argument (the value of the test
% statistic). In the case that there is no input for the fourth argument,
% the p value will not be calculated and the function has finished running.
%
% The first nested if else statement will check, on the condition that the
% user gave input for the fourth argument, if the value of the test
% statistic lies between the two critical values. If this is the case, the
% null hypothesis cannot be rejected and a vertical light purple dotted
% line corresponding to the value of the test statistic and light purple
% shaded areas representing the p value will be added to the plot. Else,
% the null can be rejected and a purple vertical dotted line corresponding
% to the value of the test statistic and dark purple shaded areas
% displaying the p value will be plotted.
%
% Afterwards the subtitle is updated and the code has finished running.
% -------------------------------------------------------------------------
if (FTTS.Display == 1)
    % Check if null can be rejected
    if (tstat > FTTS.CVleft && tstat < FTTS.CVright)
        xline(tstat, 'LineStyle', ':', 'Color', '#ae9ab5', 'LineWidth', ...
            1.4);
        % Determine the interval of the light purple shaded area
        if (tstat >= icdf('F', 0.5, nu1, nu2))
            FTTS.otherpside = 1 - cdf('F', tstat, nu1, nu2);
            FTTS.otherstat = icdf('F', FTTS.otherpside, nu1, nu2);
            FTTS.tintleft = FTTS.CVleft:0.001:FTTS.otherstat;
            FTTS.tintright = tstat:0.001:FTTS.CVright;
            FTTS.pval = (1 - cdf('F', tstat, nu1, nu2))*2;
        else
            FTTS.otherpside = cdf('F', tstat, nu1, nu2);
            FTTS.otherstat = icdf('F', 1 - FTTS.otherpside, nu1, nu2);
            FTTS.tintleft = FTTS.CVleft:0.001:tstat;
            FTTS.tintright = FTTS.otherstat:0.001:FTTS.CVright;
            FTTS.pval = 2*cdf('F', tstat, nu1, nu2);
        end
        FTTS.tyl = pdf('F', FTTS.tintleft, nu1, nu2);
        FTTS.tlar = area(FTTS.tintleft, FTTS.tyl);
        FTTS.tlar.FaceColor = '#8a22b3';
        FTTS.tlar.FaceAlpha = 0.04;
        FTTS.tlar.EdgeColor = 'none';

        FTTS.tyr = pdf('F', FTTS.tintright, nu1, nu2);
        FTTS.trar = area(FTTS.tintright, FTTS.tyr);
        FTTS.trar.FaceColor = '#8a22b3';
        FTTS.trar.FaceAlpha = 0.04;
        FTTS.trar.EdgeColor = 'none';
    else
        xline(tstat, 'LineStyle', ':', 'Color','#8a22b3', 'LineWidth', ...
            1.4);
        % Determine the interval of the dark purple shaded area
        if (tstat >= FTTS.CVright)
            FTTS.otherpside = 1 - cdf('F', tstat, nu1, nu2);
            FTTS.otherstat = icdf('F', FTTS.otherpside, nu1, nu2);
            FTTS.tintleft = FTTS.xmin:0.001:FTTS.otherstat;
            FTTS.tintright = tstat:0.001:FTTS.xmax;
            FTTS.pval = (1 - cdf('F', tstat, nu1, nu2))*2;
        else
            FTTS.otherpside = cdf('F', tstat, nu1, nu2);
            FTTS.otherstat = icdf('F', 1 - FTTS.otherpside, nu1, nu2);
            FTTS.tintleft = FTTS.xmin:0.001:tstat;
            FTTS.tintright = FTTS.otherstat:0.001:FTTS.xmax;
            FTTS.pval = 2*cdf('F', tstat, nu1, nu2);
        end
        FTTS.tyl = pdf('F', FTTS.tintleft, nu1, nu2);
        FTTS.tlar = area(FTTS.tintleft, FTTS.tyl);
        FTTS.tlar.FaceColor = '#8a22b3';
        FTTS.tlar.FaceAlpha = 1;
        FTTS.tlar.EdgeColor = 'none';

        FTTS.tyr = pdf('F', FTTS.tintright, nu1, nu2);
        FTTS.trar = area(FTTS.tintright, FTTS.tyr);
        FTTS.trar.FaceColor = '#8a22b3';
        FTTS.trar.FaceAlpha = 1;
        FTTS.trar.EdgeColor = 'none';
    end
    FTTS.empdec = sprintf('%%.%df', 4);
    FTTS.pdec = sprintf('%%.%df', 4);
    FTTS.tp = sprintf(['Test statistic = ', FTTS.empdec,', p value = ', ...
        FTTS.pdec], tstat, FTTS.pval);
    subtitle({FTTS.variables, FTTS.tp}, 'Interpreter', 'tex');
end