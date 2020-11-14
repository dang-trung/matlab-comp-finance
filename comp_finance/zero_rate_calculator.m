% Later, I want to put users into debug mode to terminate the script. 
% Assume user has used our program, they have to re-enter normal mode using 
% 'dbquit' right at the start.
try
    dbquit
catch
end
%% Introduction
user_name = input("Please enter your name:\n\>> ", 's');
disp('---------------')

Greet = "Greetings " + user_name + "! I'm your ZERO RATES COMPUTING MACHINE!";
disp(Greet)
disp('---------------')

disp("My motto is: SIMPLE, CONVENIENT & STRAIGHT-TO-THE-POINT!")
disp("Just give me your DATA! I give you the ZERO RATES!")
disp("...or at LEAST I can throw at you some kinds of ERROR messages...")
disp('---------------')

%% STEP 2-4: 
% Compute zero rates from a .csv file which contains data of
% various zero-coupon bonds with different maturities and the same par
% of 100 euros. Required Data: Time to Maturity (years); Price (euros).

% Ask user if he/she wants to do calculations of zero rates based on data
% of zero-coupon bonds or not?
disp("[STEP 2]")
prompt_list = "Now, do you need to compute zero rates using a list of " +...
    "zero-coupon bonds with the same par but different " +...
    "maturities?\n\>> ";
prov.list = tr_yesorno(prompt_list); % define 'tr_yesorno' at the end of script
if isequal(prov.list, "N") || isequal(prov.list, "n")
    disp("Thank you for saying hi and trying my program!")
    tr_ciao
else
    disp("Sure! Follow my lead.")
    disp('---------------')
end

%% (STEP 2) 
% Ask user to input the path of a .csv file contains maturities and prices of
% zero-coupon bonds. Check the file's existence, check the format for later
% computations.

% Ask user to enter a .csv file name. Check it existence:
% - If file can be found, transform it into a matrix.
% - If file cannot be found, inform the user to enter the filename again.
disp("Now, you need to provide a .csv file which contain data of ")
disp("zero-coupon bonds. The file must have exact 2 columns, with ")
disp("Time To Maturity (years) in the first one and Price in the ")
disp("second one. Assuming these coupons all have a par value of ")
disp("100 euros.")

prompt_filezero = "Enter the file name of your .csv file:\n\>> ";
csv_zero = tr_readmatrix(prompt_filezero); % all of the above procedures
% done by 'tr_readmatrix', please
% read more at the end of the
% script.

% Check the format of the converted matrix (using function 'tr_checkmat',
% kindly find it at the end of the script):

% - If the format is correct, accept the file for later computations.
% - If the format is wrong, ask the user to change the file. If the user
% doesn't want to change, stop the program.

% [The correct format here: exact 2 columns, full of numeric data accepted
% by Matlab]
while isequal(tr_checkmat(csv_zero, 2),0)
    disp("Your file format is not valid.")
    disp("You must provide a .csv file with exact 2 columns, composed only ")
    disp("by NUMERIC data, and use '.' (not ',') as the decimal separator.")
    prov.anoth = tr_yesorno("Do you want to provide another file? [Y/N]\n\>> ");
    if isequal(prov.anoth, 'Y') || isequal(prov.anoth, 'y')
        csv_zero = tr_readmatrix(prompt_filezero);
    else
        disp("Thank you for saying hi and trying my program!")
        tr_ciao
    end
end

% Quick warning if there're some signs that the file's columns are provided 
% in a wrong order (mean of maturity > 70, mean of price < 50).
% The right order is: 1st: Maturity, 2nd: Price.
% Ask the user to fix the file content if he's truly wrong.
if mean(csv_zero(:,1)) > 70 || mean(csv_zero(:,2)) < 50
    disp("Please note that providing bond's data in any order different from")
    disp("the required order (1st column: Maturity, 2nd column: Price) will")
    disp("result in WRONG computation.")
    order.anoth = tr_yesorno("Are you sure your file contents are" +...
        "provided in the required order?");
    if isequal(order.anoth,'N') || isequal(order.anoth,'N')
        disp("Please modify your .csv file as required and restart")
        disp("the program again.")
        clear
        tr_ciao
    else
    end
    disp("No worries, just asking to make sure before doing any")
    disp("computations")
    disp('---------------')
    
