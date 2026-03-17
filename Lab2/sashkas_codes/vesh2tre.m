
params = [1, 1; 2, 1; 1, 3];

t_min = -3;
t_max = 3;
N_t = 1000;
t = linspace(t_min, t_max, N_t);

w_min = -15;
w_max = 15;
N_w = 2000;
w = linspace(w_min, w_max, N_w);

colors = {[0.8 0.2 0.2], [0.9 0.6 0.1], [0.2 0.7 0.2]};
styles = {'-', '--', ':'};
lineWidth = 1.8;

set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% ================= Фигура 1: Оригинал =================
figure('Name', 'Треугольные импульсы', 'NumberTitle', 'off');
hold on; grid on;

for i = 1:size(params, 1)
    a = params(i, 1);
    b = params(i, 2);
    
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
ylim([-0.2, max(params(:,1)) + 0.2]);

% ================= Фигура 2: Спектры (Унитарные) =================
figure('Name', 'Спектры треугольных импульсов', 'NumberTitle', 'off');
hold on; grid on;

max_F_w = 0;

for i = 1:size(params, 1)
    a = params(i, 1);
    b = params(i, 2);
    
    F_w = zeros(size(w));
    for j = 1:length(w)
        if abs(w(j)) < 1e-12
            % Значение в нуле с учетом 1/sqrt(2*pi)
            F_w(j) = (a * b) / sqrt(2*pi);         
        else
            % Расчет с учетом 1/sqrt(2*pi)
            F_w(j) = (1/sqrt(2*pi)) * (4*a)/(b * w(j)^2) * (sin(w(j)*b/2))^2;
        end
    end
    
    max_F_w = max(max_F_w, max(F_w));
    
    % Лаконичная легенда, как было раньше
    plot(w, F_w, ...
        'Color', colors{i}, ...
        'LineStyle', styles{i}, ...
        'LineWidth', lineWidth, ...
        'DisplayName', sprintf('$\\hat{f}(\\omega),\\ a=%d,\\ b=%d$', a, b));
end

xlabel('$\omega$', 'FontSize', 12);
ylabel('$\hat{f}(\omega)$', 'FontSize', 12);

xlim([w_min, w_max]);
% Небольшой запас сверху, чтобы графики не наезжали на легенду
ylim([-0.05, max_F_w + 0.25]); 
legend('Location', 'northeast');

set(groot, 'defaultTextInterpreter', 'tex');