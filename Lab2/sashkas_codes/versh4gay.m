% Параметры сигналов: три набора (a, b) > 0
params = [1, 1; 3, 1; 1, 2];

% Диапазон времени t (для отображения гауссиан)
t_min = -5;
t_max = 5;
N_t = 1000;
t = linspace(t_min, t_max, N_t);

% Диапазон частоты omega (для отображения спектра)
w_min = -8;
w_max = 8;
N_w = 1000;
w = linspace(w_min, w_max, N_w);

% Приглушённые цвета: красный, оранжевый, зелёный
colors = {[0.8 0.2 0.2], [0.9 0.6 0.1], [0.2 0.7 0.2]};
styles = {'-', '--', ':'};
lineWidth = 1.8;

% Устанавливаем интерпретатор LaTeX для всех текстовых объектов
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% ===== Фигура 1: Временная область f(t) = a * exp(-b*t^2) =====
figure('Name', 'Гауссовы импульсы', 'NumberTitle', 'off');
hold on; grid on;

for i = 1:size(params, 1)
    a = params(i, 1);
    b = params(i, 2);
    
    % Вычисление f(t)
    f_t = a * exp(-b * t.^2);
    
    plot(t, f_t, ...
        'Color', colors{i}, ...
        'LineStyle', styles{i}, ...
        'LineWidth', lineWidth, ...
        'DisplayName', sprintf('$f(t)=a e^{-b t^2}$, $a=%d$, $b=%d$', a, b));
end

xlabel('$t$', 'FontSize', 12);
ylabel('$f(t)$', 'FontSize', 12);
legend('Location', 'best');
xlim([t_min, t_max]);
ylim([-0.1, max(params(:,1))+0.1]);

% ===== Фигура 2: Частотная область \hat{f}(\omega) = a * sqrt(pi/b) * exp(-omega^2/(4b)) =====
figure('Name', 'Спектры гауссовых импульсов', 'NumberTitle', 'off');
hold on; grid on;

for i = 1:size(params, 1)
    a = params(i, 1);
    b = params(i, 2);
    
    % Спектр (классическое преобразование Фурье)
    F_w = a * sqrt(pi/b) * exp(-w.^2 / (4*b));
    
    plot(w, F_w, ...
        'Color', colors{i}, ...
        'LineStyle', styles{i}, ...
        'LineWidth', lineWidth, ...
        'DisplayName', sprintf('$\\hat{f}(\\omega)=a\\sqrt{\\pi/b}\\,e^{-\\omega^2/(4b)}$, $a=%d$, $b=%d$', a, b));
end

xlabel('$\omega$', 'FontSize', 12);
ylabel('$\hat{f}(\omega)$', 'FontSize', 12);
legend('Location', 'best');
xlim([w_min, w_max]);
ylim([0, max(params(:,1))*sqrt(pi./params(:,2))*1.1]);

% Возвращаем стандартный интерпретатор (опционально)
set(groot, 'defaultTextInterpreter', 'tex');