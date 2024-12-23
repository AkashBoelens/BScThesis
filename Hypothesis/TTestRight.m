function TTR = TTestRight(nu, alpha, tstat)
%TTESTRIGHT Visualize a right sided Student's t-test
%   TTR = TTestRight(NU, ALPHA, TSTAT) plots the theoretical 
%   student's t-distribution with NU degrees of freedom. It calculates the 
%   critical value corresponding to a right sided t-test with NU degrees of 
%   freedom at an ALPHA level of significance and plots the related 
%   rejection region. A vertical line representing the manually calculated
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
% Check if the user wants to plot the test statistic and whether the input
% is valid.
% -------------------------------------------------------------------------
if (nargin == 3)
    TTR.Display = 1;
    if (tstat < 0)
        uiwait(warndlg(['The test statistic is negative valued.' ...
            ' If this is intentional, please make use of the left' ...
            ' tailed test.']))
        return
    end
else 
    TTR.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical value.
% -------------------------------------------------------------------------
TTR.CV = icdf('T', 1-alpha, nu);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical value as having only one or two degrees of freedom can result in
% a large critical value. In most cases however, the critical value is
% relatively small and [-5, 5] is a good interval to display the curve of
% the student's t-distribution and the crititcal value. xmin uses -TTR.CV
% as the critical value is positive by construction.
% -------------------------------------------------------------------------
TTR.xmin = min([-TTR.CV-1 -5]);
TTR.xmax = max([TTR.CV+1 5]);
TTR.x = TTR.xmin:0.01:TTR.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
TTR.y = pdf('T', TTR.x, nu);

% -------------------------------------------------------------------------
% Calculating the rejection region, as the area needs to be shown in the
% plot
% -------------------------------------------------------------------------
TTR.xright = TTR.CV:0.001:TTR.xmax;
TTR.yright = pdf('T', TTR.xright, nu);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the test statistic
% and calculate the p value. TTR.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. TTR.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. The standard 4:3 ratio is
% used. TTR.scale scales the graph with respect to the monitor size of the
% user. xticks is used as it is necessary to show the exact critical value
% on the horizontal axis.
% -------------------------------------------------------------------------
TTR.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
TTR.nodec = sprintf('%%.%df', 0);
TTR.variables = sprintf(['\\alpha = ', TTR.alphadec, ', \\nu = ', ...
    TTR.nodec], alpha, nu);

TTR.mp = get(0, 'MonitorPositions');
TTR.mwidth = TTR.mp(1, 3);
TTR.mheight = TTR.mp(1, 4);
TTR.scale = 0.45;

TTR.gwidth = TTR.scale*TTR.mwidth;
TTR.gheight = 0.75*TTR.gwidth;
TTR.x0 = 0.5*TTR.mwidth*(1 - TTR.scale);
TTR.y0 = (TTR.mheight - TTR.gheight - 84)*0.5;

figure
plot(TTR.x,TTR.y,'-black');
xticks([0 TTR.CV]);
title("t-distribution");
subtitle({TTR.variables}, 'Interpreter', 'tex');
xlabel("t-value");
ylabel("Density");
TTR.fig = gcf;
TTR.fig.Position = [TTR.x0, TTR.y0, TTR.gwidth, TTR.gheight];
hold on

% -------------------------------------------------------------------------
% Marking the critical values in the plot.
% -------------------------------------------------------------------------
xline([TTR.CV], 'LineStyle', ':', 'Color', '#9a9afc', 'LineWidth', 1.4);

% -------------------------------------------------------------------------
% Filling the areas of the rejection region.
% -------------------------------------------------------------------------
TTR.ar = area(TTR.xright, TTR.yright);
TTR.ar.FaceColor = 'blue';
TTR.ar.FaceAlpha = 0.15;
TTR.ar.EdgeColor = 'none';

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
if (TTR.Display == 1)
    if (tstat < TTR.CV)
        xline(tstat, 'LineStyle', ':', 'Color', '#ae9ab5', 'LineWidth', ...
            1.4);
        TTR.tint = tstat:0.001:TTR.CV;        
        TTR.ty = pdf('T', TTR.tint, nu);
        TTR.tar = area(TTR.tint, TTR.ty);
        TTR.tar.FaceColor = '#8a22b3';
        TTR.tar.FaceAlpha = 0.04;
        TTR.tar.EdgeColor = 'none';
    else
        xline(tstat, 'LineStyle', ':', 'Color','#8a22b3', 'LineWidth', ...
            1.4);
        TTR.tint = tstat:0.001:TTR.xmax;        
        TTR.ty = pdf('T', TTR.tint, nu);
        TTR.tar = area(TTR.tint, TTR.ty);
        TTR.tar.FaceColor = '#8a22b3';
        TTR.tar.FaceAlpha = 1;
        TTR.tar.EdgeColor = 'none';
    end
    TTR.pval = 1-cdf('T', tstat, nu);
    TTR.empdec = sprintf('%%.%df', 4);
    TTR.pdec = sprintf('%%.%df', 4);
    TTR.tp = sprintf(['Test statistic = ', TTR.empdec,', p value = ', ...
        TTR.pdec], tstat, TTR.pval);
    subtitle({TTR.variables, TTR.tp}, 'Interpreter', 'tex');
end