function CSTL = CSTestLeft(nu, alpha, tstat)
%CSTESTLEFT Visualize a left sided Chi-squared test
%   CSTL = CSTestLeft(NU, ALPHA, TSTAT) plots the theoretical Chi-Square
%   distribution with NU degrees of freedom. It calculates the critical
%   value corresponding to a left sided Chi-squared test with NU degrees
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
    CSTL.Display = 1;
else
    CSTL.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical value.
% -------------------------------------------------------------------------
CSTL.CV = icdf('Chisquare', alpha, nu);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical value as having a large degrees of freedom can result in a large
% critical value. To display the distribution better in a dynamic way, the
% right end value of the interval depends on a multiplier based on the
% critical value of a right sided Chi-squared test.
% -------------------------------------------------------------------------
CSTL.betterright = icdf('Chisquare', 1-alpha, nu);
CSTL.xmin = 0;
CSTL.xmax = CSTL.betterright*2.5;
CSTL.x = CSTL.xmin:0.01:CSTL.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
CSTL.y = pdf('Chisquare', CSTL.x, nu);

% -------------------------------------------------------------------------
% Calculating the rejection region, as the area needs to be shown in the
% plot.
% -------------------------------------------------------------------------
CSTL.xleft = CSTL.xmin:0.001:CSTL.CV;
CSTL.yleft = pdf('Chisquare', CSTL.xleft, nu);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the test statistic
% and calculate the p value. CSTL.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. CSTL.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. The standard 4:3 ratio is
% used. CSTL.scale scales the graph with respect to the monitor size of the
% user. xticks is used as it is necessary to show the exact critical value
% on the horizontal axis.
% -------------------------------------------------------------------------
CSTL.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
CSTL.nodec = sprintf('%%.%df', 0);
CSTL.variables = sprintf(['\\alpha = ', CSTL.alphadec, ', \\nu = ', ...
    CSTL.nodec], alpha, nu);

CSTL.mp = get(0, 'MonitorPositions');
CSTL.mwidth = CSTL.mp(1, 3);
CSTL.mheight = CSTL.mp(1, 4);
CSTL.scale = 0.45;

CSTL.gwidth = CSTL.scale*CSTL.mwidth;
CSTL.gheight = 0.75*CSTL.gwidth;
CSTL.x0 = 0.5*CSTL.mwidth*(1 - CSTL.scale);
CSTL.y0 = (CSTL.mheight - CSTL.gheight - 84)*0.5;

figure
plot(CSTL.x,CSTL.y,'-black');
xticks([CSTL.CV]);
title("Chi-square distribution");
subtitle({CSTL.variables}, 'Interpreter', 'tex');
xlabel("Chi-square value");
ylabel("Density");
CSTL.fig = gcf;
CSTL.fig.Position = [CSTL.x0, CSTL.y0, CSTL.gwidth, CSTL.gheight];
hold on

% -------------------------------------------------------------------------
% Marking the critical value in the plot.
% -------------------------------------------------------------------------
xline([CSTL.CV], 'LineStyle', ':', 'Color', '#9a9afc', 'LineWidth', 1.4);

% -------------------------------------------------------------------------
% Filling the area of the rejection region.
% -------------------------------------------------------------------------
CSTL.ar = area(CSTL.xleft, CSTL.yleft);
CSTL.ar.FaceColor = 'blue';
CSTL.ar.FaceAlpha = 0.15;
CSTL.ar.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated test statistic
% and compute the corresponding p value. This part of the code will only
% run when there is input for the third argument (the value of the test
% statistic). In the case that there is no input for the third argument,
% the p value will not be calculated and the function has finished running.
%
% The first nested if else statement will check, on the condition that the
% user gave input for the third argument, if the test statistic is larger
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
if (CSTL.Display == 1)
    if (tstat > CSTL.CV)
        xline(tstat, 'LineStyle', ':', 'Color', '#ae9ab5', 'LineWidth', ...
            1.4);
        CSTL.tint = CSTL.CV:0.001:tstat;
        CSTL.ty = pdf('Chisquare', CSTL.tint, nu);
        CSTL.tar = area(CSTL.tint, CSTL.ty);
        CSTL.tar.FaceColor = '#8a22b3';
        CSTL.tar.FaceAlpha = 0.04;
        CSTL.tar.EdgeColor = 'none';
    else
        xline(tstat, 'LineStyle', ':', 'Color','#8a22b3', 'LineWidth', ...
            1.4);
        CSTL.tint = CSTL.xmin:0.001:tstat;
        CSTL.ty = pdf('Chisquare', CSTL.tint, nu);
        CSTL.tar = area(CSTL.tint, CSTL.ty);
        CSTL.tar.FaceColor = '#8a22b3';
        CSTL.tar.FaceAlpha = 1;
        CSTL.tar.EdgeColor = 'none';
    end
    CSTL.pval = cdf('Chisquare', tstat, nu);
    CSTL.empdec = sprintf('%%.%df', 4);
    CSTL.pdec = sprintf('%%.%df', 4);
    CSTL.tp = sprintf(['Test statistic = ', CSTL.empdec,', p value = ', ...
        CSTL.pdec], tstat, CSTL.pval);
    subtitle({CSTL.variables, CSTL.tp}, 'Interpreter', 'tex');
end
