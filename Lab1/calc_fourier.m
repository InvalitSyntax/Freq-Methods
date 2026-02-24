function [an, bn, cn, nn] = calc_fourier(f_handle, t0, T, N)
    % f_handle - анонимная функция, например @(t) t.^2
    % t0 - начало интервала
    % T - период
    % N - количество гармоник
    
    w0 = 2 * pi / T;
    
    % Инициализация массивов
    an = zeros(1, N + 1); % Индексы соответствуют n = 0, 1, ..., N
    bn = zeros(1, N + 1); % bn(1) всегда будет 0 (это b0)
    
    % Расчет an и bn
    for n = 0:N
        an(n+1) = (2/T) * integral(@(t) f_handle(t) .* cos(n * w0 * t), t0, t0 + T);
        if n > 0
            bn(n+1) = (2/T) * integral(@(t) f_handle(t) .* sin(n * w0 * t), t0, t0 + T);
        end
    end
    
    % Расчет cn
    nn = -N:N;
    cn = zeros(size(nn));
    for i = 1:length(nn)
        n = nn(i);
        cn(i) = (1/T) * integral(@(t) f_handle(t) .* exp(-1i * n * w0 * t), t0, t0 + T);
    end
end