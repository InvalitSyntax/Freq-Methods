close all;

a = 4;
t1 = 1;
t2 = 4;
T_total = 20;
dt = 0.01;
t = -T_total/2 : dt : T_total/2;

V = 1/dt;
dv = 1/T_total;
v = -V/2 : dv : V/2;

g = zeros(size(t));
g(t >= t1 & t <= t2) = a;
G_hat_orig = fftshift(fft(g));

if ~exist('img', 'dir'), mkdir('img'); end

b_vals = [1.5, 1.5, 1.5, 1.5];
c_vals = [3.0, 3.0, 3.0, 3.0];
d_vals = [62.83, 62.83, 62.83, 62.83]; 
v0_vals = [3.0, 0.4, 3.0, 3.0]; 
v_bsf = [9.5, 10.5; 9.5, 10.5; 4.0, 6.0; 0.5, 1.5];
case_names = {'comb_good', 'comb_bad_lpf', 'comb_bad_bsf', 'comb_overlap'};

for i = 1:length(b_vals)
    b = b_vals(i);
    c = c_vals(i);
    d = d_vals(i);
    v0 = v0_vals(i);
    v1 = v_bsf(i, 1);
    v2 = v_bsf(i, 2);
    
    xi = 2 * rand(size(t)) - 1;
    u = g + b * xi + c * sin(d * t);
    U_hat = fftshift(fft(u));
    
    mask_lpf = abs(v) <= v0;
    mask_bsf = ones(size(v));
    mask_bsf((abs(v) >= v1) & (abs(v) <= v2)) = 0;
    
    mask_total = mask_lpf .* mask_bsf;
    
    if length(mask_total) > length(U_hat)
        mask_total = mask_total(1:length(U_hat));
    end
    
    U_filt_hat = U_hat .* mask_total;
    u_filt = real(ifft(ifftshift(U_filt_hat)));

    fig_t = figure('Units', 'pixels', 'Position', [100, 100, 800, 500], 'Visible', 'off');
    ax_t = axes('Parent', fig_t);
    hold on; grid on;
    
    plot(t, u, 'Color', [0.6 0.6 0.6], 'LineWidth', 0.5);
    plot(t, g, 'k--', 'LineWidth', 1.5);
    plot(t, u_filt, 'Color', [0 0.4470 0.7410], 'LineWidth', 2);
    
    xlabel('Time $t$, s', 'Interpreter', 'latex', 'FontSize', 14);
    ylabel('Signal Amplitude', 'Interpreter', 'latex', 'FontSize', 14);
    xlim([-2, 7]);
    ylim([-b-c-1, a+b+c+1]);
    
    set(ax_t, 'Position', [0.12, 0.28, 0.83, 0.65], 'TickLabelInterpreter', 'latex');
    lgd_t = legend({'Noisy $u(t)$', 'Original $g(t)$', 'Filtered $s_{filt}(t)$'}, ...
        'Interpreter', 'latex', 'FontSize', 12, 'Location', 'none', 'Units', 'normalized');
    drawnow;
    lgd_t.Position = [ax_t.Position(1), 0.08, lgd_t.Position(3), lgd_t.Position(4)];
    
    exportgraphics(fig_t, sprintf('img/comb_time_%s.pdf', case_names{i}), 'ContentType', 'vector');
    close(fig_t);

    fig_f = figure('Units', 'pixels', 'Position', [100, 100, 800, 500], 'Visible', 'off');
    ax_f = axes('Parent', fig_f);
    hold on; grid on;
    
    v_plot = v(1:length(U_hat));
    plot(v_plot, abs(U_hat)*dt, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5);
    plot(v_plot, abs(G_hat_orig)*dt, 'k--', 'LineWidth', 1.2);
    plot(v_plot, abs(U_filt_hat)*dt, 'Color', '#D95319', 'LineWidth', 1.5);
    
    xlabel('Frequency $\nu$, Hz', 'Interpreter', 'latex', 'FontSize', 14);
    ylabel('$|\hat{s}(\nu)|$', 'Interpreter', 'latex', 'FontSize', 16);
    xlim([-15, 15]);
    
    set(ax_f, 'Position', [0.12, 0.28, 0.83, 0.65], 'TickLabelInterpreter', 'latex');
    lgd_f = legend({'$|\hat{u}(\nu)|$', '$|\hat{g}(\nu)|$', '$|\hat{s}_{filt}(\nu)|$'}, ...
        'Interpreter', 'latex', 'FontSize', 12, 'Location', 'none', 'Units', 'normalized');
    drawnow;
    lgd_f.Position = [ax_f.Position(1), 0.08, lgd_f.Position(3), lgd_f.Position(4)];
    
    exportgraphics(fig_f, sprintf('img/comb_spec_%s.pdf', case_names{i}), 'ContentType', 'vector');
    close(fig_f);
end