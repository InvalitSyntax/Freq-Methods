function plot_periodic_signal(t, f, legend_text, filename, y_limits)
    set(0, 'DefaultAxesFontName', 'Times New Roman');
    set(0, 'DefaultTextFontName', 'Times New Roman');

    fig = figure('Units', 'pixels', 'Position', [100, 100, 800, 500], 'Visible', 'on');
    ax = axes('Parent', fig);

    plot(t, f, 'LineWidth', 2.5, 'Color', [0 0.4470 0.7410]);
    grid on;
    hold on;

    set(ax, 'Position', [0.15, 0.28, 0.75, 0.65]); 
    
    xlabel('t', 'FontSize', 14);
    ylabel('f(t)', 'FontSize', 14);
    
    xlim([min(t), max(t)]);
    if nargin > 4
        ylim(y_limits);
    end

    lgd = legend(legend_text, 'FontSize', 14);
    set(lgd, 'Location', 'none');    
    set(lgd, 'Units', 'normalized'); 
    drawnow;
    
    ax_pos = ax.Position;
    lgd_pos = lgd.Position;
    
    lgd.Position = [ax_pos(1), 0.08, lgd_pos(3), lgd_pos(4)];

    exportgraphics(fig, filename, 'ContentType', 'vector', 'BackgroundColor', 'none');
    
    fprintf('График сохранен в файл: %s\n', filename);
end