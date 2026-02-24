function plot_fourier_approx(t, f_orig, FN, GN, N, filename, y_limits)
    % plot_fourier_approx - Отрисовка сравнения оригинала и аппроксимаций
    
    set(0, 'DefaultAxesFontName', 'Times New Roman');
    set(0, 'DefaultTextFontName', 'Times New Roman');

    fig = figure('Units', 'pixels', 'Position', [100, 100, 800, 500], 'Visible', 'off');
    ax = axes('Parent', fig);
    
    % Отрисовка трех линий
    plot(t, f_orig, '--', 'LineWidth', 1.5, 'Color', [0.6 0.6 0.6]); hold on;
    plot(t, FN, 'LineWidth', 2, 'Color', [0 0.4470 0.7410]); 
    plot(t, GN, ':', 'LineWidth', 3, 'Color', [0.8500 0.3250 0.0980]); 
    
    grid on;
    xlabel('t', 'FontSize', 14);
    ylabel('f(t)', 'FontSize', 14);

    % --- УСТАНОВКА ЛИМИТОВ (если переданы) ---
    if nargin > 6 && ~isempty(y_limits)
        ylim(y_limits);
    end
    xlim([min(t), max(t)]);
    
    % Настройка легенды под графиком слева
    set(ax, 'Position', [0.12, 0.25, 0.83, 0.70]); 
    lgd = legend('f(t) Исходная', sprintf('F_{%d}(t) Триг.', N), ...
                 sprintf('G_{%d}(t) Компл.', N), 'FontSize', 12);
    set(lgd, 'Location', 'none', 'Units', 'normalized');
    drawnow;
    lgd.Position = [ax.Position(1), 0.05, lgd.Position(3), lgd.Position(4)];
    
    % Экспорт
    exportgraphics(fig, filename, 'ContentType', 'vector', 'BackgroundColor', 'none');
    close(fig);
end