clear; clc; close all;

%% 1. Настройка параметров
N_values = [1, 3, 7, 15, 50]; % Пять значений N
a = 4; b = 2; t0_1 = 1; t1_1 = 2; t2_1 = 3; T1 = t2_1 - t0_1;

% Определение 4-х функций
funcs = {
    @(t) a .* (mod(t-t0_1, T1) < (t1_1-t0_1)) + b .* (mod(t-t0_1, T1) >= (t1_1-t0_1)), ... % 1. Квадратная
    @(t) (mod(t + pi, 2*pi) - pi).^2, ...                                              % 2. Четная (t^2)
    @(t) (mod(t + pi, 2*pi) - pi), ...                                                 % 3. Нечетная (t)
    @(t) exp(0.5 * mod(t, 2))                                                           % 4. Ни та ни другая
};

f_names = {'Квадратная волна', 'Четная функция', 'Нечетная функция', 'Произвольная функция'};
t0_list = {t0_1, -pi, -pi, 0};
T_list = {T1, 2*pi, 2*pi, 2};

%% 2. Основной цикл по функциям
for f_idx = 1:4
    f_handle = funcs{f_idx};
    T = T_list{f_idx};
    t0 = t0_list{f_idx};
    
    fprintf('\n--- АНАЛИЗ ФУНКЦИИ: %s ---\n', f_names{f_idx});
    
    % Вложенный цикл по значениям N (Пункт 3)
    for N = N_values
        t_plot = linspace(t0, t0 + 3*T, 1000);
        f_orig = f_handle(t_plot);
        
        % Расчет коэффициентов и восстановление
        [an, bn, cn, nn] = calc_fourier_core(f_handle, t0, T, N);
        [FN, GN] = reconstruct_fourier_core(an, bn, cn, nn, T, t_plot);
        
        % Построение графиков (Пункт 3)
        figure('Name', [f_names{f_idx}, ' N=', num2str(N)], 'Position', [200, 200, 700, 400]);
        plot(t_plot, f_orig, 'Color', [0.7 0.7 0.7], 'LineWidth', 2, 'DisplayName', 'f(t) Оригинал'); hold on;
        plot(t_plot, FN, 'b-', 'LineWidth', 1.5, 'DisplayName', ['F_{', num2str(N), '}(t) Триг.']);
        plot(t_plot, GN, 'r:', 'LineWidth', 2, 'DisplayName', ['G_{', num2str(N), '}(t) Компл.']);
        grid on; xlabel('t'); ylabel('f(t)');
        title(sprintf('%s (N = %d)', f_names{f_idx}, N));
        legend('Location', 'best');
    end
    
    % Проверка равенства Парсеваля (Пункт 4) для наибольшего N
    N_max = max(N_values);
    [an, bn, cn, nn] = calc_fourier_core(f_handle, t0, T, N_max);
    
    norm_sq = (1/T) * integral(@(t) f_handle(t).^2, t0, t0 + T);
    S_FN = (an(1)/2)^2 + 0.5 * sum(an(2:end).^2 + bn(2:end).^2);
    S_GN = sum(abs(cn).^2);
    
    fprintf('Равенство Парсеваля для N=%d:\n', N_max);
    fprintf('  Энергия оригинала: %.6f\n', norm_sq);
    fprintf('  Энергия ряда (триг): %.6f\n', S_FN);
    fprintf('  Энергия ряда (компл): %.6f\n', S_GN);
    fprintf('  Разница (потеря энергии): %.6f\n', norm_sq - S_FN);
end

%% --- Вспомогательные функции ---
function [an, bn, cn, nn] = calc_fourier_core(f, t0, T, N)
    w0 = 2*pi/T;
    an = zeros(1,N+1); bn = zeros(1,N+1);
    for n = 0:N
        an(n+1) = (2/T) * integral(@(t) f(t).*cos(n*w0*t), t0, t0+T);
        if n>0, bn(n+1) = (2/T) * integral(@(t) f(t).*sin(n*w0*t), t0, t0+T); end
    end
    nn = -N:N; cn = zeros(size(nn));
    for i=1:length(nn)
        cn(i) = (1/T) * integral(@(t) f(t).*exp(-1i*nn(i)*w0*t), t0, t0+T);
    end
end

function [FN, GN] = reconstruct_fourier_core(an, bn, cn, nn, T, t)
    w0 = 2*pi/T; FN = an(1)/2;
    for n = 1:(length(an)-1)
        FN = FN + an(n+1)*cos(n*w0*t) + bn(n+1)*sin(n*w0*t);
    end
    GN = zeros(size(t));
    for i=1:length(nn), GN = GN + cn(i)*exp(1i*nn(i)*w0*t); end
    GN = real(GN);
end