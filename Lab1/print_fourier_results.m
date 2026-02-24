function print_fourier_results(an, bn, cn, nn, N)
    % print_fourier_results - Красивый вывод коэффициентов в консоль
    
    divider = repmat('=', 1, 40);
    fprintf('\n%s\n', divider);
    fprintf('   РЕЗУЛЬТАТЫ РАСЧЕТА (N = %d)\n', N);
    fprintf('%s\n', divider);

    % Вывод тригонометрической формы
    fprintf('1. Тригонометрические коэффициенты:\n');
    fprintf('----------------------------------------\n');
    fprintf('  n  |      an      |      bn      \n');
    fprintf('----------------------------------------\n');
    for n = 0:N
        if n == 0
            fprintf(' %2d  |  %10.4f  |      -       \n', n, an(n+1));
        else
            fprintf(' %2d  |  %10.4f  |  %10.4f  \n', n, an(n+1), bn(n+1));
        end
    end

    % Вывод комплексной формы
    fprintf('\n2. Комплексные коэффициенты cn:\n');
    fprintf('----------------------------------------\n');
    fprintf('  n  |         c_n (Re + Im)         \n');
    fprintf('----------------------------------------\n');
    for i = 1:length(nn)
        % Определяем знак мнимой части для красоты
        if imag(cn(i)) >= 0
            sgn = '+';
        else
            sgn = '-';
        end
        fprintf(' %3d |  %9.4f %s %.4fi\n', nn(i), real(cn(i)), sgn, abs(imag(cn(i))));
    end
    fprintf('----------------------------------------\n');
end