else
end
csv_zero = sortrows(csv_zero); % sort the bonds in order of time to maturity

%% (STEP 3) 
% Compute the zero rates then display together with the maturities
sizecsv = size(csv_zero);
par = 100*ones(sizecsv(1),1); % create matrix of par (same 100s)
zero = tr_zerorate(csv_zero(:,1),csv_zero(:,2),par);
zero_maturity = [csv_zero(:,1), strcat(num2str(zero*100),"%")];
zero_maturity = ["Maturity (years)", "Zero Rate"; zero_maturity];
disp("[STEP 3]")
disp("The computed zero rates are summarized in the matrix below")
disp("(From short to long maturities):")
disp('---------------')
disp(zero_maturity)
disp('---------------')

%% (STEP 4) 
% Draw a graph of the zero rates as a function of time to maturity

% Ask the user if he wants to draw or not?
disp("[STEP 4]")
prompt_draw = "Do you want to draw a graph of the zero rates as a " +...
    "function of time to maturity?\n\>> ";
draw = tr_yesorno(prompt_draw);
if isequal(draw,'Y') || isequal(draw,'y')
    disp("Here's your graph!")
    disp('---------------')
    plot(csv_zero(:,1), zero*100)
    xlabel('Maturity (years)') % X-axis label
    ylabel('Zero Rate (%)') % Y-axis label
    title({'Graph: Relation between Zero Rates and maturities',''})
else
    disp("No Problem. Let's move to the next step.")
    disp('---------------')
end

%% STEP 5-8:
% Compute zero rates from a .csv file which contains data of
% various coupon-bearing bonds with different maturities and the same par
% of 100 euros. Required Data: Time to Maturity (years); Annual Coupon;
% Price (euros).

% Ask user if he/she wants to do calculations of zero rates based on data
% of coupon-bearing bonds or not?
disp("[STEP 5]")
disp("Listen! I can still compute zero rates at longer maturities even if")
disp("you do not have the data for zero-coupon bonds with these maturities.")
disp("You just need to provide the data for coupon-bearing bonds with the")
disp("same maturities (bootstrap method).")
disp('---------------')

prompt_list2 = "Now, do you wish to compute zero rates using bootstrap method? \n\>> ";
prov.list2 = tr_yesorno(prompt_list2);
if isequal(prov.list2, "N") || isequal(prov.list2, "n")
    disp("No worries. Thanks for working with me earlier.")
    tr_ciao
else
end
disp("Sure! Follow my lead.")
disp('---------------')

%% (STEP 5) 
% Ask user to input a .csv file contains maturities and prices of
% coupon-bearing bonds. Check the file's existence, check the format for
% later computations.

% Ask user to enter a .csv file name. Check it existence:
% - If file can be found, transform it into a matrix.
% - If file cannot be found, inform the user to enter the filename again.
% This is done by 'tr_readmatrix', kindly find it at the end of the script.

disp("Now, you need to provide a .csv file which contains data of ")
disp("coupon-bearing bonds. The file must have exact 3 columns, with ")
disp("Time To Maturity (years) in the first one, Annual Coupon in the ")
disp("second one, and Price in the third one.")
disp("Assuming these bonds all have a par value of 100 euros and the")
disp("coupon are paid semi-annually. The nearest coupon payment is")
disp("after 6 months.")

prompt_filecp = "Enter the file name of your .csv file:\n\>> ";
csv_cp = tr_readmatrix(prompt_filecp);
disp('---------------')

% Check the format of the converted matrix (using function 'tr_checkmat',
% kindly find it at the end of the script):

% - If the format is correct, accept the file for later computations.
% - If the format is wrong, ask the user to change the file. If the user
% doesn't want to change, stop the program.

% [The correct format here: exact 3 columns, full of numeric data]

