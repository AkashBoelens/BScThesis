%% Generate Student's t distributed values
rng(14)
n = 20000;
nu = 20;
nbins = -5:0.01:5;
generatedvalues = random('T', nu, 1, n);

figure;
histogram(generatedvalues, nbins, 'FaceColor', '#b3b3b3', 'EdgeAlpha', 0);
title("Simulated t distribution", "n = "+ n + " and \nu = "+ nu);
xlabel('t');
ylabel('Frequency');

% The code below is used to resize the plot
mp = get(0, 'MonitorPositions');
mwidth = mp(1, 3);
mheight = mp(1, 4);
scale = 0.45;

gwidth = scale*mwidth;
gheight = 0.75*gwidth;
x0 = 0.5*mwidth*(1 - scale);
y0 = (mheight - gheight - 84)*0.5;
fig = gcf;
fig.Position = [x0, y0, gwidth, gheight];
%% Add our test statistic to the plot
tvalue = 1.8;

figure;
histogram(generatedvalues, nbins, 'FaceColor', '#b3b3b3', 'EdgeAlpha', 0);
xline(tvalue, '-b');
title("Simulated t distribution", "n = "+ n + " and \nu = "+ nu);
xlabel('t');
ylabel('Frequency');
legend('', 'Test statistic')

mp = get(0, 'MonitorPositions');
mwidth = mp(1, 3);
mheight = mp(1, 4);
scale = 0.45;

gwidth = scale*mwidth;
gheight = 0.75*gwidth;
x0 = 0.5*mwidth*(1 - scale);
y0 = (mheight - gheight - 84)*0.5;
fig = gcf;
fig.Position = [x0, y0, gwidth, gheight];
%% The frequency of the values more extreme than our test statistic

% We first need to collect all the generated values that are more extreme
% (larger) than tvalue.

extreme = generatedvalues(generatedvalues > tvalue);

figure;
histogram(generatedvalues, nbins, 'FaceColor', '#b3b3b3', 'EdgeAlpha', 0);
hold on
histogram(extreme, nbins, 'FaceColor', 'blue', 'EdgeAlpha', 0);
xline(tvalue, '-b');
title("Simulated t distribution", "n = "+ n + " and \nu = "+ nu);
xlabel('t');
ylabel('Frequency');

legend('', 'Values more extreme than the test statistic', 'Test statistic')

mp = get(0, 'MonitorPositions');
mwidth = mp(1, 3);
mheight = mp(1, 4);
scale = 0.45;

gwidth = scale*mwidth;
gheight = 0.75*gwidth;
x0 = 0.5*mwidth*(1 - scale);
y0 = (mheight - gheight - 84)*0.5;
fig = gcf;
fig.Position = [x0, y0, gwidth, gheight];

% The fraction of observations having a value more extreme than our test
% statistic. This is the simulated p value
manualp = length(extreme)/length(generatedvalues);

fprintf(['The fraction of observations that have a more extreme' ...
    ' value is equal to %.04f.\n'], manualp);

%% Limiting distribution
nu = 20;
tvalue = 1.8;
alpha = 0.05;

x = -5:0.1:5;
y = pdf('T', x, nu);

figure;
plot(x, y, '-black');
title("PDF of the t distribution", "\nu = "+ nu);
xlabel('t');
ylabel('Probability Density');
hold on

% Shade the density of all values more extreme than our statistic
pint = abs(tvalue):0.1:5;
py = pdf('T', pint, nu);
parea = area(pint, py);
parea.FaceColor = 'blue';
parea.EdgeColor = 'none';

% Display the value of our statistic
xline(tvalue, '-b');

legend('', 'P value', 'Test statistic')

mp = get(0, 'MonitorPositions');
mwidth = mp(1, 3);
mheight = mp(1, 4);
scale = 0.45;

gwidth = scale*mwidth;
gheight = 0.75*gwidth;
x0 = 0.5*mwidth*(1 - scale);
y0 = (mheight - gheight - 84)*0.5;
fig = gcf;
fig.Position = [x0, y0, gwidth, gheight];

% Calculate the p value from the cdf and compare this to the 'manually'
% calculated p value. 

realp = 1 - cdf('T', tvalue, nu);

fprintf(['The p value is equal to %.04f,' ...
    ' and the manually computed p value is %.04f.\n'], realp, manualp)

% So, the p value is the total density of all values being more extreme
% than the test statistic.