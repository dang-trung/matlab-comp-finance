function [price,interval] = lookback_antithetic(S0,T,mu,sigma,type)
%   Compute the price of a floating lookback call or put option & the 95%
%   Confidence Interval for this price using Monte Carlo simulation and
%   applying antithetic variable technique (for variance reduction).

%   Arguments:
%   * S0: spot price at t0
%   * T: time to expiration
%   * mu: expected return of the stock (annualized, continous compounding)
%   * sigma: volatility of the stock (annualized)
%   * type: 'c' for call option; 'p' for put option

if isnumeric([S0 T mu sigma]) == 0 % error message when user input wrong type of data
    error('First four arguments must be a number.')
end

deltat = 1/360; % time interval for stock price: daily (assume 360 days per year)
N = round(T/deltat); % number of days to compute stock price
times = 500; % number of trials
% [I'm putting this at half of the first method's number of
% trials to prove that:
% The std-error computed using this method with M trials is
% (much) less than the one computed using the first method
% with 2M trials (So this method is WORTH to use!)]

for i = 1:times % create 2 matrices of daily asset price during the option's life (1000 trials)
    ST(i,1) = S0; % first matrix: daily asset price computed using epsilon
    ST2(i,1) = S0; % second matrix: daily asset price computed using minus epsilon
    for k = 2:N+1 % compute daily asset price at day 1 (S1) to day N (SN) (1000 trials)
        eps(i,k) = randn; % epsilon
        eps2(i,k) = - eps(i,k); % minus epsilon
        ST(i,k) = ST(i,k-1) * exp((mu - sigma^2/2) * deltat + sigma * eps(i,k) * sqrt(deltat));
        ST2(i,k) = ST2(i,k-1) * exp((mu - sigma^2/2) * deltat + sigma * eps2(i,k) * sqrt(deltat));
    end
end

if type == 'c' % compute a matrix of payoffs for call option in 1000 trials
    for i = 1:times
        payoff1(i,1) = (ST(i,N+1) - min(ST(i,:))) * exp(-mu * T); % payoff from first matrix
        payoff2(i,1) = (ST2(i,N+1) - min(ST2(i,:))) * exp(-mu * T); % payoff from second matrix
        payoff(i,1) = (payoff1(i,1) + payoff2(i,1))/2; % average from both case
        % payoff = final asset price - minimum asset price achieved
        % then discount back to present
    end
elseif type == 'p' % compute a matrix of payoffs for put option in 1000 trials
    for i = 1:times
        payoff1(i,1) = (max(ST(i,:)) - ST(i,N+1)) * exp(-mu * T); % payoff from first matrix
        payoff2(i,1) = (max(ST2(i,:)) - ST2(i,N+1)) * exp(-mu * T); % payoff from second matrix
        payoff(i,1) = (payoff1(i,1) + payoff2(i,1))/2; % average from both case
        % payoff = maximum asset price achieved - final asset price
        % then discount back to present
    end
else
    error("Type of option must be 'c' for call options or 'p' for put options.") % error message
end

price = mean(payoff, 'all'); % compute average payoff
stderror = std(payoff)/sqrt(times); % compute standard error
lower = price - 1.96 * stderror; % lower bound of 95% CI
upper = price + 1.96 * stderror; % upper bound of 95% CI
interval = [lower, upper]; % 95% CI

end