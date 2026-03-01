function verify_parseval(an, bn, cn, f_handle, t0, T, N)
    % verify_parseval - Проверка равенства Парсеваля и вывод результатов
    
    % 1. Средний квадрат нормы оригинала: (1/T) * ||f||^2
    norm_sq_avg = (1/T) * integral(@(t) f_handle(t).^2, t0, t0 + T);

    % 2. Сумма квадратов тригонометрических коэффициентов
    % (an(1) - это a0, остальные со 2-го индекса)
    S_FN = (an(1)/2)^2 + 0.5 * sum(an(2:end).^2 + bn(2:end).^2);

    % 3. Сумма квадратов комплексных коэффициентов
    S_GN = sum(abs(cn).^2);

    % --- Красивый вывод ---
    divider = repmat('-', 1, 60);
    fprintf('\n%s\n', divider);
    fprintf('   ПРОВЕРКА РАВЕНСТВА ПАРСЕВАЛЯ (N = %d)\n', N);
    fprintf('%s\n', divider);
    fprintf('%-40s | %-15s\n', 'Параметр', 'Значение');
    fprintf('%s\n', divider);
    fprintf('%-40s | %15.10f\n', 'Ср. квадрат нормы оригинала (1/T*||f||^2)', norm_sq_avg);
    fprintf('%-40s | %15.10f\n', 'Сумма кв. коэфф. триг. формы (S_FN)', S_FN);
    fprintf('%-40s | %15.10f\n', 'Сумма кв. коэфф. компл. формы (S_GN)', S_GN);
    fprintf('%s\n', divider);
    fprintf('%-40s | %15.10f\n', 'Разность (Погрешность)', norm_sq_avg - S_FN);
    fprintf('%s\n', divider);
end