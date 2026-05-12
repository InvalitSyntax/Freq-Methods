if ~exist('img2', 'dir'), mkdir('img2'); end

set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');

run_experiment(10, 0.01, 20, 0.1, 'success');
run_experiment(10, 0.01, 20, 0.5, 'big_dv');
run_experiment(10, 0.01, 2, 0.1, 'low_V');
run_experiment(10, 0.5, 20, 0.1, 'large_dt');
run_experiment(0.7, 0.01, 20, 0.1, 'small_T');

function run_experiment(T, dt, V, dnu, name)
    t = -T/2:dt:T/2;
    pi_t = double(abs(t) <= 0.5);

    nu = -V/2:dnu:V/2;
    pi_hat_num = zeros(size(nu));
    for i = 1:length(nu)
        integrand = pi_t .* exp(-2*pi*1j*nu(i)*t);
        pi_hat_num(i) = trapz(t, integrand);
    end

    pi_recovered = zeros(size(t));
    for i = 1:length(t)
        integrand = pi_hat_num .* exp(2*pi*1j*nu*t(i));
        pi_recovered(i) = trapz(nu, integrand);
    end

    nu_ideal = linspace(-10, 10, 1000);
    f1 = figure('Visible', 'off', 'Position', [100, 100, 500, 500]);
    plot(nu, real(pi_hat_num), 'r', 'LineWidth', 1.5); hold on;
    plot(nu_ideal, sinc(nu_ideal), 'k--', 'LineWidth', 1);
    grid on; xlabel('\nu'); ylabel('\Pi(\nu)');
    xlim([-10 10]);
    legend('Численный образ', 'Аналитический образ', ...
           'Location', 'southoutside', 'Orientation', 'vertical', 'FontSize', 11);
    exportgraphics(f1, ['img2/trapz_', name, '_spec.pdf'], 'ContentType', 'vector');
    close(f1);

    t_ideal = linspace(-1.5, 1.5, 1000);
    pi_ideal = double(abs(t_ideal) <= 0.5);
    f2 = figure('Visible', 'off', 'Position', [100, 100, 500, 500]);
    plot(t_ideal, pi_ideal, 'k--', 'LineWidth', 1.2); hold on;
    plot(t, real(pi_recovered), 'b', 'LineWidth', 1.5);
    grid on; xlabel('t'); ylabel('\Pi(t)');
    xlim([-1.5 1.5]);
    legend('Оригинал', 'Восстановленный сигнал', ...
           'Location', 'southoutside', 'Orientation', 'vertical', 'FontSize', 11);
    exportgraphics(f2, ['img2/trapz_', name, '_time.pdf'], 'ContentType', 'vector');
    close(f2);
end