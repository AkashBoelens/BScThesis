%% Defining the PDF of the t distribution and evaluating at some values

% Define degrees of freedom
nu = 5;

% Define x values range
x = linspace(-5, 5, 5);

% Building the PDF of the t distribution to calculate a couple of values
val1 = (nu+1)/2;
fun1 = @(t) t.^(val1 - 1).*exp(-t);
gam1 = integral(fun1, 0, Inf);

val2 = nu/2;
fun2 = @(t) t.^(val2 - 1).*exp(-t);
gam2 = integral(fun2, 0, Inf);

ymanual = gam1 / (gam2*sqrt(pi * nu)) * (1 + x.^2 / nu).^-((nu + 1) ./ 2);

% Return values from the pdf using the pdf function of MATLAB
ybuiltin = pdf('T', x, nu);

% Check equality
isequal(ybuiltin, ymanual);
ismembertol(ybuiltin, ymanual, 1e-6);
abs(ybuiltin - ymanual);

%% Simulating the t distribution with a couple of samples

% Setting a seed to reproduce results
rng(14);
% Number of random samples
N = 10;
% Generate random samples
samples = random('T', nu, N, 1);
% Create histogram
figure;
histogram(samples,'Normalization','pdf','BinWidth', 0.5);
title("Probability densities of the t distribution", "(\nu = "+ nu +")");
xlabel('t');
ylabel('Probability density');

% The grap shows that when the number of samples is small, the histogram
% does not have a clear shape.

%% Increasing the number of samples
rng(14);

N = 100;

samples = random('T', nu, N, 1);

figure;
histogram(samples, 'Normalization', 'pdf', 'BinWidth', 0.5);
title("Probability densities of the t distribution", "(\nu = "+ nu +")");
xlabel('t');
ylabel('Probability density');

% The number of samples has now been multiplied by ten, making the
% frequency distribution look more smooth and has a distinguishable shape.

%% Limiting distribution

% As we keep on increasing the number of samples, we approach the limiting
% distribution and get the PDF of the t-distribution.

x = -5:0.1:5;
y = pdf('T', x, nu);

figure;
plot(x, y, 'LineWidth', 2);
title("PDF of the t distribution", "(\nu = "+ nu +")");
xlabel('t');
ylabel('Probability density');

%% Limiting distribution with different degrees of freedom
x = -5:0.1:5;

y1 = pdf('t', x, 5);
y2 = pdf('t', x, 9);
y3 = pdf('t', x, 30);

figure;
plot(x, y1, 'LineWidth', 0.5);
hold on
plot(x, y2, 'LineWidth', 0.5)
plot(x, y3, 'LineWidth', 0.5)
title(["PDF of the t distribution", "with multiple degrees" + ...
    " of freedom"]);
legend("\nu = 5", "\nu = 9", "\nu = 30")
xlabel('t');
ylabel('Probability density');