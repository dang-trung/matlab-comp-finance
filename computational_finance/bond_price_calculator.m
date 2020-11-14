%% Greetings
user_name = input("Please enter your name:\n\>> ", 's');                        
disp('------------')

Greet = "Greetings " + user_name + ... 
    "! Welcome to my bond price calculator!";
disp(Greet)
disp('------------')

disp("You must be here to price a bond.")
disp("Please note that my low-level program can ONLY price a bond " + ...
    "with annual or semi-annual coupon payments.")
disp("For higher coupon frequency or more complicated bonds, kindly " + ... 
    'do some research on <a href = "https://www.google.com">Google</a>.')
disp('------------')

% Flag to boot the Bond Price Calculator
boot_up = 1;  
while isequal(boot_up, 1)
    
    %% Ask for Coupon Frequency
    prompt_cfreq = "Now ENTER the coupon payment frequency of your " + ...
                   "bond (TYPE 1 for annual coupon OR 2 for " + ...
                   "semi-annual coupon):\n\>> "; 
    c_freq = str2num(input(prompt_cfreq, 's')); 
   
    %% Ensure user only can enter 1 or 2 in this step.
    c_freq_ready = 0;
    while isequal(c_freq_ready, 0) 
        
        if isequal(c_freq, 1) | isequal(c_freq, 2)
            disp("Great, got it!")
            c_freq_ready = 1;       
        else % response when user input differs from 1 or 2
            disp("Why you do this " + user_name + "...")
            disp("JUST BEFORE! I told you The program ONLY accept 1 or 2!")
            disp('------------')
            prompt_cfreq2 =  "Now please RE-ENTER the coupon payment " + ... 
                "frequency of your bond (TYPE: 1 for annual coupon OR " + ...
                "2 for semi-annual coupon):\n\>> ";
            c_freq = str2num(input(prompt_cfreq2, 's')); 
            c_freq_ready = 0;       
        end
        
    end
    disp('------------')

    %% Ask for Annual Coupon Rate
    prompt_crate = "Next, please ENTER the percentage (%) of the annual " +...
                   "coupon rate of your bond:\n\(NOTE: Please use '.'" +...
                   "as the decimal separator, instead of ','.)\n\>> ";
    c_rate = str2num(input(prompt_crate, 's')); % same as explained above
    
    % Ensure user can ONLY enter a number in this step. 
    % Ensure user MUST enter '.' as a fractional separator, rather than ','
    c_rate_format = 0;
    while isequal(c_rate_format, 0)
        % str2num transforms strings of characters into []
        if isequal(numel(c_rate), 0) | numel(c_rate) > 2 
            disp("The program ONLY accepts a number!")
            disp('------------')
            prompt_crate2 = "RE-ENTER the percentage (%) of the annual " + ...
                            "coupon rate of your bond: \n\(NOTE: Please " + ...
                            "use '.' as the decimal separator, instead of" + ...
                            "','.)\n\>> ";
            c_rate = str2num(input(prompt_crate2, 's'));       
        % Matlab understands number with ',' as a vector with 2 elements
        elseif isequal(numel(c_rate),2) 
            disp("It seems you are using ',' as the decimal separator.")
            disp('------------')
            prompt_crate2 = "RE-ENTER the percentage (%) of the annual " + ... 
                            "coupon rate of your bond:\n\(NOTE: Please " + ...
                            "use '.' as the decimal separator, instead " + ...
                            "of ','.)\n\>> ";
            c_rate = str2num(input(prompt_crate2, 's'));       
        else
            c_rate_format = 1;  
        end    
    end
    % Quick warning if user enter a coupon rate in decimal instead of % form
    if c_rate < 0.1 
        disp("WARNING: ")
        disp("Are you sure with the form of the coupon rate you just enter?")
        disp("It seems a little too small to the usual coupon rate.")
        disp("Please note that I'm asking for rate expressed in " + ... 
            "percentage (ex: 5%), not decimal (ex: 0.05)!")
        disp("And, not entering the rate in percentage form will lead to " + ... 
            "a wrong result.") 
        disp('------------')
        err_ask = 1; % Flag to ask if user entered wrongly
        
        while isequal(err_ask,1) 
            
            err_crate = input("Did you mistakenly enter the decimal form " + ...
            "instead of the percentage form of the rate ? [Y/N]\n\>> ", 's');             
            % Fix if user mistakenly enter the wrong form
            if isequal(err_crate,'Y')| isequal(err_crate,'y')
                c_rate = c_rate * 100;
                disp("Don't worry, it'll be automatically fixed for you!")
                err_ask = 0;
            % Not doing anything and move on    
            elseif isequal(err_crate,'N')| isequal(err_crate,'n') 
                disp("Okay, just making sure before doing any calculation");
                err_ask = 0;            
            else
                disp("Please ONLY enter Y or N.")
                disp('------------')            
            end
            
        end
    else        
    end
    disp("All right! Now let's move to the next step.")
    disp('------------')

    %% Ask for years until maturity.

    prompt_ttm = "This time, please ENTER the number of years until " +...
        "maturity of your bond :\n\(NOTE: ONLY enter a natural number.)\n\>> "; 
    ttm = str2num(input(prompt_ttm, 's'));
    
    % Ensure users only input natural number (since it's a number of YEARS)
    while mod(ttm,1) ~= 0 | ttm <= 0 % No chars, fractional, or negatives
        disp("The program ONLY accepts natural number.")
        prompt_ttm2 = "Please RE-ENTER the number of years until maturity of your bond:\n\ >> ";
        ttm = str2num(input(prompt_ttm2, 's'));
        while isempty(ttm)  
            disp("The program ONLY accepts natural number.")
            ttm = str2num(input(prompt_ttm2, 's'));
        end    
    end

    disp("Great, got it!")
    disp('------------')

    %% Ask for Face Value:

    prompt_fv = "Next, please ENTER the Face Value of your bond:" +...
    "\n\(NOTE: Please use '.' as the decimal separator, instead of ','.)\n\>> "; 
    fv = str2num(input(prompt_fv, 's')); 
   
    % Ensure users only enter number with '.' as decimal separator 
    fv_format = 0;
    while isequal(fv_format, 0)
        % str2num transforms characters into []
        if isequal(numel(fv),0) | numel(fv) > 2
            disp("The program ONLY accepts a number!")
            prompt_fv2 = "RE-ENTER the Face Value of your bond:" + ...
                        "\n\(NOTE: Please use '.' as the decimal " + ... 
                        "separator, instead of ','.)\n\>> ";
            fv = str2num(input(prompt_fv2, 's'));
        % Matlab understands number with ',' as a vector with 2 elements    
        elseif isequal(numel(fv),2) 
            disp("It seems that you use ',' as the decimal separator.")
            prompt_fv2 = "RE-ENTER the Face Value of your bond:" + ...
                        "\n\(NOTE: Please use '.' as the decimal " + ...
                        "separator, instead of ','.)\n\>> ";
            fv = str2num(input(prompt_fv2, 's'));       
        else
            fv_format = 1;
        end        
    end
    disp("All right! Now, let's move to the next step.")
    disp('------------')

    % Ask for confirmation
    if isequal(c_freq,1) % for annual coupon bond
        disp("To summarise: you want to price a " + num2str(ttm) +...
             "-year bond" + newline + "with a Face Value of " + ...
             num2str(fv) + " which provides coupons" + newline + ...
             "at the rate of " + num2str(c_rate) + " % per annum annually.");  
    else % for semiannual coupon bond
        disp("To summarise: you want to price a " + num2str(ttm) +...
             "-year bond" + newline + "with a Face Value of " + ...
             num2str(fv) + " which provides coupons" + newline + ...
             "at the rate of " + num2str(c_rate) + " % per annum semi-annually.");    
    end
    
    %% Give user permission to re-enter everything without terminating the program
    prompt_reenter = "Does the bond summary sound right to you? [Y/N]\n\>> ";
    bond_info = input(prompt_reenter, 's'); 
    
    % Ensure user can only enter Y/N or y/n
    bond_info_ready = 0;
    while isequal(bond_info_ready,0)
        if isequal(bond_info,'Y') | isequal(bond_info, 'y') 
            boot_up = 0;
            bond_info_ready = 1;        
        elseif isequal(bond_info,'N') | isequal(bond_info, 'n')
            disp("Re-enter the characteristics of your bond!")
            disp('------------')
            bond_info_ready = 1;   
        else
            disp("ONLY type Y or N.")
            disp('------------')
            bond_info = input(prompt_reenter, 's');
        end   
    end   
end

disp('Great! Only 1 more step to finish our calculations.')
disp('------------')

%% Ask for zero rates
disp("Now, I need every zero rates (continuously compounded) as below " +...
     "in order to successfully price your bond: ")
disp("(NOTE: Please use '.' as the decimal separator, instead of ','.)")

for i = 1:1:(ttm*c_freq)
    prompt_zero = "Enter the " + num2str(i/c_freq) + "-year zero rate (%): ";
    dummy_zero = str2num(input(prompt_zero,'s')); 
    
    % Ensure format of zero rates (ONLY numbers with '.' as the decimal
    % separator - NO characters, strings or numbers with ',' as the decimal
    % separator). 
    
    % Use dummy_zero instead of adding values straight to our array or zero
    % rates to avoid Matlab notifying errors when users enter characters OR 
    % number with ',' as decimal separator. 
    
    dummy_format = 0;
    while isequal(dummy_format, 0)
        % str2num transforms strings of characters to []
        if isequal(numel(dummy_zero),0) | numel(dummy_zero) > 2 
            disp("The program ONLY accepts a number!")
            prompt_zero2 = "Re-enter the " + num2str(i/c_freq) + "-year zero rate (%): ";
            dummy_zero = str2num(input(prompt_zero2, 's'));
        % Matlab understands number with ',' as a vector with 2 elements
        elseif isequal(numel(dummy_zero),2) 
            disp("You should use '.', instead of ',' as the decimal separator.")
            prompt_zero2 = "Re-enter the " + num2str(i/c_freq) + "-year zero rate (%): ";
            dummy_zero = str2num(input(prompt_zero2, 's'));                
        % Only accept zero rates when format is right
        else 
            dummy_format = 1;   
        end  
    end
    % Add value to our zero rates vector after checking its format
    zero(1,i) = dummy_zero; 
end

disp('------------')

%% Pricing the bond
coupon = (fv * c_rate/100) / c_freq; % calculate coupons
b_price = 0;

for i = 1:1:(ttm*c_freq - 1) % calculate coupons and their PV
    pv_coupon(1,i) = coupon * exp(- zero(1,i)/100 * (i/c_freq)); 
    b_price = b_price + pv_coupon(1,i); % recursion
end
% calculate PV of last payment (coupon & FV) and add back to our price
b_price = b_price + (fv + coupon) * exp(- zero(1,ttm*c_freq)/100 * (ttm*c_freq/c_freq)); 

disp("Using the given information, the theoretical price of your bond " + ... 
    "is: " + num2str(b_price) + ".");
disp('------------')

%% Ask if the user want to calculate the matrix of yield-price pairs or not?

prompt_mc = "Now, assuming flat bond yields ranging from 0% to 20%,\n\" +...
            "do you want to compute a Matrix of Bond Yield-Price Pairs? [Y/N]\n\>> ";
matrix_create = input(prompt_mc, 's'); 

% Ensure users only type in Y/N:
    mc_ready = 0;
    while isequal(mc_ready,0)
        if isequal(matrix_create,'Y') | isequal(matrix_create, 'y')
            mc_ready = 1;  
        elseif isequal(matrix_create,'N') | isequal(matrix_create, 'n')
            disp("No Problem. We're all done!")
            disp("Thank you for using the program.")
            disp("Buona Giornata.")
            disp('------------')
            return     
        else
            disp("ONLY type Y or N.")
            disp('------------')
            matrix_create = input(prompt_mc, 's'); 
        end  
    end

%% Compute the bond prices corresponding with bond yields (0%-20%, step = 0.5%)

for i = 1:41
    b_yield(1,i) = (i-1)/200;
    b_mkprice(1,i) = 0;
    for t = 1:1:(ttm*c_freq - 1)
        b_mkprice(1,i) = b_mkprice(1,i) + coupon * exp(- b_yield(1,i) * (t/c_freq));
    end
    b_mkprice(1,i) = b_mkprice(1,i) + (fv + coupon) * exp(- b_yield(1,i) * ...
        (ttm*c_freq/c_freq));
end

%% Building the matrix of bond yield-price pairs
 
for i = 1:41
    % Express yields in %
    b_yield_str(1,i) = num2str(b_yield(1,i)*100, '%.1f') + "%";
    % Put corresponding yields and prices together
    yield_price(1,i) = b_yield_str(1,i) + "  ~  " + ... 
        num2str(b_mkprice(1,i), '%.4f');
end

for i = 42:50 % Add blank cells for matrix reshaping later 
    yield_price(1,i) = " ";
end

yield_price_re = reshape(yield_price,10,5); % Reshape matrix for easier reading
% Add column titles
yield_price_re = ["Yield ~    Price " "Yield ~    Price " "Yield  ~   Price " ...
                  "Yield  ~   Price " "Yield  ~   Price "; yield_price_re]; 
disp("Gotcha. Below is your matrix of bond yield-price pairs:")           
disp(yield_price_re)
disp('------------')            

%% Ask if the user want to plot or not?
prompt_gr = "Do you want to plot a graph between bond price and " +...
            "yield based on the above data? [Y/N]\n>> ";
gr_create = input(prompt_gr, 's');

gr_ready = 0; % Ensure the answer is only Y or N
while isequal(gr_ready,0)
    if isequal(gr_create, 'Y') | isequal(gr_create, 'y')
        gr_ready = 1;
    elseif isequal(gr_create, 'N') | isequal(gr_create, 'n')
        disp("No Problem. We're all done!")
        disp("Thank you for using the program.")
        disp("Buona Giornata.")
        disp('------------')
        return
    else
        disp("ONLY type Y or N.")
        disp('------------')
        gr_create = input(prompt_gr, 's'); 
    end
end

%% Plot the graph between bond price and bond yields
plot(b_mkprice,b_yield*100, 'r');
xlabel('Bond Price') % X-axis label
ylabel('Interest Rate (%)') % Y-axis label
title({'Graph: The relation between bond price and changes in interest rate',''})
saveas(gcf, 'Bond Yield-Price Graph.pdf')

disp("There's your graph!")
disp("I have also save it as a PDF file for you (in the Current Folder).")

prompt_open = "Do you want to open the file now? [Y/N]\n\>> ";
let_open = input(prompt_open, 's');

open_ready = 0; % Another while loop to ask for permission...
while isequal(open_ready,0)
    if isequal(let_open, 'Y') | isequal(let_open, 'y')
        open_ready = 1;
        open('bond yield vs price graph.pdf');
    elseif isequal(let_open, 'N') | isequal(let_open, 'n')
        disp("No Problem. We're all done!")
        disp("Thank you for using the program.")
        disp("Buona Giornata.")
        disp('------------')
        return
    else
        disp("ONLY type Y or N.")
        disp('------------')
        let_open = input(prompt_open, 's');
    end
end

%% Ciaos
disp("We're all done!")
disp("Thank you for using the program.")
disp("Buona Giornata.")
disp('------------')
return 