while isequal(tr_checkmat(csv_cp, 3),0)
    disp("Your file format is not valid.")
    disp("You must provide a .csv file with exact 3 columns, composed only ")
    disp("by NUMERIC data, and use '.' (not ',') as the decimal separator.")
    prov.anoth2 = tr_yesorno("Do you want to provide another file? [Y/N]\n\>> ");
    if isequal(prov.anoth2, 'Y') || isequal(prov.anoth2, 'y')
        csv_cp = tr_readmatrix(prompt_filecp);
        disp('---------------')
    else
        disp("Unfortunately I cannot continue the computation with the")
        disp("provided data!")
        tr_ciao
    end
end

%%
% Quick warning if there're some signs (mean of maturity > 70, mean of
% annual coupon > 20, mean of price < 50) that the file's columns are
% provided in a wrong order.
% The right order is: 1st: Maturity, 2nd: Annual Coupon, 3rd: Price.
% Ask the user to fix the file content if he's truly wrong.

if mean(csv_cp(:,1)) > 70 || mean(csv_cp(:,2)) > 20 || mean(csv_cp(:,3)) < 50
    disp("Please note that providing bond's data in any order different from")
    disp("the required order (1st column: Maturity, 2nd column: Price) will")
    disp("result in WRONG computation.")
    order.anoth2 = tr_yesorno("Are you sure your file contents are" +...
        "provided in the required order?");
    if isequal(order.anoth2,'N') || isequal(order.anoth2,'N')
        disp("Please modify your second .csv file as required and")
        disp("restart the program again.")
        tr_ciao
    else
        disp("No worries, just asking to make sure before doing any")
        disp("computations")
        disp('---------------')
    end
else
end

%% (STEP 6) 
% Compute the zero rates then display together with the maturities.
% ONLY compute the zero rates for maturities with these requirements:
% - divisible for 0.5 (since according to our assumption, these
% coupon-bearing bonds are semi-annual bonds and their nearest payment
% is after 0.5 years).
% - larger than maturities of zero rates we got from Step 3. (no point in
% computing shorter maturities)
% - computable from Step 3 and the second .csv file from the user.
% (For ex: 0.5y, 1y zero from Step 3; coupon-bear with shortest maturity is
% at 2y => Computable Zero Rate: 0.5y, 1y)

% EXCLUDE all data that do not meet the requirement 1 & 2:
disp("[STEP 6]")
disp("... Just a few IMPORTANT notes for you, my dear " + user_name +"...")
disp('---------------')
disp("I'll only accept data of coupon-bearing bonds with maturities that are:")
disp("1. MULTIPLES OF 0.5.")
disp("2. LONGER than maturities of the zero rates that are multiples of 0.5")
disp("we got from the first .csv file.")
disp('---------------')
disp("Thus, any bonds with maturies that do not meet these two requirements")
disp("will be deemed as 'USELESS' data and EXCLUDED from our computations.")
disp('---------------')

% Also EXCLUDE all zero rates with maturities that aren't multiples of 0.5 from
% Step 3. Put them together with their corresponding rates in the second column.
% I'm doing this since these zero rates won't be used in bootstraping
% method. It would be more simple to do a for-loop later without them.
zero_maturity_no  = [csv_zero(:,1),zero];
excl_countz = 0;
for i = 1:sizecsv(1)
    if mod(zero_maturity_no(i,1),0.5) ~= 0 % for-loop to check
        zero_maturity_no(i,1) = 0; % turn any element non-divisible for 0.5 to 0s
        excl_countz = excl_countz + 1; % how many rows we're going to remove later
    end
end
zero_maturity_no = sortrows(zero_maturity_no); % sort maturities so all 0s go to top

try % try-catch to avoid the case of no need to exclude anything (excl_countz = 0)
    zero_maturity_no(1:excl_countz,:) = []; % remove all 0s (representing maturities not divisble by 0.5)
catch
end

% Choosing coupon bonds with maturities meet requirement 1 & 2
sizecsvcp = size(csv_cp);
excl_count = 0;
for i = 1:sizecsvcp(1)
    if csv_cp(i,1) <= max(zero_maturity_no(:,1)) || mod(csv_cp(i,1),0.5) ~= 0
        csv_cp(i,1) = 0;
        excl_count = excl_count + 1;
    end
end
csv_cp = sortrows(csv_cp); % sort maturities so all 0s go to top
try % try-catch to avoid the case of no need to exclude anything (excl_count = 0)
    csv_cp(1:excl_count,:) = []; % remove all 0s (representing maturities not
    % meet first two requirements)
