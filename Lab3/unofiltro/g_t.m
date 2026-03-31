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

G_hat = fftshift(fft(g)) * dt;
if length(v) > length(G_hat)
    v = v(1:length(G_hat));
end

if ~exist('img', 'dir'), mkdir('img'); end

fig1 = figure('Units', 'pixels', 'Position', [100, 100, 800, 500], 'Visible', 'on');
ax1 = axes('Parent', fig1);

plot(t, g, 'LineWidth', 2.5, 'Color', [0 0.4470 0.7410]);
grid on;


xlabel('Time $t$, s', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$g(t)$', 'Interpreter', 'latex', 'FontSize', 18);
xlim([-1, 6]); 
ylim([-0.5, a + 1]);

set(ax1, 'Position', [0.15, 0.28, 0.75, 0.65]); 
lgd1 = legend('Signal $g(t)$', 'Interpreter', 'latex', 'FontSize', 14);
set(lgd1, 'Location', 'none', 'Units', 'normalized');
drawnow;
lgd1.Position = [ax1.Position(1), 0.08, lgd1.Position(3), lgd1.Position(4)];

exportgraphics(fig1, 'img/signal_g.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');

fig2 = figure('Units', 'pixels', 'Position', [100, 100, 800, 500], 'Visible', 'on');
ax2 = axes('Parent', fig2);

plot(v, abs(G_hat), 'LineWidth', 2, 'Color', '#D95319');
grid on;

xlabel('Frequency $\nu$, Hz', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$|\hat{g}(\nu)|$', 'Interpreter', 'latex', 'FontSize', 20);
xlim([-5, 5]); 

set(ax2, 'Position', [0.15, 0.28, 0.75, 0.65]); 
lgd2 = legend('Magnitude spectrum $|\hat{g}(\nu)|$', 'Interpreter', 'latex', 'FontSize', 14);
set(lgd2, 'Location', 'none', 'Units', 'normalized');
drawnow;
lgd2.Position = [ax2.Position(1), 0.08, lgd2.Position(3), lgd2.Position(4)];

exportgraphics(fig2, 'img/spectrum_g.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');