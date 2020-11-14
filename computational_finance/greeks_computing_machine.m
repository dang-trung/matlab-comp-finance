% Later, I want to put users into debug mode to terminate the script. 
% Assume user has used our program, they have to re-enter normal mode using 
% 'dbquit' right at the start.

%% Greetings
disp("GREETINGS! I'm the OPTION'S GREEKS COMPUTING MACHINE!!!")
disp('---------------')
disp("All I need from you is a few data of the underlying asset, as well")
disp(" as some from the options themself.")
disp('---------------')
disp("Please note that if you compute the Greeks for 3 or more options from")
disp("the same underlying asset, later you will have a choice to form a")
disp("portfolio that neutralize in delta, gamma, vega.")
disp('---------------')

proceed = yesorno("So, Are you READY to work with me? (Y/N)\n\>> ");
if proceed == 'N' | proceed == 'n'
    ciao % function to end the script (defined at last lines)
end

%% 
% Ask for S0, mu, sigma (3 of 6 arguments needed by func 'greeks_antithetic')
% Since these arguments won't change for the options of the same underlying
% asset, I will only ask for them once.
prompt_S0 = "Enter the asset price: ";
prompt_mu = "Enter the asset's expected return (\mu): ";
prompt_sigma = "Enter the asset price's volatility (\sigma): ";
st_prompt = {prompt_S0, prompt_mu, prompt_sigma};
st_dlgtitle = 'Enter Properties of the Underlying Asset'; % title of the dialog box
st_dims = [1 100]; % make sure the questions only appear in 1 line
st_definput = {'','',''};
st_opts.Interpreter = 'tex'; % to show mu and sigma as symbols in the box

stockinput = inputdlg(st_prompt,st_dlgtitle,st_dims,st_definput,st_opts);
S0 = str2num(stockinput{1}); % Matlab stores the input as cell array of
mu = str2num(stockinput{2}); % characters so I convert those into numeric
sigma = str2num(stockinput{3}); % form for later calculation.

%% 
% Ask for type, K, T (3 of 6 arguments needed by func 'greeks_antithetic')
% These arguments will be changed for each options. The users can choose to
% enter data of others options if they want (no limit).

% Prompts
prompt_type = "Enter type of the option: (Type 'c' for call option " +...
    "or 'p' for put option.)";
prompt_K = "Enter the option's strike price: ";
prompt_T = "Enter the option's time to maturity (years): ";
op_prompt = {prompt_type, prompt_K, prompt_T};
op_dlgtitle = 'Enter Properties of the Option';  % title of the dialog box
op_dims = [1 100]; % make sure the questions only appear in 1 line
op_definput = {'','',''};

type_data = ""; % a string vector of the option types.
op_data = []; % numeric matrix of strike prices & maturity.
greeks = []; % numeric matrix of greeks that are computed
num_opt = 1; % number of options involved.

% Ask for type, K, T of the options
ask_opt = 1; % ask for more options if ask_opt = 1
while ask_opt
    opinput = inputdlg(op_prompt,op_dlgtitle,op_dims,op_definput);
    type_data(num_opt,1) = opinput{1};
    op_data(num_opt,1) = str2num(opinput{2});
    op_data(num_opt,2) = str2num(opinput{3});
    % function to compute the greeks, defined at the last lines
    [delta, gamma, vega] = greeks_antithetic(S0, mu, sigma,...
        op_data(num_opt,1), op_data(num_opt,2),...
        type_data(num_opt));
    % add the computed greeks to our matrix (for later summary & form
    % greek-neutralized portfolio)
    greeks = [greeks; delta, gamma, vega];
    disp("The option with data entered just now, has: ") % display the greeks
    disp("* Delta: " + num2str(delta))
    disp("* Gamma: " + num2str(gamma))
    disp("* Vega: " + num2str(vega))
    num_opt = num_opt + 1;
    ask_anoopt = "Do you want to input data of another option with the " +...
        "same underlying asset? (Y/N)\n\>> "; % choose to enter more or not
    anoopt_YN = yesorno(ask_anoopt);
    if isequal(anoopt_YN, 'N') | isequal(anoopt_YN, 'n')
        ask_opt = 0;
    end
