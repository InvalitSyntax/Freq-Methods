if ~exist('img2', 'dir'), mkdir('img2'); end

set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');

run_fft_task(10, 0.01, 'success');
run_fft_task(10, 0.2, 'big_dt');
run_fft_task(1.2, 0.01, 'low_t');

function run_fft_task(T, dt, name)
    t = -T/2:dt:T/2-dt;
    N = length(t);
    pi_t = double(abs(t) <= 0.5);

    pi_hat_dft = fftshift(fft(pi_t)) / sqrt(N);
    
    pi_recovered = ifft(ifftshift(pi_hat_dft)) * sqrt(N);

    df = 1/T;
    nu = (-N/2:N/2-1) * df;

    nu_ideal = linspace(-10, 10, 1000);
    f1 = figure('Visible', 'off', 'Position', [100, 100, 500, 500]);
    plot(nu, real(pi_hat_dft), 'r', 'LineWidth', 1.2); hold on;
    plot(nu_ideal, sinc(nu_ideal), 'k--', 'LineWidth', 1.5);
    grid on; xlabel('\nu'); ylabel('\Pi(\nu)');
    xlim([-10 10]);
    legend('DFT образ (real)', 'Истинный образ (sinc)', ...
           'Location', 'southoutside', 'Orientation', 'vertical', 'FontSize', 11);
    exportgraphics(f1, ['img2/fft_', name, '_spec.pdf'], 'ContentType', 'vector');
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
    exportgraphics(f2, ['img2/fft_', name, '_time.pdf'], 'ContentType', 'vector');
    close(f2);
end