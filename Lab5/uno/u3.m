if ~exist('img2', 'dir'), mkdir('img2'); end

set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');

run_all_cases(20, 0.01, 'success');   
run_all_cases(20, 0.2, 'aliasing');   
run_all_cases(1.2, 0.01, 'low_res');  
run_all_cases(10, 0.5, 'failure');    

run_full_comparison(20, 0.01, 'win');   
run_full_comparison(10, 0.5, 'lose');

function run_all_cases(T, dt, name)
    t = -T/2 : dt : T/2-dt;
    N = length(t);
    pi_t = double(abs(t) <= 0.5);

    m_raw = 0:N-1;
    c = dt * exp(1i * pi * m_raw);

    pi_hat = fftshift(c .* fft(pi_t));
    pi_rec = ifft(ifftshift(pi_hat) ./ c);

    nu = (-N/2 : N/2-1) * (1/T);
    nu_ideal = linspace(-20, 20, 1000);
    
    f1 = figure('Visible', 'off', 'Position', [100, 100, 500, 500]);
    plot(nu, real(pi_hat), 'r', 'LineWidth', 1.5); hold on;
    plot(nu_ideal, sinc(nu_ideal), 'k--', 'LineWidth', 1.5);
    grid on; xlabel('\nu'); ylabel('\Pi(\nu)');
    xlim([-20 20]);
    legend('Модифицированный DFT', 'Аналитический образ', ...
           'Location', 'southoutside', 'Orientation', 'vertical', 'FontSize', 10);
    exportgraphics(f1, ['img2/final_', name, '_spec.pdf'], 'ContentType', 'vector');
    close(f1);

    t_ideal = linspace(-1.5, 1.5, 1000);
    pi_ideal = double(abs(t_ideal) <= 0.5);
    f2 = figure('Visible', 'off', 'Position', [100, 100, 500, 500]);
    plot(t_ideal, pi_ideal, 'k--', 'LineWidth', 1.2); hold on;
    plot(t, real(pi_rec), 'b', 'LineWidth', 1.5);
    grid on; xlabel('t'); ylabel('\Pi(t)');
    xlim([-1.5 1.5]);
    legend('Оригинал', 'Восстановленный сигнал', ...
           'Location', 'southoutside', 'Orientation', 'vertical', 'FontSize', 10);
    exportgraphics(f2, ['img2/final_', name, '_time.pdf'], 'ContentType', 'vector');
    close(f2);
end


function run_full_comparison(T, dt, name)
    t = -T/2 : dt : T/2-dt;
    N = length(t);
    pi_t = double(abs(t) <= 0.5);
    
    nu_lim = 20; dnu = 0.1;
    nu_trapz = -nu_lim:dnu:nu_lim;
    hat_trapz = zeros(size(nu_trapz));
    for i = 1:length(nu_trapz)
        hat_trapz(i) = trapz(t, pi_t .* exp(-2*pi*1j*nu_trapz(i)*t));
    end
    rec_trapz = zeros(size(t));
    for i = 1:length(t)
        rec_trapz(i) = trapz(nu_trapz, hat_trapz .* exp(2*pi*1j*nu_trapz*t(i)));
    end
    
    hat_std = fftshift(fft(pi_t)) / sqrt(N);
    rec_std = real(ifft(ifftshift(hat_std)) * sqrt(N));
    
    m = 0:N-1;
    c = dt * exp(1i * pi * m);
    hat_mod = fftshift(c .* fft(pi_t));
    rec_mod = real(ifft(ifftshift(hat_mod) ./ c));
    
    nu_fft = (-N/2 : N/2-1) * (1/T);
    nu_ref = linspace(-10, 10, 1000);
    f1 = figure('Visible', 'off', 'Position', [100, 100, 600, 600]);
    plot(nu_fft, real(hat_mod), 'r', 'LineWidth', 2); hold on;
    plot(nu_fft, real(hat_std), 'g', 'LineWidth', 1);
    plot(nu_trapz, real(hat_trapz), 'b--', 'LineWidth', 1);
    plot(nu_ref, sinc(nu_ref), 'k:', 'LineWidth', 1.5);
    grid on; xlabel('\nu'); ylabel('\Pi(\nu)'); xlim([-10 10]);
    legend('Модифицированный FFT', 'Стандартный FFT', 'Метод Трапеций', 'Аналитическое', ...
           'Location', 'southoutside', 'Orientation', 'vertical');
    exportgraphics(f1, ['img2/comp_', name, '_spec.pdf'], 'ContentType', 'vector');
    close(f1);

    t_ref = linspace(-1.5, 1.5, 1000);
    pi_ref = double(abs(t_ref) <= 0.5);
    f2 = figure('Visible', 'off', 'Position', [100, 100, 600, 600]);
    plot(t_ref, pi_ref, 'k:', 'LineWidth', 2); hold on;
    plot(t, real(rec_mod), 'r', 'LineWidth', 1.5);
    plot(t, real(rec_std), 'g--', 'LineWidth', 1);
    plot(t, real(rec_trapz), 'b-.', 'LineWidth', 1);
    grid on; xlabel('t'); ylabel('\Pi(t)'); xlim([-1.5 1.5]);
    legend('Оригинал', 'Модифицированный FFT', 'Стандартный FFT', 'Метод Трапеций', ...
           'Location', 'southoutside', 'Orientation', 'vertical');
    exportgraphics(f2, ['img2/comp_', name, '_time.pdf'], 'ContentType', 'vector');
    close(f2);
end