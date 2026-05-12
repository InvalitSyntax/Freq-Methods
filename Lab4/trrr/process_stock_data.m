function process_stock_data(T_val, period_label)
    if ~exist('img', 'dir'), mkdir('img'); end
    
    set(0, 'DefaultAxesFontName', 'Arial');
    set(0, 'DefaultTextFontName', 'Arial');

    opts = detectImportOptions('SBER_211212_260413.csv');
    opts.VariableNamingRule = 'preserve'; 
    data = readtable('SBER_211212_260413.csv', opts);
    
    DT = datetime(string(data.("<DATE>")), 'InputFormat', 'yyyyMMdd');
    prices = data.("<CLOSE>");
    
    n = length(prices);
    t = (0:n-1)'; 

    A = -1/T_val;
    B = 1/T_val;
    C = 1;
    D = 0;
    sys = ss(A, B, C, D);
    
    x0 = prices(1); 
    y_filt = lsim(sys, prices, t, x0);

    f_full = figure('Position', [100, 100, 1100, 600], 'Visible', 'off');
    plot(DT, prices, 'Color', '#0072BD', 'LineWidth', 1.5); hold on; grid on;
    plot(DT, y_filt, 'r', 'LineWidth', 2.0);
    ylabel('Цена (руб.)', 'FontSize', 14);
    xlabel('Дата', 'FontSize', 14);
    xtickformat('MM-yyyy');
    legend('Исходные котировки', ['Тренд T = ' period_label], 'Location', 'southoutside', 'Orientation', 'horizontal', 'FontSize', 12);
    exportgraphics(f_full, ['img/stock_full_' period_label '.pdf'], 'ContentType', 'vector');

    f_zoom = figure('Position', [100, 100, 1100, 600], 'Visible', 'off');
    
    if T_val <= 5
        show_range = 30;
    else
        show_range = round(2 * T_val);
    end
    
    idx = (n - show_range + 1):n; 
    
    plot(DT(idx), prices(idx), 'Color', '#0072BD', 'LineWidth', 1.5); hold on; grid on;
    plot(DT(idx), y_filt(idx), 'r', 'LineWidth', 2.5);
    
    ylabel('Цена (руб.)', 'FontSize', 14);
    xlabel('Дата', 'FontSize', 14);
    
    if T_val > 60
        xtickformat('MM-yyyy');
    else
        xtickformat('dd-MM');
    end
    
    legend(['Данные за период соответствующий ' period_label], ...
           ['Тренд (T = ' period_label ')'], ...
           'Location', 'southoutside', 'Orientation', 'horizontal', 'FontSize', 12);
    
    exportgraphics(f_zoom, ['img/stock_zoom_' period_label '.pdf'], 'ContentType', 'vector');
end