end

% If number of options >=2, the user can choose to summarize the datas in a table
if num_opt > 2
    disp("So you have entered data and computed the Greeks for a total "+...
        "of " + num2str(num_opt-1) + " option(s).")
else
    ciao % end the script if number of options = 1
end

disp("I can summarize the properties of all options we have computed ")
disp("together in a table for you. Do you want to proceed? (Y/N)")
sum_YN = yesorno(">> ");
if sum_YN == 'N' | sum_YN == 'n'
    ciao % end the script if the user doesn't want
end

rowNames = "";
type_full = "";
for i = 1:(num_opt-1)
    rowNames(1,i) = "Option " + num2str(i); % Name the rows (Option #)
    if type_data(i,1) == 'c'
        type_full(i,1) = "Call"; % Option type in full (no abbr)
    elseif type_data(i,1) == 'p'
        type_full(i,1) = "Put"; % Option type in full (no abbr)
    end
end
varNames = {'OptionType', 'StrikePrice', 'Maturity', 'Delta', 'Gamma', 'Vega'};
op_table = table(type_full, op_data(:,1), op_data(:,2), greeks(:,1),...
    greeks(:,2), greeks(:,3), 'VariableNames',varNames,'RowNames',...
    transpose(rowNames)); % create the table summarizes data
disp(op_table)

%% Greek Hedging
% If number of options >=3, the user can choose to form a portfolio of the
% underlying asset and its options that achieve delta, gamma and vega
% neutral.

if num_opt <= 3
    ciao % end the script if number of options < 3
end

disp("I can help you form a portfolio of the underlying asset and the ")
disp("above options with a proportion that would approximately neutralize ")
disp("all 3 Greeks (Delta, Gamma & Vega). Do you want to proceed? (Y/N)")
form_YN = yesorno(">> "); % give the choice
if form_YN == 'N' | form_YN == 'n'
    ciao
end

% Compute the proportion
gammavega = greeks(:,2:3)';
weight_lasttwo = inv(gammavega(:,(num_opt-2):(num_opt-1)))*-gammavega(:,1:num_opt-3);
weight = [ones(num_opt-3,1); weight_lasttwo]; % full weight vector for options
weight_spot = -greeks(:,1)'* weight; % weight for underlying asset
weight = [weight_spot; weight]; 
const = 1000 / weight(1,1);
trans_weight = weight * const; % standardize the weight vector for each 1000 units of assets.

disp("In order to (approximately) neutralize 3 Greeks (Delta, Gamma, Vega),")
disp("we need to form a portfolio that has a proportion as below: ")
disp('---------------')
disp("For every 1000 units in the underlying asset: ")
for i = 1:num_opt-1
    disp("* Take " + pos(trans_weight(i+1)) + " position(s) in Option " + num2str(i) + ".")
end
ciao

%% Define useful functions

function [delta,gamma,vega] = greeks_antithetic(S0,mu,sigma,K,T,type)
%   Compute 3 Greek letters of an European call or put option paying no
%   dividend using Monte Carlo simulation and finite difference method.
%   Antithetic variable technique is also applied for variance reduction
%   purposes.

%   Arguments:
%   * S0: spot price at t0
%   * mu: expected return of the stock (annualized, continous compounding)
%   * sigma: volatility of the stock (annualized)
%   * K: strike price
%   * T: time to expiration
%   * type: 'c' for call option; 'p' for put option

%% Check validity of the inputs and throw errors if necessary
if isempty(S0) | ~isnumeric(S0) | S0 <= 0
    error("Asset price must be a positive number.")
elseif isempty(mu) | ~isnumeric(mu) | mu <= 0
    error("Asset's expected return must be a positive number.")
elseif isempty(sigma) | ~isnumeric(sigma) | sigma <= 0
    error("Asset price's volatility must be a positive number.")
elseif isempty(T) | ~isnumeric(T) | T <= 0
    error("Time to maturity must be a positive number.")
elseif ~isequal(type, 'c') & ~isequal(type, 'p')
    error("Type of option must be 'c' for call ontions or 'p' for put options.")
end

if size(S0) ~= [1 1] | size(mu) ~= [1 1] | size(sigma) ~= [1 1] |...
        size(K)  ~= [1 1] | size(T)  ~= [1 1]
    error("Use '.' as the decimal separator for numeric inputs.")
end

times = 250000; % number of simulations
dif = 0.005; % proportion of difference to S or sigma
u = 1 + dif;
d = 1 - dif;

%% Estimate Delta
for i = 1:times
    
    eps(i,1) = randn; % epsilon
    % generate daily prices using S0*u & eps; S0*d & eps
    STu(i,1) = (S0*u)*exp((mu - sigma^2/2)*T + sigma*eps(i,1)*sqrt(T));
    STd(i,1) = (S0*d)*exp((mu - sigma^2/2)*T + sigma*eps(i,1)*sqrt(T));
    % compute payoffs from above daily prices
    if strcmp(type, 'c')
        payoffu(i,1) = max([(STu(i,1) - K)  0])*exp(-mu*T);
        payoffd(i,1) = max([(STd(i,1) - K)  0])*exp(-mu*T);
    elseif strcmp(type, 'p')
        payoffu(i,1) = max([(K - STu(i,1))  0])*exp(-mu*T);
        payoffd(i,1) = max([(K - STd(i,1))  0])*exp(-mu*T);
    else
        error("Type of option  must be 'c' for call or 'p' for put.")
    end
    
    eps2(i,1) = -eps(i,1); % minus epsilon ~ antivariate variable technique
    % generate daily prices using S0*u & (-eps); S0*d & (-eps)
    STu2(i,1) = (S0*u)*exp((mu - sigma^2/2)*T + sigma*eps2(i,1)*sqrt(T));
    STd2(i,1) = (S0*d)*exp((mu - sigma^2/2)*T + sigma*eps2(i,1)*sqrt(T));
    % compute payoffs from above daily prices
    if strcmp(type, 'c')
        payoffu2(i,1) = max([(STu2(i,1) - K)  0])*exp(-mu*T);
        payoffd2(i,1) = max([(STd2(i,1) - K)  0])*exp(-mu*T);
    elseif strcmp(type, 'p')
        payoffu2(i,1) = max([(K - STu2(i,1))  0])*exp(-mu*T);
        payoffd2(i,1) = max([(K - STd2(i,1))  0])*exp(-mu*T);
    end
    
end

% Compute the central difference approximation of delta from the payoffs generated
% (Formula in 'Finite Difference method' - Section 21.8 Hull's book)

deltas = [(payoffu - payoffd)./ (S0 * (u-d));(payoffu2 - payoffd2)./ (S0 * (u-d))];
delta = round(mean(deltas),3); % first-order derivative, rounds to 3 decimal point

%% Estimate Gamma

for i = 1:times
    
    % generate daily prices using S0 & eps; S0 & (-eps)
    ST(i,1) = S0*exp((mu - sigma^2/2)*T + sigma*eps(i,1)*sqrt(T));
    ST2(i,1) = S0*exp((mu - sigma^2/2)*T + sigma*eps2(i,1)*sqrt(T));
    % compute payoffs from above daily prices
    if strcmp(type, 'c')
        payoff(i,1) = max([(ST(i,1) - K)  0])*exp(-mu*T);
        payoff2(i,1) = max([(ST2(i,1) - K)  0])*exp(-mu*T);
    elseif strcmp(type, 'p')
        payoff(i,1) = max([(K - ST(i,1))  0])*exp(-mu*T);
        payoff2(i,1) = max([(K - ST2(i,1))  0])*exp(-mu*T);
    end
    
end

% Compute the fite difference approximation of Gamma from the payoffs generated
% (Formula in 'Finite Difference method' - Section 21.8 Hull's book)

gammas = [(payoffu - 2*payoff + payoffd)/((S0*(u-d)/2)^2);...
    (payoffu2 - 2*payoff2 + payoffd2)/((S0*(u-d)/2)^2)];
gamma = round(mean(gammas),3); % second-order derivative, rounds to 3 decimal point

%% Estimate Vega

sigmau = sigma*u;
sigmad = sigma*d;
for i = 1:times
    
    eps(i,1) = randn; % epsilon
    % generate daily prices using S0, sigmau & eps; S0, sigmad & eps
    STu_veg(i,1) = S0*exp((mu - sigmau^2/2)*T + sigmau*eps(i,1)*sqrt(T));
    STd_veg(i,1) = S0*exp((mu - sigmad^2/2)*T + sigmad*eps(i,1)*sqrt(T));
    % compute payoffs from above daily prices
    if strcmp(type, 'c')
        payoffu_veg(i,1) = max([(STu_veg(i,1) - K)  0])*exp(-mu*T);
        payoffd_veg(i,1) = max([(STd_veg(i,1) - K)  0])*exp(-mu*T);
    elseif strcmp(type, 'p')
        payoffu_veg(i,1) = max([(K - STu_veg(i,1))  0])*exp(-mu*T);
        payoffd_veg(i,1) = max([(K - STd_veg(i,1))  0])*exp(-mu*T);
    end
    
    eps2(i,1) = -eps(i,1); % minus epsilon ~ antivariate variable technique
    % generate daily prices using S0, sigmau & (-eps); S0, sigmad & (-eps)
    STu2_veg(i,1) = S0*exp((mu - sigmau^2/2)*T + sigmau*eps2(i,1)*sqrt(T));
    STd2_veg(i,1) = S0*exp((mu - sigmad^2/2)*T + sigmad*eps2(i,1)*sqrt(T));
    % compute payoffs from above daily prices
    if strcmp(type, 'c')
        payoffu2_veg(i,1) = max([(STu2_veg(i,1) - K)  0])*exp(-mu*T);
        payoffd2_veg(i,1) = max([(STd2_veg(i,1) - K)  0])*exp(-mu*T);
    elseif strcmp(type, 'p')
        payoffu2_veg(i,1) = max([(K - STu2_veg(i,1))  0])*exp(-mu*T);
        payoffd2_veg(i,1) = max([(K - STd2_veg(i,1))  0])*exp(-mu*T);
    end
end

vegas = [(payoffu_veg - payoffd_veg)/(sigmau - sigmad);...
    (payoffu2_veg - payoffd2_veg)/(sigmau - sigmad)];
vega = round(mean(vegas),3); % first-order derivative, rounds to 3 decimal point

end

function answer = yesorno(prompt)
%% Ask user to input only 'Y' or 'N' or 'y' or 'n'
answer = input(prompt,'s');
while isequal(answer,'Y') + isequal(answer,'y') + isequal(answer,'N') + isequal(answer,'n') == 0
    disp('ONLY enter Y or N.')
    disp('Enter your answer again.')
    disp('---------------')
    answer = input(prompt,'s');
end
disp('---------------')
end

function longshort = pos(number)
%% Change a number to a long/short position.
number = round(number,0);
if number < 0
    longshort = "Short " + num2str(-number);
elseif number > 0
    longshort = "Long " + num2str(number);
end
end

function ciao
%% End the program
disp("Thank you for using the program.")
disp("Have a great day! Goodbye.")
disp('---------------')
keyboard %  put user in debug mode to terminate the script
end
