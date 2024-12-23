%% Calculating the power of a test
% Clear up the workspace
clear

% Setting the seed
rng(5)

% Setting up the base parameters
iter = 500;
n = 80;
B_1 = 0.7;
B_p = NaN(1, iter); % To store all the p values

% Multiple actions will be performed in the for loop below
%  1. Creating the linear model;
%  2. Use exercisefunctionlss() to get estimated coefficients (beta hat) 
%     and the standard errors. 
%  3. Calculate the corresponding p value store this value.
% Afterwards we determine the fraction of p values that have a value less
% than 0.05 (our preferred significance level). This fraction is the
% power of the test.

for i = 1:iter 
    % Create a sampling distribution for the OLS estimator
    x_1 = random('Normal', 0, 1, n, 1);
    u = random('Normal', 0, 2, n, 1);
    y = x_1*B_1 + u;
    LSS =  exercisefunctionlss(y, x_1);
    % Test statistic
    B_t = LSS.B_hat/LSS.B_hat_SEE; 
    B_p(i) = 2*cdf('T', -abs(B_t), n - LSS.K);
end

mean(B_p < 0.05) % Power of the test

%% Increasing the sample size to find a better power
% We have now calculated the power in the case of 120 samples and an effect
% size of 0.7. This power is not satisfying as we want to have a power of
% at least 90%.

% A satisfying power can be found through trial and error. It is therefore
% efficient to create a loop that calculates the power for multiple values
% of the parameter of interest (e.g. the sample size or effect size). Let's
% first focus on the sample size. We will create a for loop that stores the
% power for specific sample sizes.

clear
rng(5)
iter = 500;
B_1 = 0.7;
B_p = NaN(1, iter);

n_samples = (80:10:150); % The sample sizes that we will test for

N_and_Power = table(n_samples', NaN(length(n_samples), 1), ...
    'VariableNames', ["Sample size", "Power"]);

for j = 1:length(n_samples)
    for i = 1:iter
        x_1 = random('Normal', 0, 1, n_samples(j), 1);
        u = random('Normal', 0, 2, n_samples(j), 1);
        y = x_1*B_1 + u;
        LSS = exercisefunctionlss(y, x_1);
        B_t = LSS.B_hat/LSS.B_hat_SEE; 
        B_p(i) = 2*cdf('T', -abs(B_t), n_samples(j) - LSS.K);
    end
    N_and_Power.Power(j) = mean(B_p < 0.05);
end

N_and_Power;

figure
plot(N_and_Power, "Sample size", "Power");
title("How sample size influences the power")
yline(0.9, '--');

% The output tells us that a sample size of close to 100 samples gives
% sufficient power.

%% Effect size as the determinant of the power
% Now we set the number of samples back to 80 and instead calculate the
% power for different effect sizes. 

clear
rng(5)
iter = 500;
n = 80;
B_p = NaN(1, iter);

effectsizes = (0.1:0.1:0.9); % The effect sizes that we will test for

Effect_and_Power = table(effectsizes', NaN(length(effectsizes), 1), ...
    'VariableNames', ["Effect", "Power"]);

for j = 1:length(effectsizes)
    for i = 1:iter
        x_1 = random('Normal', 0, 1, n, 1);
        u = random('Normal', 0, 2, n, 1);
        y = x_1*effectsizes(j) + u;
        LSS = exercisefunctionlss(y, x_1);
        B_t = LSS.B_hat/LSS.B_hat_SEE;
        B_p(i) = 2*cdf('T', -abs(B_t), n - LSS.K);
    end
    Effect_and_Power.Power(j) = mean(B_p < 0.05);
end

Effect_and_Power;

figure
plot(Effect_and_Power, "Effect", "Power")
title("How effect size influences the power")
yline(0.9, '--');

% This graph shows that the minimum detectable effect size of the
% coefficient in the case of 120 samples is a little less than 0.6.

%% The effect of variance on the power
% Let's set the effect size back to its original values and now focus on
% the variance of x_1.

clear
rng(5)
iter = 500;
n = 80;
B_1 = 0.7;
B_p = NaN(1, iter);

varianceset = 0.6:0.2:1.4; % The set of variances that we will test for

Variance_and_Power = table(varianceset', NaN(length(varianceset), 1), ...
   'VariableNames', ["Variance", "Power"]);
