function CSTTS = CSTestTwoSided(nu, alpha, tstat)
%FTESTTWOSIDED Visualize a two sided F-test
%   CSTTS = CSTestTwoSided(NU, ALPHA, TSTAT) plots the theoretical
%   Chi-square distribution with NU degrees of freedom. It calculates the
%   two critical values corresponding to a two sided Chi-squared test with
%   NU degrees of freedom at an ALPHA level of significance and plots the
%   related rejection regions. A vertical line representing the manually
%   calculated test statistic valued TSTAT will be plotted, this input
%   argument is optional.

% -------------------------------------------------------------------------
% Check whether the input is valid.
% -------------------------------------------------------------------------
if (nu <= 0)
    uiwait(warndlg(['The degrees of freedom should be larger than ' ...
        'zero.']));
    return
elseif (mod(nu, 1) ~= 0)
    uiwait(warndlg(['Please fill in an integer for the degrees of ' ...
        'freedom .']));
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
if (nargin == 3)
    if (tstat < 0)
        uiwait(warndlg(['The test statistic cannot be negative valued,' ...
            ' please make sure that the test statistic is correctly' ...
            ' calculated.']));
        return
    end
    CSTTS.Display = 1;
else 
    CSTTS.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical values.
% -------------------------------------------------------------------------
CSTTS.CVleft = icdf('Chisquare', alpha/2, nu);
CSTTS.CVright = icdf('Chisquare', 1-alpha/2, nu);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical value as having a large degrees of freedom can result in a large
% critical value. In most cases, using a 2.5 multiplier based on the
% critical value in the right tail results in a good interval to display
% the Chi-square distribution and the crititcal value.
% -------------------------------------------------------------------------
CSTTS.xmin = 0;
CSTTS.xmax = CSTTS.CVright*2.5;
CSTTS.x = CSTTS.xmin:0.01:CSTTS.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
CSTTS.y = pdf('Chisquare', CSTTS.x, nu);

% -------------------------------------------------------------------------
% Calculating the rejection regions, as these areas need to be shown in the
% plot.
% -------------------------------------------------------------------------
CSTTS.xleft = CSTTS.xmin:0.001:CSTTS.CVleft;
CSTTS.xright = CSTTS.CVright:0.001:CSTTS.xmax;
CSTTS.yleft = pdf('Chisquare', CSTTS.xleft, nu);
CSTTS.yright = pdf('Chisquare', CSTTS.xright, nu);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the test statistic
% and calculate the p value. CSTTS.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. CSTTS.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. The standard 4:3 ratio is
% used. CSTTS.scale scales the graph with respect to the monitor size of
% the user. xticks is used as it is necessary to show the exact critical
% value on the horizontal axis.
% -------------------------------------------------------------------------
CSTTS.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
CSTTS.nodec = sprintf('%%.%df', 0);
CSTTS.variables = sprintf(['\\alpha = ', CSTTS.alphadec, ', \\nu = ', ...
    CSTTS.nodec], alpha, nu);

CSTTS.mp = get(0, 'MonitorPositions');
CSTTS.mwidth = CSTTS.mp(1, 3);
CSTTS.mheight = CSTTS.mp(1, 4);
CSTTS.scale = 0.45;

CSTTS.gwidth = CSTTS.scale*CSTTS.mwidth;
CSTTS.gheight = 0.75*CSTTS.gwidth;
CSTTS.x0 = 0.5*CSTTS.mwidth*(1 - CSTTS.scale);
CSTTS.y0 = (CSTTS.mheight - CSTTS.gheight - 84)*0.5;

figure
plot(CSTTS.x,CSTTS.y,'-black');
xticks([CSTTS.CVleft CSTTS.CVright]);
title("Chi-square distribution");
subtitle({CSTTS.variables}, 'Interpreter', 'tex');
xlabel("Chi-square value");
ylabel("Density");
xlim([0 CSTTS.xmax]);
CSTTS.fig = gcf;
CSTTS.fig.Position = [CSTTS.x0, CSTTS.y0, CSTTS.gwidth, CSTTS.gheight];
hold on

% -------------------------------------------------------------------------
% Marking the critical values in the plot.
% -------------------------------------------------------------------------
xline([CSTTS.CVleft CSTTS.CVright], 'LineStyle', ':', 'Color', ...
    '#9a9afc', 'LineWidth', 1.4);

% -------------------------------------------------------------------------
% Filling the areas of the rejection region.
% -------------------------------------------------------------------------
CSTTS.arleft = area(CSTTS.xleft, CSTTS.yleft);
CSTTS.arleft.FaceColor = 'blue';
CSTTS.arleft.FaceAlpha = 0.15;
CSTTS.arleft.EdgeColor = 'none';

