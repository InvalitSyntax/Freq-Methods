%% 1. Параметры
a = 4; b = 2; t0 = 1; t1 = 2; t2 = 3;
T = t2 - t0;
N_values = [1, 3, 5, 10, 50];

% Сетка времени (3 периода)
t_plot = linspace(t0, t0 + 3*T, 3000);

% Описание исходной функции
f_handle = @(t) a .* (mod(t-t0, T) < (t1-t0)) + b .* (mod(t-t0, T) >= (t1-t0));
f_orig = f_handle(t_plot);

%% 2. Цикл построения для разных N
for N = N_values
    % Шаг А: Считаем коэффициенты (твоя первая функция)
    [an, bn, cn, nn] = calc_fourier(f_handle, t0, T, N);
    
    % Шаг Б: Собираем сигналы FN и GN
    [FN, GN] = reconstruct_fourier(an, bn, cn, nn, T, t_plot);
    
    % Шаг В: Рисуем и сохраняем
    fname = sprintf('img/fourier_plot_N%d.pdf', N);
    plot_fourier_approx(t_plot, f_orig, FN, GN, N, fname);
    
    fprintf('График для N=%d готов.\n', N);
end