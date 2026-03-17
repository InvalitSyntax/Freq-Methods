% Параметры сигналов: три набора (a, b)
params = [1, 1; 2, 1; 1, 2];

% Диапазон времени t (для отображения sinc-импульсов)
t_min = -10;
t_max = 10;
N_t = 2000;
t = linspace(t_min, t_max, N_t);

% Диапазон частоты omega (для отображения спектра)
w_min = -3;
w_max = 3;
N_w = 1000;
w = linspace(w_min, w_max, N_w);

% Приглушённые цвета: красный, оранжевый, зелёный
colors = {[0.8 0.2 0.2], [0.9 0.6 0.1], [0.2 0.7 0.2]};
styles = {'-', '--', ':'};
lineWidth = 1.8;

% Устанавливаем интерпретатор LaTeX для всех текстовых объектов текущей сессии
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% ===== Фигура 1: Временная область f(t) = a * sinc(b t) = a * sin(b t)/(b t) =====
figure('Name', 'Sinc-импульсы', 'NumberTitle', 'off');
hold on; grid on;

for i = 1:size(params, 1)
    a = params(i, 1);
    b = params(i, 2);
    
    % Вычисление f(t) = a * sin(b*t) ./ (b*t) с обработкой t=0
    f_t = zeros(size(t));
    for j = 1:length(t)
        if abs(t(j)) < 1e-12
            f_t(j) = a;          % предел при t->0 равен a
        else
            f_t(j) = a * sin(b * t(j)) / (b * t(j));
        end
    end
    
    plot(t, f_t, ...
        'Color', colors{i}, ...
        'LineStyle', styles{i}, ...
        'LineWidth', lineWidth, ...
        'DisplayName', sprintf('$f(t)=a\\,\\mathrm{sinc}(b t),\\ a=%d,\\ b=%d$', a, b));
end

xlabel('$t$', 'FontSize', 12);
ylabel('$f(t)$', 'FontSize', 12);
legend('Location', 'best');
xlim([t_min, t_max]);
ylim([-0.5, max(params(:,1))+0.5]);

% ===== Фигура 2: Частотная область \hat{f}(\omega) (прямоугольный спектр) =====
figure('Name', 'Спектры sinc-импульсов', 'NumberTitle', 'off');
hold on; grid on;

for i = 1:size(params, 1)
    a = params(i, 1);
    b = params(i, 2);
    
    % Спектр: \hat{f}(\omega) = a*pi/b при |\omega| <= b, иначе 0
    F_w = zeros(size(w));
    F_w(abs(w) <= b) = a * pi / b;
    
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
ylim([0, max(params(:,1))*pi./params(:,2)*1.1]);

% Возвращаем стандартный интерпретатор (опционально)
set(groot, 'defaultTextInterpreter', 'tex');