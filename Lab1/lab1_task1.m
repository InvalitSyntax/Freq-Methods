% Параметры для первой задачи
a = 4; b = 2; t0 = 1; t1 = 2; t2 = 3;
T = t2 - t0;
N_harmonics = 2;

% Описываем нашу квадратную волну
% Условие: если остаток времени в периоде меньше длины первого импульса
f_wave = @(t) a .* (mod(t-t0, T) < (t1-t0)) + b .* (mod(t-t0, T) >= (t1-t0));

% ВЫЗОВ ФУНКЦИИ
[an, bn, cn, nn] = calc_fourier(f_wave, t0, T, N_harmonics);

%% Красивый вывод результатов
fprintf('--- Результаты расчета (N = %d) ---\n', N_harmonics);
for n = 0:N_harmonics
    if n == 0
        fprintf('a0 = %.4f\n', an(n+1));
    else
        fprintf('n = %d: an = %.4f, bn = %.4f\n', n, an(n+1), bn(n+1));
    end
end

fprintf('\n--- Комплексные коэффициенты cn ---\n');
for i = 1:length(nn)
    fprintf('c(%2d) = %8.4f + %8.4fi\n', nn(i), real(cn(i)), imag(cn(i)));
end