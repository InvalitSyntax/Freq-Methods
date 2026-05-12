T_days = [1, 5, 21, 63, 252]; 
labels = {'1 день', '1 неделя', '1 месяц', '3 месяца', '1 год'};

for i = 1:length(T_days)
    process_stock_data(T_days(i), labels{i});
end