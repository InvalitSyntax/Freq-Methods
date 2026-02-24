function plot_periodic_signal(t, f, legend_text, filename, y_limits)
    % plot_periodic_signal - Универсальная функция для отрисовки сигналов в стиле отчета
    % t - вектор времени
    % f - вектор значений функции
    % legend_text - текст для легенды
    % filename - имя PDF файла для сохранения
    % y_limits - [min max] для оси Y
    
    % 1. Глобальные настройки шрифтов
    set(0, 'DefaultAxesFontName', 'Times New Roman');
    set(0, 'DefaultTextFontName', 'Times New Roman');

    % 2. Создание окна
    fig = figure('Units', 'pixels', 'Position', [100, 100, 800, 500], 'Visible', 'on');
    ax = axes('Parent', fig);

    % 3. Отрисовка
    plot(t, f, 'LineWidth', 2.5, 'Color', [0 0.4470 0.7410]);
    grid on;
    hold on;

    % 4. Настройка осей и отступов
    % [отступ_слева, отступ_снизу, ширина, высота]
    set(ax, 'Position', [0.15, 0.28, 0.75, 0.65]); 
    
    xlabel('t', 'FontSize', 14);
    ylabel('f(t)', 'FontSize', 14);
    
    xlim([min(t), max(t)]);
    if nargin > 4
        ylim(y_limits);
    end

    % 5. Легенда (вне графика, прижата влево)
    lgd = legend(legend_text, 'FontSize', 14);
    set(lgd, 'Location', 'none');    
    set(lgd, 'Units', 'normalized'); 
    drawnow; % Важно для расчета позиций
    
    ax_pos = ax.Position;
    lgd_pos = lgd.Position;
    
    % Ставим легенду под левый край графика
    lgd.Position = [ax_pos(1), 0.08, lgd_pos(3), lgd_pos(4)];

    % 6. Сохранение
    exportgraphics(fig, filename, 'ContentType', 'vector', 'BackgroundColor', 'none');
    
    fprintf('График сохранен в файл: %s\n', filename);
end