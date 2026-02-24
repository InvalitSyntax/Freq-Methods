%% 1. Параметры
a = 4; b = 2; t0 = 1; t1 = 2; t2 = 3;
T = t2 - t0;
N_max = 50; % Берем максимальное N по заданию

% Определение функции f(t)
f_handle = @(t) a .* (mod(t-t0, T) < (t1-t0)) + b .* (mod(t-t0, T) >= (t1-t0));

%% 2. Расчет коэффициентов
[an, bn, cn, nn] = calc_fourier(f_handle, t0, T, N_max);

%% 3. Вызов функции проверки
verify_parseval(an, bn, cn, f_handle, t0, T, N_max);