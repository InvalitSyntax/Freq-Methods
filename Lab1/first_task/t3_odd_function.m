%% Параметры функции
T = 2;
t0 = -1;
N_values = [1, 3, 5, 10, 50]; 

f_handle = @(t) mod(t + 1, 2) - 1;

%% Отрисовка оригинала
t_plot = linspace(-3, 3, 3000); 
f_orig = f_handle(t_plot);
plot_periodic_signal(t_plot, f_orig, 'f(t) = t (Нечётная)', 'img/odd_orig.pdf', [-1.5, 1.5]);

%% Расчет коэффициентов (для N=2)
[an, bn, cn, nn] = calc_fourier(f_handle, t0, T, 2);
print_fourier_results(an, bn, cn, nn, 2);

%% Аппроксимация
for N = N_values
    [an, bn, cn, nn] = calc_fourier(f_handle, t0, T, N);
    [FN, GN] = reconstruct_fourier(an, bn, cn, nn, T, t_plot);
    fname = sprintf('img/odd_plot_N%d.pdf', N);
    plot_fourier_approx(t_plot, f_orig, FN, GN, N, fname, [-1.5, 1.5]);
end

%% Проверка равенства Парсеваля (для максимального N)
N_max = max(N_values);
[an_max, bn_max, cn_max, nn_max] = calc_fourier(f_handle, t0, T, N_max);
verify_parseval(an_max, bn_max, cn_max, f_handle, t0, T, N_max);