for j = 1:length(varianceset)
    for i = 1:iter
    x_1 = random('Normal', 0, sqrt(varianceset(j)), n, 1);
    u = random('Normal', 0, 2, n, 1);
    y = x_1*B_1 + u;
    LSS = exercisefunctionlss(y, x_1);
    B_t = LSS.B_hat/LSS.B_hat_SEE; 
    B_p(i) = 2*cdf('T', -abs(B_t), n - LSS.K);
    end
    Variance_and_Power.Power(j) = mean(B_p < 0.05);
end

Variance_and_Power;

figure
plot(Variance_and_Power, "Variance", "Power")
title("How variance influences the power")
yline(0.9, '--');

% The above table shows us that as the variance of x_1 increases, the power
% of the test also increases; the (total) variance of y becomes 'relatively
% more explained' by the variance of x_1. In this example, the minimum
% variance required for a satisfying power is inbetween 1.1 and 1.2. 

%% Changing the model
% To show how correlation between two variables affects the power, we need
% to make some small changes to our model. x_2 will be added to our model
% and we will let x_1 and x_2 be bivariate normal distributed. To show that
% the power of the test is not much different than the power in the first
% example, we will use an identity matrix for the variance-covariance
% matrix for the bivariate normal distribution (as this means that there is
% no correlation between x_1 and x_2).

clear
rng(5)
iter = 500;
n = 80;
B_1 = 0.7;
B_2 = 0.75;
B_true = [B_1; B_2];
B_p = NaN(1, iter);

for i = 1:iter
    x_1_x_2_bivariate = mvnrnd([0 0], [1 0; 0 1], n);
    x_1 = x_1_x_2_bivariate(:,1);
    x_2 = x_1_x_2_bivariate(:,2);
    X = [x_1 x_2];
    u = random('Normal', 0, 2, n, 1);
    y = X*B_true + u;
    LSS = exercisefunctionlss(y, X);
    B_t = LSS.B_hat(1)/LSS.B_hat_SEE(1);
    B_p(i) = 2*cdf('T', -abs(B_t), n - LSS.K);
end

mean(B_p < 0.05)

% It can be observed that the power of the test is almost equal to the
% power in the first example.

%% Correlation
% To allow for more ease in changing the bivariate normal distribution, we
% will use sigma_1 and sigma_2 to denote the standard deviations of x_1 and
% x_2 respectively in the case that these variables were uncorrelated and
% normal distributed (with mean zero and standard deviations sigma_1 and
% sigma_2 respectively).

clear
rng(5)
iter = 500;
n = 80;
B_1 = 0.7;
B_2 = 0.75;
B_true = [B_1; B_2];
sigma_1 = 1;
sigma_2 = 1;
B_p = NaN(1, iter);

correlationset = [0:0.1:0.9 0.99];

Correlation_and_Power = table(correlationset', ...
    NaN(length(correlationset), 1), 'VariableNames', ["Correlation", ...
    "Power"]);
for j = 1:length(correlationset)
    for i = 1:iter
    x_1_x_2_bivariate = mvnrnd([0 0], [sigma_1^2 ...
        correlationset(j)*sigma_1*sigma_2; ...
        correlationset(j)*sigma_1*sigma_2 sigma_2^2], n);
    x_1 = x_1_x_2_bivariate(:,1);
    x_2 = x_1_x_2_bivariate(:,2);
    X = [x_1 x_2];
    u = random('Normal', 0, 2, n, 1);
    y = X*B_true + u;
    LSS = exercisefunctionlss(y, X);
    B_t = LSS.B_hat(1)/LSS.B_hat_SEE(1); 
    B_p(i) = 2*cdf('T', -abs(B_t), n - LSS.K);
    end
    Correlation_and_Power.Power(j) = mean(B_p < 0.05);
end

Correlation_and_Power;

figure
plot(Correlation_and_Power, "Correlation", "Power");
title("How correlation influences the power");
ylim([0 1]);
yline(0.9, '--');

% The table shows that when the correlation between x_1 and x_2 increases,
% the power of the test decreases. To improve the power, the same 'tricks'
% can be used again:
%   - Increasing the sample size;
%   - Increasing the effect size of the random variable(s).