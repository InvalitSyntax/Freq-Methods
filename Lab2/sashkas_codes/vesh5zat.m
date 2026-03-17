% Параметры сигналов: три набора (a, b) > 0
params = [1, 1; 2, 1; 1, 3];

% Диапазон времени t
t_min = -5;
t_max = 5;
N_t = 1000;
t = linspace(t_min, t_max, N_t);

% Диапазон частоты omega
w_min = -8;
w_max = 8;
N_w = 1000;
w = linspace(w_min, w_max, N_w);

% Приглушённые цвета: красный, оранжевый, зелёный
colors = {[0.8 0.2 0.2], [0.9 0.6 0.1], [0.2 0.7 0.2]};
styles = {'-', '--', ':'};
lineWidth = 1.8;

% Устанавливаем интерпретатор LaTeX для текста
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% ===== Фигура 1: Временная область f(t) = a * exp(-b|t|) =====
figure('Name', 'Экспоненциальные импульсы', 'NumberTitle', 'off');
hold on; grid on;

for i = 1:size(params, 1)
    a = params(i, 1);
    b = params(i, 2);
    
    % Вычисление f(t) = a * exp(-b * |t|)
    f_t = a * exp(-b * abs(t));
    
    plot(t, f_t, ...
        'Color', colors{i}, ...
        'LineStyle', styles{i}, ...
        'LineWidth', lineWidth, ...
        'DisplayName', sprintf('$f(t)=a e^{-b|t|}$, $a=%d$, $b=%d$', a, b));
end

xlabel('$t$', 'FontSize', 12);
ylabel('$f(t)$', 'FontSize', 12);
lgd = legend('Location', 'best', 'Interpreter', 'latex');
lgd.FontSize = 14;
xlim([t_min, t_max]);
ylim([0, max(params(:,1))*1.1]);

% ===== Фигура 2: Частотная область \hat{f}(\omega) (унитарное ПФ) =====
figure('Name', 'Спектры экспоненциальных импульсов', 'NumberTitle', 'off');
hold on; grid on;

for i = 1:size(params, 1)
    a = params(i, 1);
    b = params(i, 2);
    
    % Спектр: \hat{f}(\omega) = (2ab)/sqrt(2pi) * 1/(b^2 + w^2)
    F_w = (2*a*b)/sqrt(2*pi) * 1./(b^2 + w.^2);
    
    plot(w, F_w, ...
        'Color', colors{i}, ...
        'LineStyle', styles{i}, ...
        'LineWidth', lineWidth, ...
        'DisplayName', sprintf('$\\hat{f}(\\omega)=\\frac{2ab}{\\sqrt{2\\pi}}\\frac{1}{b^2+\\omega^2}$, $a=%d$, $b=%d$', a, b));
end

xlabel('$\omega$', 'FontSize', 12);
ylabel('$\hat{f}(\omega)$', 'FontSize', 12);
lgd = legend('Location', 'best', 'Interpreter', 'latex');
lgd.FontSize = 14;
xlim([w_min, w_max]);
ylim([0, max(2*params(:,1).*params(:,2)./sqrt(2*pi)./min(params(:,2))^2)*1.1]);

% Возвращаем стандартный интерпретатор (опционально)
set(groot, 'defaultTextInterpreter', 'tex');