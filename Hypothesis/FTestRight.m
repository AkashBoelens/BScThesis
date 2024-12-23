function FTR = FTestRight(nu1, nu2, alpha, tstat)
%FTESTRIGHT Visualize a right sided F-test
%   FTR = FTestLeft(NU1, NU2, ALPHA, TSTAT) plots the theoretical
%   F-distribution with NU1 and NU2 degrees of freedom. It calculates the
%   critical value corresponding to a right sided F-test with NU1 and NU2
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
    FTR.Display = 1;
else
    FTR.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical value.
% -------------------------------------------------------------------------
FTR.CV = icdf('F', 1-alpha, nu1, nu2);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical value as having only one or two degrees of freedom can result in
% large critical value. In most cases however, the critical value is
% relatively small and [0, 9] is a good interval to display the curve of
% the F-distribution and the crititcal value.
% -------------------------------------------------------------------------
FTR.xmin = 0;
FTR.xmax = max([FTR.CV+3 9]);
FTR.x = FTR.xmin:0.01:FTR.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
FTR.y = pdf('F', FTR.x, nu1, nu2);

% -------------------------------------------------------------------------
% Calculating the rejection region, as the area needs to be shown in the
% plot.
% -------------------------------------------------------------------------
FTR.xright = FTR.CV:0.001:FTR.xmax;
FTR.yright = pdf('F', FTR.xright, nu1, nu2);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the test statistic
% and calculate the p value. FTR.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. FTR.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. The standard 4:3 ratio is
% used. FTR.scale scales the graph with respect to the monitor size of the
% user. xticks is used as it is necessary to show the exact critical value
% on the horizontal axis.
% -------------------------------------------------------------------------
FTR.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
FTR.nodec = sprintf('%%.%df', 0);
FTR.variables = sprintf(['\\alpha = ', FTR.alphadec, ', \\nu_{1} = ', ...
    FTR.nodec, ', \\nu_{2} = ' FTR.nodec], alpha, nu1, nu2);

FTR.mp = get(0, 'MonitorPositions');
FTR.mwidth = FTR.mp(1, 3);
FTR.mheight = FTR.mp(1, 4);
FTR.scale = 0.45;

FTR.gwidth = FTR.scale*FTR.mwidth;
FTR.gheight = 0.75*FTR.gwidth;
FTR.x0 = 0.5*FTR.mwidth*(1 - FTR.scale);
FTR.y0 = (FTR.mheight - FTR.gheight - 84)*0.5;

figure
plot(FTR.x,FTR.y,'-black');
xticks([FTR.CV]);
title("F-distribution")
subtitle({FTR.variables}, 'Interpreter', 'tex');
xlabel("F-value");
ylabel("Density");
FTR.fig = gcf;
FTR.fig.Position = [FTR.x0, FTR.y0, FTR.gwidth, FTR.gheight];
hold on

% -------------------------------------------------------------------------
% Marking the critical value in the plot.
% -------------------------------------------------------------------------
xline([FTR.CV], 'LineStyle', ':', 'Color', '#9a9afc', 'LineWidth', 1.4);

% -------------------------------------------------------------------------
% Filling the area of the rejection region.
% -------------------------------------------------------------------------
FTR.ar = area(FTR.xright, FTR.yright);
FTR.ar.FaceColor = 'blue';
FTR.ar.FaceAlpha = 0.15;
FTR.ar.EdgeColor = 'none';

% -------------------------------------------------------------------------
% The user has the option to also plot the self calculated test statistic
% and compute the corresponding p value. This part of the code will only
% run when there is input for the fourth argument (the value of the test
% statistic). In the case that there is no input for the fourth argument,
% the p value will not be calculated and the function has finished running.
%
% The first nested if else statement will check, on the condition that the
% user gave input for the fourth argument, if the test statistic is smaller
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
if (FTR.Display == 1)
    if (tstat < FTR.CV)
        xline(tstat, 'LineStyle', ':', 'Color', '#ae9ab5', 'LineWidth', ...
            1.4);
        FTR.tint = tstat:0.001:FTR.CV;
        FTR.ty = pdf('F', FTR.tint, nu1, nu2);
        FTR.tar = area(FTR.tint, FTR.ty);
        FTR.tar.FaceColor = '#8a22b3';
        FTR.tar.FaceAlpha = 0.04;
        FTR.tar.EdgeColor = 'none';
    else
        xline(tstat, 'LineStyle', ':', 'Color','#8a22b3', 'LineWidth', ...
            1.4);
        FTR.tint = tstat:0.001:FTR.xmax;
        FTR.ty = pdf('F', FTR.tint, nu1, nu2);
        FTR.tar = area(FTR.tint, FTR.ty);
        FTR.tar.FaceColor = '#8a22b3';
        FTR.tar.FaceAlpha = 1;
        FTR.tar.EdgeColor = 'none';
    end
    FTR.pval = 1-cdf('F', tstat, nu1, nu2);
    FTR.empdec = sprintf('%%.%df', 4);
    FTR.pdec = sprintf('%%.%df', 4);
    FTR.tp = sprintf(['Test statistic = ', FTR.empdec,', p value = ', ...
        FTR.pdec], tstat,FTR.pval);
    subtitle({FTR.variables, FTR.tp}, 'Interpreter', 'tex');
end