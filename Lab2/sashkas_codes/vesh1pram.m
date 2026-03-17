% Параметры сигналов: три набора (a, b)
params = [1, 1; 1, 4; 2, 5];

% Диапазон времени t (для отображения импульсов)
t_min = -10;
t_max = 10;
N_t = 1000;
t = linspace(t_min, t_max, N_t);

% Диапазон частоты omega (для отображения спектра)
w_min = -10;
w_max = 10;
N_w = 1000;
w = linspace(w_min, w_max, N_w);

% Более приглушённые цвета: красный, оранжевый, зелёный
colors = {[0.8 0.2 0.2], [0.9 0.6 0.1], [0.2 0.7 0.2]};
styles = {'-', '--', ':'};
lineWidth = 1.8;

% ===== Фигура 1: Временная область f(t) =====
figure('Name', 'Исходный сигнал во временной области', 'NumberTitle', 'off');
hold on; grid on;

for i = 1:size(params, 1)
    a = params(i, 1);
    b = params(i, 2);
    
    % Вычисление f(t) = a при |t| <= b, иначе 0
    f_t = a * (abs(t) <= b);
    
    plot(t, f_t, ...
        'Color', colors{i}, ...
        'LineStyle', styles{i}, ...
        'LineWidth', lineWidth, ...
        'DisplayName', sprintf('a = %d, b = %d', a, b));
end

xlabel('t', 'FontSize', 12);
ylabel('f(t)', 'FontSize', 12);
legend('Location', 'best');
xlim([t_min, t_max]);
ylim([-0.2, 3.5]);

% ===== Фигура 2: Частотная область \hat{f}(\omega) =====
figure('Name', 'Спектральная плотность', 'NumberTitle', 'off');
hold on; grid on;

for i = 1:size(params, 1)
    a = params(i, 1);
    b = params(i, 2);
    
    % Спектр: \hat{f}(\omega) = a * sqrt(2/pi) * sin(omega*b) / omega,
    % при omega = 0 предел равен a * sqrt(2/pi) * b.
    F_w = zeros(size(w));
    for j = 1:length(w)
        if abs(w(j)) < 1e-12
            F_w(j) = a * sqrt(2/pi) * b;
        else
            F_w(j) = a * sqrt(2/pi) * sin(w(j) * b) / w(j);
        end
    end
    
    % Формируем подпись с текущими a и b, используя LaTeX для красивого отображения
    legend_str = sprintf('$\\hat{f}(\\omega),\\ a=%d,\\ b=%d$', a, b);
    plot(w, F_w, ...
        'Color', colors{i}, ...
        'LineStyle', styles{i}, ...
        'LineWidth', lineWidth, ...
        'DisplayName', legend_str);
end

xlabel('\omega', 'FontSize', 12);
ylabel('$$\hat{f}(\omega)$$', 'FontSize', 12, 'Interpreter', 'latex');
legend('Location', 'best', 'Interpreter', 'latex');
xlim([w_min, w_max]);