catch
end

%% 
% Find out the longest maturities of zero rates can be computed from
% available data (Step 3 & Second .csv file)

% - First, find out the longest maturities of zero rates can be computed from
% using ONLY the zero rates from Step 3 (only maturities as multiples of
% 0.5 of course). Longest maturities - 'max_maturity'

sizezm = size(zero_maturity_no);
if zero_maturity_no(1,1) == 0.5 % check if the first element is 0.5 or not
    for i = 1:(sizezm(1)-1) % loop to check for 0.5, 1, 1.5, 2,... (must in streak)
        if zero_maturity_no(i+1,1) - zero_maturity_no(i,1) == 0.5
            max_maturity = zero_maturity_no(i+1,1) + 0.5;
        else
            break % break the loop right when the streak stop)
        end
    end
end

% From the matrix of bonds that meet the 1st & 2nd requirements (filtered
% above), we can compute the longest maturities of zero rates can be computed
% from both Step 3 & Second .csv file ('max_maturity')

for i = 1:(sizecsvcp-1)
    if max_maturity == csv_cp(i,1) && (csv_cp(i+1,1) - csv_cp(i,1)) == 0.5
        max_maturity = csv_cp(i+1,1);
    elseif max_maturity < csv_cp(i,1)
        break
    else % max_maturity == csv_cp(i,1) & (csv_cp(i+1,1) - csv_cp(i,1)) > 0.5
        break
    end
end

if max_maturity == 0 || max_maturity < csv_cp(1,1)
    disp("Unfortunately! Data from both provided .csv files is not enough")
    disp("for me to compute any zero rates with longer maturities than")
    disp("the rates calculated before.")
    zero_matu_final = [csv_zero(:,1), zero*100];
else
    excl_count3 = 0;
    sizecsvcp = size(csv_cp);
    for i = 1:sizecsvcp(1) % exclude all bonds with maturies > max_maturity (unusable data)
        if csv_cp(i,1) > max_maturity
            excl_count3 = excl_count3 + 1;
        end
    end
    csv_cp(sizecsvcp(1)-excl_count3+1:sizecsvcp(1),:) =[];
    
    sizecsvcp = size(csv_cp); % recompute size of csv_cp for a new loop
    totalcoupon = [];
    new_zero = 0;
    for i = 1:sizecsvcp(1) %calculate PV of past coupons.
        %(Price - Total Past coupons)/(Par + Last coupon)=exp(-zero(t) * t)
        totalcoupon(i,1) = (csv_cp(i,2)/2) * sum(exp(-zero_maturity_no(:,1) .* zero_maturity_no(:,2)));
        sizezm = size(zero_maturity_no);
        zero_maturity_no(sizezm(1)+1,1) =  csv_cp(i,1);
        zero_maturity_no(sizezm(1)+1,2) = -log(((csv_cp(i,3)-...
            totalcoupon(i,1))/(100+...
            csv_cp(i,2)/2)))/csv_cp(i,1);
        new_zero = new_zero + 1;
    end
end

zero_matu_final = [csv_zero(:,1), zero ; zero_maturity_no(sizezm(1)-new_zero+2:sizezm(1)+1,:)];
disp("With the new data from the second .csv file, in addition to the")
disp("rates calculated before, we can compute as below:")
for i = (sizezm(1)-new_zero+2):(sizezm(1)+1)
    disp("* " + num2str(zero_maturity_no(i,1)) + "-year zero rate: " + ...
        num2str(num2str(100*zero_maturity_no(i,2))) + "%.")
end

%% (STEP 7) Display the zero rates together with the maturities.

zero_matu_table = table(zero_matu_final(:,1), strcat(num2str(100*...
                  zero_matu_final(:,2)),"%"),'VariableNames',{'Maturity', 'ZeroRate'});
disp("[STEP 7]")
disp("Computed from data of 2 .csv files, the zero rates can be summarized")
disp("in the table below (From short to long maturities):")
disp('---------------')
disp(zero_matu_table)
disp('---------------')
% Ask if user wants to write the matrix to .xlsx or not?
excel_ask = tr_yesorno("Do you want to write the above table to a " + ... 
    ".xlsx file?\n\>> ");
