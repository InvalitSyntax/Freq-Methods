%% 1. Параметры
T = 2;
t0 = 0;
N_values = [1, 5, 15, 50, 100]; 

f_handle = @(t) 2*mod(t, 2) + sin(10*mod(t, 2));

%% 2. Отрисовка оригинала
t_plot = linspace(0, 6, 3000); % 3 периода
f_orig = f_handle(t_plot);
plot_periodic_signal(t_plot, f_orig, 'f(t) = 2t + sin(10t)', 'img/fun_orig.pdf', [-1, 6]);

%% 3. Расчет коэффициентов (для N=2)
[an, bn, cn, nn] = calc_fourier(f_handle, t0, T, 2);
print_fourier_results(an, bn, cn, nn, 2);

%% 4. Аппроксимация
for N = N_values
    [an, bn, cn, nn] = calc_fourier(f_handle, t0, T, N);
    [FN, GN] = reconstruct_fourier(an, bn, cn, nn, T, t_plot);
    fname = sprintf('img/fun_plot_N%d.pdf', N);
    plot_fourier_approx(t_plot, f_orig, FN, GN, N, fname, [-1, 6]);
end

%% Проверка равенства Парсеваля (для максимального N)
N_max = max(N_values);
[an_max, bn_max, cn_max, nn_max] = calc_fourier(f_handle, t0, T, N_max);
verify_parseval(an_max, bn_max, cn_max, f_handle, t0, T, N_max);