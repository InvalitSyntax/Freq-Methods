%% 1. Параметры функции
a = 4; 
b = 2; 
t0 = 1; 
t1 = 2; 
t2 = 3;
T = t2 - t0; % Период T = 2

% Разные значения N для анализа сходимости
N_values = [1, 3, 5, 10, 50]; 

% Анонимная функция для квадратной волны
% mod(t-t0, T) переводит любое t в диапазон [0, T]
f_handle = @(t) a .* (mod(t-t0, T) < (t1-t0)) + b .* (mod(t-t0, T) >= (t1-t0));

%% 2. Отрисовка оригинала (3 периода)
% Рисуем от t0 до t0 + 3*T (от 1 до 7)
t_plot = linspace(t0, t0 + 3*T, 3000); 
f_orig = f_handle(t_plot);

% Проверка папки для картинок
if ~exist('img', 'dir'), mkdir('img'); end

plot_periodic_signal(t_plot, f_orig, 'f(t) - Квадратная волна', 'img/square_orig.pdf', [b-1, a+1]);

%% 3. Расчет и вывод коэффициентов (для примера N=5)
N_print = 5;
[an, bn, cn, nn] = calc_fourier(f_handle, t0, T, N_print);
print_fourier_results(an, bn, cn, nn, N_print);

%% 4. Построение аппроксимаций (цикл по разным N)
y_lims = [b-1, a+1]; % Границы по вертикали для графиков

for N = N_values
    % Расчет
    [an, bn, cn, nn] = calc_fourier(f_handle, t0, T, N);
    
    % Восстановление сигнала
    [FN, GN] = reconstruct_fourier(an, bn, cn, nn, T, t_plot);
    
    % Сохранение графика
    fname = sprintf('img/square_plot_N%d.pdf', N);
    plot_fourier_approx(t_plot, f_orig, FN, GN, N, fname, y_lims);
end

%% 5. Проверка равенства Парсеваля (для максимального N)
N_max = max(N_values);
[an_max, bn_max, cn_max, nn_max] = calc_fourier(f_handle, t0, T, N_max);
verify_parseval(an_max, bn_max, cn_max, f_handle, t0, T, N_max);