if excel_ask == 'Y' || excel_ask == 'y'
    xlsxname = "output_files/" + ... 
        input("How do you want to name your file?\n\>> ",'s');
    writetable(zero_matu_table, xlsxname + ".xlsx") % write the table to .xlsx
    % Ask if he wants to open?
    open_ask = tr_yesorno("Do you want to open the file now?\n\>> ");
    if open_ask == 'Y' || open_ask == 'y'
        open(xlsxname + ".xlsx");
    else
        disp("Let's move on.")
    end
else
    disp("No worries. Let's move on.")
end

%% (STEP 8) 
% Draw a graph of the zero rates as a function of time to maturity

% Ask the user if he wants to draw the graph or not?
disp("[STEP 8]")
prompt_draw2 = "Do you want to draw a graph of the zero rates as a " +...
    "function of time to maturity?\n\(Including all the " +...
    "computed zero rates)\n\>> ";
draw2 = tr_yesorno(prompt_draw2);
if isequal(draw2,'Y') || isequal(draw2,'y')
    disp("Here's your graph!")
    disp('---------------')
    plot(zero_matu_final(:,1),zero_matu_final(:,2)*100)
    xlabel('Maturity (years)') % X-axis label
    ylabel('Zero Rate (%)') % Y-axis label
    title({'Graph: Relation between Zero Rates and Maturities (Full)',''})
    saveas(gcf, 'output_files/zero rates - maturities.pdf')
    disp("I have also save it as a PDF file for you (in the Current Folder).")
    open_ask = tr_yesorno("Do you want to open the PDF file now?\n\>> ");
    if open_ask == 'Y' || open_ask == 'y'
        open('output_files/Zero Rates - Maturities.pdf')
    else
        disp("Thank you for using my program!")
        tr_ciao
    end
else
    disp("Thank you for using my program!")
    tr_ciao
end


%% Define useful functions
function yn = tr_yesorno(prompt)
% Ask user to input 'only 'Y' or 'N' or 'y' or 'n'
yn = input(prompt,'s');
while isequal(yn,'Y') + isequal(yn,'y') + isequal(yn,'N') + isequal(yn,'n') == 0
    disp('ONLY enter Y or N.')
    disp('Enter your answer again.')
    disp('---------------')
    yn = input(prompt,'s');
end
disp('---------------')
end

function zr = tr_zerorate(tmt, price, par)
% Compute the zero rate (annual base, continuously compounded) of a 
% zero-coupon bond using three arguments: 
    % tmt: Time to maturity (in years), 
    % price: Price of the bond,
    % par: Face value of the bond. 
zr = (log(par./price))./tmt;
end

function csv_file = tr_readmatrix(prompt)
% Ask user to enter a .csv file name. Check it existence.
% - If file can be found, transform it into a matrix.
% - If file cannot be found, inform the user to enter the filename again.
filename = "input_files/" + input(prompt,'s');
disp('---------------')
csv_notfound = 1;
while isequal(csv_notfound, 1)
    try
        csv_file = readmatrix(filename);
        csv_notfound = 0;
    catch
        csv_notfound = 1;
        disp("I cannot find the file specified.")
        disp("Please re-type.")
        disp('---------------')
        filename = input(prompt, 's');
    end
end
end

function nn = tr_nonan(A)
%% Check if there is any missing value (NaN) in an array
nn = ~logical(sum(isnan(A),'all'));
end

function format = tr_checkmat(matrix, colnum)
%% 
% Check if the matrix read from the .csv file provided by the user is
% in the required format or not?
s = size(matrix);
format = isequal(s(2), colnum) & tr_nonan(matrix);
% If the csv file is in the WRONG format (use ',' as decimal separator, wrong
% number of info provided, strings instead of numbers, etc.) , after being
% transformed to a matrix, the number of columns will be different from our
% request or it can contain NaN or BOTH.

% If it is in the RIGHT format, BOTH of the logical tests above must be true.
end

function tr_ciao
%% End the program
disp("Have a great day! Goodbye.")
disp('---------------')
keyboard %  put user in debug mode to terminate the script
end