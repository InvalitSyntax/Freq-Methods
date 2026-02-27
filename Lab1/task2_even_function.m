%% 1. Параметры функции
T = 2;          % Период
t0 = -1;        % Начало интервала (центрируем для чётности)
N_values = [1, 2, 3, 5, 20]; % Разные N для анализа

% Описываем периодическую параболу
% mod(t+1, 2) - 1 переводит любое t в диапазон [-1, 1]
f_handle = @(t) (mod(t + 1, 2) - 1).^2;

%% 2. Отрисовка оригинала
t_plot = linspace(-3, 3, 3000); % Рисуем 3 периода (от -3 до 3)
f_orig = f_handle(t_plot);
plot_periodic_signal(t_plot, f_orig, 'f(t) = t^2 (Чётная)', 'img/even_orig.pdf', [-0.2, 1.2]);

%% 3. Расчет коэффициентов (для N=2)
[an, bn, cn, nn] = calc_fourier(f_handle, t0, T, 2);
print_fourier_results(an, bn, cn, nn, 2);

%% 4. Построение аппроксимаций (цикл по N)
y_lims = [-0.2, 1.2];

for N = N_values
    [an, bn, cn, nn] = calc_fourier(f_handle, t0, T, N);
    [FN, GN] = reconstruct_fourier(an, bn, cn, nn, T, t_plot);
    
    fname = sprintf('img/even_plot_N%d.pdf', N);
    
    % Передаем y_lims последним аргументом
    plot_fourier_approx(t_plot, f_orig, FN, GN, N, fname, y_lims);
end

%% 5. Проверка равенства Парсеваля (для N=20)
[an, bn, cn, nn] = calc_fourier(f_handle, t0, T, 20);
verify_parseval(an, bn, cn, f_handle, t0, T, 20);