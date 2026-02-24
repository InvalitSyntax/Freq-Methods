% 1. Глобальные настройки шрифтов (чтобы кириллица не превращалась в #)
set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultTextFontName', 'Times New Roman');

% 2. Параметры функции
a = 4;
b = 2;
t0 = 1;
t1 = 2;
t2 = 3;
T = t2 - t0; 

% 3. Данные для 3-х периодов
t_start = t0;
t_end = t0 + 3*T;
t = linspace(t_start, t_end, 3000); 
t_relative = mod(t - t0, T) + t0;

f = zeros(size(t));
for i = 1:length(t)
    if t_relative(i) < t1
        f(i) = a;
    else
        f(i) = b;
    end
end

% 4. Построение графика
fig = figure('Units', 'pixels', 'Position', [100, 100, 800, 500]); % Фиксированный размер
ax = axes('Parent', fig);

plot(t, f, 'LineWidth', 2.5, 'Color', [0 0.4470 0.7410]);
hold on;
grid on;

% 5. Настройка отступов (поднимаем график повыше, чтобы освободить место снизу)
% [отступ_слева, отступ_снизу, ширина, высота]
set(ax, 'Position', [0.15, 0.28, 0.75, 0.62]);

% 6. Подписи
xlabel('t', 'FontSize', 14, 'FontName', 'Times New Roman');
ylabel('f(t)', 'FontSize', 14, 'FontName', 'Times New Roman');

ylim([b - 1, a + 1]);
xlim([t_start, t_end]);

% 7. Легенда (вне графика, прижата влево)
lgd = legend('f(t) - Квадратная волна', 'FontSize', 14, 'FontName', 'Times New Roman');
set(lgd, 'Location', 'none');    % Отключаем стандартное прилипание
set(lgd, 'Units', 'normalized'); % Используем относительные координаты (0..1)
drawnow;                        % Просим MATLAB отрисовать всё, чтобы узнать размеры

ax_pos = ax.Position;           % Берем позицию основного графика
lgd_pos = lgd.Position;         % Берем текущие размеры самой легенды

% Устанавливаем позицию: 
% X = ax_pos(1) — прижимаем к левому краю графика
% Y = 0.05 — ставим в самый низ окна
lgd.Position = [ax_pos(1), 0.15, lgd_pos(3), lgd_pos(4)];

% 8. Сохранение в PDF
% 'ContentType', 'vector' — для четкости
% 'BackgroundColor', 'none' — прозрачный фон вокруг
exportgraphics(fig, 'square_wave.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');

disp('Готово! Файл square_wave.pdf сохранен с поддержкой кириллицы.');