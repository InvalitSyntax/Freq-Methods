% Настройки шрифтов
set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultTextFontName', 'Times New Roman');

% 1. Параметры функции
a = 4; b = 2; t0 = 1; t1 = 2; t2 = 3;
T = t2 - t0;
w0 = 2 * pi / T;

% Описываем функцию (handle)
f_handle = @(t) a .* (mod(t-t0, T) < (t1-t0)) + b .* (mod(t-t0, T) >= (t1-t0));

% 2. Значения N для построения
N_values = [1, 3, 5, 10, 50];

% Временная сетка для 3-х периодов
t_plot = linspace(t0, t0 + 3*T, 3000);
f_orig = f_handle(t_plot);

for N = N_values
    % --- ШАГ 1: ВЫЗОВ ТВОЕЙ ФУНКЦИИ ---
    [an, bn, cn, nn] = calc_fourier(f_handle, t0, T, N);
    
    % --- ШАГ 2: СБОРКА FN (тригонометрическая форма) ---
    FN = an(1)/2 * ones(size(t_plot));
    for n = 1:N
        FN = FN + an(n+1)*cos(n*w0*t_plot) + bn(n+1)*sin(n*w0*t_plot);
    end
    
    % --- ШАГ 3: СБОРКА GN (комплексная форма) ---
    GN = zeros(size(t_plot));
    for i = 1:length(nn)
        GN = GN + cn(i)*exp(1i*nn(i)*w0*t_plot);
    end
    GN = real(GN); 
    
    % --- ШАГ 4: ВИЗУАЛИЗАЦИЯ ---
    fig = figure('Units', 'pixels', 'Position', [100, 100, 800, 500]);
    ax = axes('Parent', fig);
    
    % Отрисовка
    plot(t_plot, f_orig, '--', 'LineWidth', 1.5, 'Color', [0.6 0.6 0.6]); hold on;
    plot(t_plot, FN, 'LineWidth', 2, 'Color', [0 0.4470 0.7410]); 
    plot(t_plot, GN, ':', 'LineWidth', 3, 'Color', [0.8500 0.3250 0.0980]); 
    
    grid on;
    xlabel('t', 'FontSize', 14);
    ylabel('f(t)', 'FontSize', 14);
    
    % Настройка легенды (внизу слева извне)
    % Сдвигаем оси чуть выше, чтобы освободить место снизу
    set(ax, 'Position', [0.12, 0.25, 0.83, 0.70]); 
    
    lgd = legend('f(t) Исходная', ['F_{', num2str(N), '}(t) Триг.'], ...
                 ['G_{', num2str(N), '}(t) Компл.'], 'FontSize', 12);
    set(lgd, 'Location', 'none', 'Units', 'normalized');
    drawnow;
    
    % Прижимаем легенду к левому краю графика в самом низу окна
    lgd.Position = [ax.Position(1), 0.05, lgd.Position(3), lgd.Position(4)];
    
    % Сохранение в PDF
    filename = sprintf('fourier_plot_N%d.pdf', N);
    exportgraphics(fig, filename, 'ContentType', 'vector', 'BackgroundColor', 'none');
    
    fprintf('График для N=%d сохранен в %s\n', N, filename);
    close(fig); 
end