CSTTS.arright = area(CSTTS.xright, CSTTS.yright);
CSTTS.arright.FaceColor = 'blue';
CSTTS.arright.FaceAlpha = 0.15;
CSTTS.arright.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated test statistic
% and compute the corresponding p value. This part of the code will only
% run when there is input for the third argument (the value of the test
% statistic). In the case that there is no input for the third argument,
% the p value will not be calculated and the function has finished running.
%
% The first nested if else statement will check, on the condition that the
% user gave input for the third argument, if the value of the test
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
if (CSTTS.Display == 1)
    % Check if null can be rejected
    if (tstat > CSTTS.CVleft && tstat < CSTTS.CVright)
        xline(tstat, 'LineStyle', ':', 'Color', '#ae9ab5', 'LineWidth', ...
            1.4);
        % Determine the interval of the light purple shaded area
        if (tstat >= icdf('Chisquare', 0.5, nu))
            CSTTS.otherpside = 1 - cdf('Chisquare', tstat, nu);
            CSTTS.otherstat = icdf('Chisquare', CSTTS.otherpside, nu);
            CSTTS.tintleft = CSTTS.CVleft:0.001:CSTTS.otherstat;
            CSTTS.tintright = tstat:0.001:CSTTS.CVright;
            CSTTS.pval = (1 - cdf('Chisquare', tstat, nu))*2;
        else
            CSTTS.otherpside = cdf('Chisquare', tstat, nu);
            CSTTS.otherstat = icdf('Chisquare', 1 - CSTTS.otherpside, nu);
            CSTTS.tintleft = CSTTS.CVleft:0.001:tstat;
            CSTTS.tintright = CSTTS.otherstat:0.001:CSTTS.CVright;
            CSTTS.pval = 2*cdf('Chisquare', tstat, nu);
        end
        CSTTS.tyl = pdf('Chisquare', CSTTS.tintleft, nu);
        CSTTS.tlar = area(CSTTS.tintleft, CSTTS.tyl);
        CSTTS.tlar.FaceColor = '#8a22b3';
        CSTTS.tlar.FaceAlpha = 0.04;
        CSTTS.tlar.EdgeColor = 'none';

        CSTTS.tyr = pdf('Chisquare', CSTTS.tintright, nu);
        CSTTS.trar = area(CSTTS.tintright, CSTTS.tyr);
        CSTTS.trar.FaceColor = '#8a22b3';
        CSTTS.trar.FaceAlpha = 0.04;
        CSTTS.trar.EdgeColor = 'none';
    else
        xline(tstat, 'LineStyle', ':', 'Color','#8a22b3', 'LineWidth', ...
            1.4);
        % Determine the interval of the dark purple shaded area
        if (tstat >= CSTTS.CVright)
            CSTTS.otherpside = 1 - cdf('Chisquare', tstat, nu);
            CSTTS.otherstat = icdf('Chisquare', CSTTS.otherpside, nu);
            CSTTS.tintleft = CSTTS.xmin:0.001:CSTTS.otherstat;
            CSTTS.tintright = tstat:0.001:CSTTS.xmax;
            CSTTS.pval = (1 - cdf('Chisquare', tstat, nu))*2;
        else
            CSTTS.otherpside = cdf('Chisquare', tstat, nu);
            CSTTS.otherstat = icdf('Chisquare', 1 - CSTTS.otherpside, nu);
            CSTTS.tintleft = CSTTS.xmin:0.001:tstat;
            CSTTS.tintright = CSTTS.otherstat:0.001:CSTTS.xmax;
            CSTTS.pval = 2*cdf('Chisquare', tstat, nu);
        end
        CSTTS.tyl = pdf('Chisquare', CSTTS.tintleft, nu);
        CSTTS.tlar = area(CSTTS.tintleft, CSTTS.tyl);
        CSTTS.tlar.FaceColor = '#8a22b3';
        CSTTS.tlar.FaceAlpha = 1;
        CSTTS.tlar.EdgeColor = 'none';

        CSTTS.tyr = pdf('Chisquare', CSTTS.tintright, nu);
        CSTTS.trar = area(CSTTS.tintright, CSTTS.tyr);
        CSTTS.trar.FaceColor = '#8a22b3';
        CSTTS.trar.FaceAlpha = 1;
        CSTTS.trar.EdgeColor = 'none';
    end
    CSTTS.empdec = sprintf('%%.%df', 4);
    CSTTS.pdec = sprintf('%%.%df', 4);
    CSTTS.tp = sprintf(['Test statistic = ', CSTTS.empdec, ...
        ', p value = ', CSTTS.pdec], tstat, CSTTS.pval);
    subtitle({CSTTS.variables, CSTTS.tp}, 'Interpreter', 'tex');
end