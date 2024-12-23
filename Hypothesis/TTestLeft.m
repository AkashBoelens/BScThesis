function TTL = TTestLeft(nu, alpha, tstat)
%TTESTLEFT Visualize a left sided Student's t-test
%   TTL = TTestLeft(NU, ALPHA, TSTAT) plots the theoretical 
%   student's t-distribution with NU degrees of freedom. It calculates the 
%   critical value corresponding to a left sided t-test with NU degrees of 
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
% Check if the user wants to plot the test statistic.
% -------------------------------------------------------------------------
if (nargin == 3)
    TTL.Display = 1;
    if (tstat > 0)
        uiwait(warndlg(['The test statistic is positive valued.' ...
            ' If this is intentional, please make use of the right' ...
            ' tailed test.']))
        return
    end
else 
    TTL.Display = 0;
end

% -------------------------------------------------------------------------
% Calculating the critical value.
% -------------------------------------------------------------------------
TTL.CV = -icdf('T', 1-alpha, nu);

% -------------------------------------------------------------------------
% Determining the length of the horizontal axis, which depends on the
% critical value as having only one or two degrees of freedom can result in
% a large critical value. In most cases however, the critical value is
% relatively small and [-5, 5] is a good interval to display the curve of
% the student's t-distribution and the crititcal values. xmax uses -TTL.CV
% as the critical value is negative by construction.
% -------------------------------------------------------------------------
TTL.xmin = min([TTL.CV-1 -5]);
TTL.xmax = max([-TTL.CV+1 5]);
TTL.x = TTL.xmin:0.01:TTL.xmax;

% -------------------------------------------------------------------------
% Creating the density.
% -------------------------------------------------------------------------
TTL.y = pdf('T', TTL.x, nu);

% -------------------------------------------------------------------------
% Calculating the rejection region, since this area needs to be shown in
% the plot.
% -------------------------------------------------------------------------
TTL.xleft = TTL.xmin:0.001:TTL.CV;
TTL.yleft = pdf('T', TTL.xleft, nu);

% -------------------------------------------------------------------------
% Setting up the plot. To create a subtitle consisting of two lines, the
% sprintf() function is used in the subtitle() function. The subtitle will
% be split up in two lines when the user wants to plot the test statistic
% and calculate the p value. TTL.alphadec is used to determine the number
% of decimals for displaying alpha, which depends on the user and hence is
% dynamic. TTL.nodec is used for the degrees of freedom, which don't have
% decimals. The code then asks for the size of the monitor of the user to
% calculate the size (in pixels) of the graph. The standard 4:3 ratio is
% used. TTL.scale scales the graph with respect to the monitor size of the
% user. xticks is used as it is necessary to show the exact critical value
% on the horizontal axis.
% -------------------------------------------------------------------------
TTL.alphadec = sprintf('%%.%df', ...
    length(char(extractAfter(string(alpha),'.'))));
TTL.nodec = sprintf('%%.%df', 0);
TTL.variables = sprintf(['\\alpha = ', TTL.alphadec, ', \\nu = ', ...
    TTL.nodec], alpha, nu);

TTL.mp = get(0, 'MonitorPositions');
TTL.mwidth = TTL.mp(1, 3);
TTL.mheight = TTL.mp(1, 4);
TTL.scale = 0.45;

TTL.gwidth = TTL.scale*TTL.mwidth;
TTL.gheight = 0.75*TTL.gwidth;
TTL.x0 = 0.5*TTL.mwidth*(1 - TTL.scale);
TTL.y0 = (TTL.mheight - TTL.gheight - 84)*0.5;

figure
plot(TTL.x,TTL.y,'-black');
xticks([TTL.CV 0]);
title("t-distribution");
subtitle({TTL.variables}, 'Interpreter', 'tex');
xlabel("t-value");
ylabel("Density");
TTL.fig = gcf;
TTL.fig.Position = [TTL.x0, TTL.y0, TTL.gwidth, TTL.gheight];
hold on

% -------------------------------------------------------------------------
% Marking the critical value in the plot.
% -------------------------------------------------------------------------
xline([TTL.CV], 'LineStyle', ':', 'Color', '#9a9afc', 'LineWidth', 1.4);

% -------------------------------------------------------------------------
% Filling the area of the rejection region.
% -------------------------------------------------------------------------
TTL.ar = area(TTL.xleft, TTL.yleft);
TTL.ar.FaceColor = 'blue';
TTL.ar.FaceAlpha = 0.15;
TTL.ar.EdgeColor = 'none';

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
if (TTL.Display == 1)
    if (tstat > TTL.CV)
        xline(tstat, 'LineStyle', ':', 'Color', '#ae9ab5', 'LineWidth', ...
            1.4);
        TTL.tint = TTL.CV:0.001:tstat;
        TTL.ty = pdf('T', TTL.tint, nu);
        TTL.tar = area(TTL.tint, TTL.ty);
        TTL.tar.FaceColor = '#8a22b3';
        TTL.tar.FaceAlpha = 0.04;
        TTL.tar.EdgeColor = 'none';
    else
        xline(tstat, 'LineStyle', ':', 'Color','#8a22b3', 'LineWidth', ...
            1.4);
        TTL.tint = TTL.xmin:0.001:tstat;
        TTL.ty = pdf('T', TTL.tint, nu);
        TTL.tar = area(TTL.tint, TTL.ty);
        TTL.tar.FaceColor = '#8a22b3';
        TTL.tar.FaceAlpha = 1;
        TTL.tar.EdgeColor = 'none';
    end
    TTL.pval = cdf('T', tstat, nu);
    TTL.empdec = sprintf('%%.%df', 4);
    TTL.pdec = sprintf('%%.%df', 4);
    TTL.tp = sprintf(['Test statistic = ', TTL.empdec,', p value = ', ...
        TTL.pdec], tstat, TTL.pval);
    subtitle({TTL.variables, TTL.tp}, 'Interpreter', 'tex');
end