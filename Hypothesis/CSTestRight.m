function CSTR = CSTestRight(nu, alpha, tstat)
%CSTESTRIGHT Visualize a right sided Chi-squared test
%   CSTR = CSTestRight(NU, ALPHA, TSTAT) plots the theoretical Chi-Square
%   distribution with NU degrees of freedom. It calculates the critical
%   value corresponding to a right sided Chi-squared test with NU degrees
%   of freedom at an ALPHA level of significance and plots the related
%   rejection region. A vertical line representing the manually calculated
%   test statistic valued TSTAT will be plotted, this input argument is
%   optional.

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
    CSTR.Display = 1;
else
    CSTR.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical value.
% -------------------------------------------------------------------------
CSTR.CV = icdf('Chisquare', 1-alpha, nu);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical value as having a large degrees of freedom can result in a large
% critical value. In most cases, using a 2.5 multiplier results in a good
% interval to display the Chi-square distribution and the crititcal value.
% -------------------------------------------------------------------------
CSTR.xmin = 0;
CSTR.xmax = CSTR.CV*2.5;
CSTR.x = CSTR.xmin:0.01:CSTR.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
CSTR.y = pdf('Chisquare', CSTR.x, nu);

% -------------------------------------------------------------------------
% Calculating the rejection region, as the area needs to be shown in the
% plot.
% -------------------------------------------------------------------------
CSTR.xright = CSTR.CV:0.001:CSTR.xmax;
CSTR.yright = pdf('Chisquare', CSTR.xright, nu);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the test statistic
% and calculate the p value. CSTR.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. CSTR.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. The standard 4:3 ratio is
% used. CSTR.scale scales the graph with respect to the monitor size of the
% user. xticks is used as it is necessary to show the exact critical value
% on the horizontal axis.
% -------------------------------------------------------------------------
CSTR.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
CSTR.nodec = sprintf('%%.%df', 0);
CSTR.variables = sprintf(['\\alpha = ', CSTR.alphadec, ', \\nu = ', ...
    CSTR.nodec], alpha, nu);

CSTR.mp = get(0, 'MonitorPositions');
CSTR.mwidth = CSTR.mp(1, 3);
CSTR.mheight = CSTR.mp(1, 4);
CSTR.scale = 0.45;

CSTR.gwidth = CSTR.scale*CSTR.mwidth;
CSTR.gheight = 0.75*CSTR.gwidth;
CSTR.x0 = 0.5*CSTR.mwidth*(1 - CSTR.scale);
CSTR.y0 = (CSTR.mheight - CSTR.gheight - 84)*0.5;

figure
plot(CSTR.x,CSTR.y,'-black');
xticks([CSTR.CV]);
title("Chi-squared distribution")
subtitle({CSTR.variables}, 'Interpreter', 'tex');
xlabel("Chi-square value");
ylabel("Density");
CSTR.fig = gcf;
CSTR.fig.Position = [CSTR.x0, CSTR.y0, CSTR.gwidth, CSTR.gheight];
hold on

% -------------------------------------------------------------------------
% Marking the critical value in the plot.
% -------------------------------------------------------------------------
xline([CSTR.CV], 'LineStyle', ':', 'Color', '#9a9afc', 'LineWidth', 1.4);

% -------------------------------------------------------------------------
% Filling the area of the rejection region.
% -------------------------------------------------------------------------
CSTR.ar = area(CSTR.xright, CSTR.yright);
CSTR.ar.FaceColor = 'blue';
CSTR.ar.FaceAlpha = 0.15;
CSTR.ar.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated test statistic
% and compute the corresponding p value. This part of the code will only
% run when there is input for the third argument (the value of the test
% statistic). In the case that there is no input for the third argument,
% the p value will not be calculated and the function has finished running.
%
% The first nested if else statement will check, on the condition that the
% user gave input for the third argument, if the test statistic is smaller
% than the critical value. If this is the case, the null hypothesis cannot
% be rejected and a vertical light purple dotted line corresponding to the
% value of the test statistic and a light purple shaded area representing
% the p value will be added to the plot. Else, the null can be rejected and
% a purple vertical dotted line corresponding to the value of the test
% statistic and a dark purple shaded area displaying the p value will be
% plotted.
%
% Afterwards the subtitle will be updated and the code has finished 
% running.
% -------------------------------------------------------------------------
if (CSTR.Display == 1)
    if (tstat < CSTR.CV)
        xline(tstat, 'LineStyle', ':', 'Color', '#ae9ab5', 'LineWidth', ...
            1.4);
        CSTR.tint = tstat:0.001:CSTR.CV;
        CSTR.ty = pdf('Chisquare', CSTR.tint, nu);
        CSTR.tar = area(CSTR.tint, CSTR.ty);
        CSTR.tar.FaceColor = '#8a22b3';
        CSTR.tar.FaceAlpha = 0.04;
        CSTR.tar.EdgeColor = 'none';
    else
        xline(tstat, 'LineStyle', ':', 'Color','#8a22b3', 'LineWidth', ...
            1.4);
        CSTR.tint = tstat:0.001:CSTR.xmax;
        CSTR.ty = pdf('Chisquare', CSTR.tint, nu);
        CSTR.tar = area(CSTR.tint, CSTR.ty);
        CSTR.tar.FaceColor = '#8a22b3';
        CSTR.tar.FaceAlpha = 1;
        CSTR.tar.EdgeColor = 'none';
    end
    CSTR.pval = 1-cdf('Chisquare', tstat, nu);
    CSTR.empdec = sprintf('%%.%df', 4);
    CSTR.pdec = sprintf('%%.%df', 4);
    CSTR.tp = sprintf(['Test statistic = ', CSTR.empdec,', p value = ', ...
        CSTR.pdec], tstat, CSTR.pval);
    subtitle({CSTR.variables, CSTR.tp}, 'Interpreter', 'tex');
end
