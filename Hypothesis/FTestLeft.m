function FTL = FTestLeft(nu1, nu2, alpha, tstat)
%FTESTLEFT Visualize a left sided F-test
%   FTL = FTestLeft(NU1, NU2, ALPHA, TSTAT) plots the theoretical
%   F-distribution with NU1 and NU2 degrees of freedom. It calculates the
%   critical value corresponding to a left sided F-test with NU1 and NU2
%   degrees of freedom at an ALPHA level of significance and plots the
%   related rejection region. A vertical line representing the manually
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
    FTL.Display = 1;
else
    FTL.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical value.
% -------------------------------------------------------------------------
FTL.CV = icdf('F', alpha, nu1, nu2);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical value as having only one or two degrees of freedom can result in
% large critical value. In most cases however, the critical value is
% relatively small and [0, 9] is a good interval to display the curve of
% the F-distribution and the crititcal value. To display the distribution
% better in a dynamic way, the right end value of the interval depends on
% the critical value of a right sided F-test. This is because the critical
% value of a left sided F-test does not increase as much as the length
% of the right sided tail of the F-distribution when the degrees of freedom
% increase.
% -------------------------------------------------------------------------
FTL.betterright = icdf('F', 1-alpha, nu2, nu1);
FTL.xmin = 0;
FTL.xmax = min([FTL.betterright+3 9]);
FTL.x = FTL.xmin:0.01:FTL.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
FTL.y = pdf('F', FTL.x, nu1, nu2);

% -------------------------------------------------------------------------
% Calculating the rejection region, as the area needs to be shown in the
% plot.
% -------------------------------------------------------------------------
FTL.xleft = FTL.xmin:0.001:FTL.CV;
FTL.yleft = pdf('F', FTL.xleft, nu1, nu2);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the test statistic
% and calculate the p value. FTL.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. FTL.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. The standard 4:3 ratio is
% used. FTL.scale scales the graph with respect to the monitor size of the
% user. xticks is used as it is necessary to show the exact critical value
% on the horizontal axis.
% -------------------------------------------------------------------------
FTL.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
FTL.nodec = sprintf('%%.%df', 0);
FTL.variables = sprintf(['\\alpha = ', FTL.alphadec, ', \\nu_{1} = ', ...
    FTL.nodec, ', \\nu_{2} = ' FTL.nodec], alpha, nu1, nu2);

FTL.mp = get(0, 'MonitorPositions');
FTL.mwidth = FTL.mp(1, 3);
FTL.mheight = FTL.mp(1, 4);
FTL.scale = 0.45;

FTL.gwidth = FTL.scale*FTL.mwidth;
FTL.gheight = 0.75*FTL.gwidth;
FTL.x0 = 0.5*FTL.mwidth*(1 - FTL.scale);
FTL.y0 = (FTL.mheight - FTL.gheight - 84)*0.5;

figure
plot(FTL.x,FTL.y,'-black');
xticks([FTL.CV]);
title("F-distribution");
subtitle({FTL.variables}, 'Interpreter', 'tex');
xlabel("F-value");
ylabel("Density");
FTL.fig = gcf;
FTL.fig.Position = [FTL.x0, FTL.y0, FTL.gwidth, FTL.gheight];
hold on

% -------------------------------------------------------------------------
% Marking the critical value in the plot.
% -------------------------------------------------------------------------
xline([FTL.CV], 'LineStyle', ':', 'Color', '#9a9afc', 'LineWidth', 1.4);

% -------------------------------------------------------------------------
% Filling the area of the rejection region.
% -------------------------------------------------------------------------
FTL.ar = area(FTL.xleft, FTL.yleft);
FTL.ar.FaceColor = 'blue';
FTL.ar.FaceAlpha = 0.15;
FTL.ar.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated test statistic
% and compute the corresponding p value. This part of the code will only
% run when there is input for the fourth argument (the value of the test
% statistic). In the case that there is no input for the fourth argument,
% the p value will not be calculated and the function has finished running.
%
% The first nested if else statement will check, on the condition that the
% user gave input for the fourth argument, if the test statistic is larger
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
if (FTL.Display == 1)
    if (tstat > FTL.CV)
        xline(tstat, 'LineStyle', ':', 'Color', '#ae9ab5', 'LineWidth', ...
            1.4);
        FTL.tint = FTL.CV:0.001:tstat;
        FTL.ty = pdf('F', FTL.tint, nu1, nu2);
        FTL.tar = area(FTL.tint, FTL.ty);
        FTL.tar.FaceColor = '#8a22b3';
        FTL.tar.FaceAlpha = 0.04;
        FTL.tar.EdgeColor = 'none';
    else
        xline(tstat, 'LineStyle', ':', 'Color','#8a22b3', 'LineWidth', ...
            1.4);
        FTL.tint = FTL.xmin:0.001:tstat;
        FTL.ty = pdf('F', FTL.tint, nu1, nu2);
        FTL.tar = area(FTL.tint, FTL.ty);
        FTL.tar.FaceColor = '#8a22b3';
        FTL.tar.FaceAlpha = 1;
        FTL.tar.EdgeColor = 'none';
    end
    FTL.pval = cdf('F', tstat, nu1, nu2);
    FTL.empdec = sprintf('%%.%df', 4);
    FTL.pdec = sprintf('%%.%df', 4);
    FTL.tp = sprintf(['Test statistic = ', FTL.empdec,', p value = ', ...
        FTL.pdec], tstat, FTL.pval);
    subtitle({FTL.variables, FTL.tp}, 'Interpreter', 'tex');
end