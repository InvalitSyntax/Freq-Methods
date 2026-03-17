% Параметры сигналов: три набора (a, b)
params = [1, 1; 2, 1; 1, 3];

% Диапазон времени t (для отображения треугольных импульсов)
t_min = -3;
t_max = 3;
N_t = 1000;
t = linspace(t_min, t_max, N_t);

% Диапазон частоты omega (для отображения спектра)
w_min = -15;
w_max = 15;
N_w = 2000;
w = linspace(w_min, w_max, N_w);

% Приглушённые цвета: красный, оранжевый, зелёный
colors = {[0.8 0.2 0.2], [0.9 0.6 0.1], [0.2 0.7 0.2]};
styles = {'-', '--', ':'};
lineWidth = 1.8;

% Устанавливаем интерпретатор LaTeX для всех текстовых объектов текущей сессии
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% ===== Фигура 1: Временная область f(t) =====
figure('Name', 'Треугольные импульсы', 'NumberTitle', 'off');
hold on; grid on;

for i = 1:size(params, 1)
    a = params(i, 1);
    b = params(i, 2);
    
    % Треугольный импульс: f(t) = a*(1 - |t|/b) при |t| <= b, иначе 0
    f_t = a * (1 - abs(t)/b) .* (abs(t) <= b);
    
    plot(t, f_t, ...
        'Color', colors{i}, ...
        'LineStyle', styles{i}, ...
        'LineWidth', lineWidth, ...
        'DisplayName', sprintf('$f(t),\\ a=%d,\\ b=%d$', a, b));
end

xlabel('$t$', 'FontSize', 12);
ylabel('$f(t)$', 'FontSize', 12);
legend('Location', 'best');
xlim([t_min, t_max]);
ylim([-0.2, max(params(:,1))+0.2]);

% ===== Фигура 2: Частотная область \hat{f}(\omega) =====
figure('Name', 'Спектры треугольных импульсов', 'NumberTitle', 'off');
hold on; grid on;

for i = 1:size(params, 1)
    a = params(i, 1);
    b = params(i, 2);
    
    % Спектр: \hat{f}(\omega) = (4*a)/(b*\omega^2) * sin^2(\omega*b/2)
    % При \omega = 0 предел равен a*b
    F_w = zeros(size(w));
    for j = 1:length(w)
        if abs(w(j)) < 1e-12
            F_w(j) = a * b;          % значение в нуле (площадь импульса)
        else
            F_w(j) = (4*a)/(b * w(j)^2) * (sin(w(j)*b/2))^2;
        end
    end
    
    plot(w, F_w, ...
        'Color', colors{i}, ...
        'LineStyle', styles{i}, ...
        'LineWidth', lineWidth, ...
        'DisplayName', sprintf('$\\hat{f}(\\omega),\\ a=%d,\\ b=%d$', a, b));
end

xlabel('$\omega$', 'FontSize', 12);
ylabel('$\hat{f}(\omega)$', 'FontSize', 12);
legend('Location', 'best');
xlim([w_min, w_max]);
% ylim auto - можно подобрать при необходимости

% Возвращаем стандартный интерпретатор (опционально)
set(groot, 'defaultTextInterpreter', 'tex');