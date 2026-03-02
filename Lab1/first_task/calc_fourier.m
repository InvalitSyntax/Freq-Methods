function [an, bn, cn, nn] = calc_fourier(f_handle, t0, T, N)
    w0 = 2 * pi / T;
    an = zeros(1, N + 1);
    bn = zeros(1, N + 1);
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