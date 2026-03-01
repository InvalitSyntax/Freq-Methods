function [FN, GN] = reconstruct_fourier(an, bn, cn, nn, T, t)
    % reconstruct_fourier - Восстановление сигнала из коэффициентов
    w0 = 2 * pi / T;
    
    % 1. Тригонометрическая форма FN
    FN = an(1)/2 * ones(size(t));
    for n = 1:(length(an)-1)
        FN = FN + an(n+1)*cos(n*w0*t) + bn(n+1)*sin(n*w0*t);
    end
    
    % 2. Комплексная форма GN
    GN = zeros(size(t));
    for i = 1:length(nn)
        GN = GN + cn(i)*exp(1i*nn(i)*w0*t);
    end
    GN = real(GN); % Убираем мнимый "шум"
end