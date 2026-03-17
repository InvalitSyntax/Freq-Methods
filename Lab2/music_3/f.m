[y, Fs] = audioread('Аккорд (13).mp3');
if size(y, 2) > 1
    y = y(:, 1);
end

t = (0:length(y)-1)' / Fs;

set(0, 'DefaultAxesFontName', 'Helvetica');
set(0, 'DefaultTextFontName', 'Helvetica');

fig1 = figure('Units', 'pixels', 'Position', [100, 100, 800, 500]);
ax1 = axes('Parent', fig1);
plot(ax1, t, y, 'LineWidth', 1, 'Color', [0 0.4470 0.7410]);
grid(ax1, 'on');

set(ax1, 'Position', [0.12, 0.25, 0.83, 0.70], 'TickLabelInterpreter', 'latex');
xlabel(ax1, '$t$', 'FontSize', 14, 'Interpreter', 'latex');
ylabel(ax1, '$f(t)$', 'FontSize', 14, 'Interpreter', 'latex');
xlim(ax1, [min(t), max(t)]);

lgd1 = legend(ax1, '$f(t)$', 'FontSize', 14, 'Interpreter', 'latex');
set(lgd1, 'Location', 'none', 'Units', 'normalized');
drawnow;
lgd1.Position = [ax1.Position(1), 0.05, lgd1.Position(3), lgd1.Position(4)];

exportgraphics(fig1, 'audio_f_t.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');

v = 0:1:2000;
Y = zeros(1, length(v));

for k = 1:length(v)
    Y(k) = trapz(t, y .* exp(-1i * 2 * pi * v(k) * t));
end

fig2 = figure('Units', 'pixels', 'Position', [100, 100, 800, 500]);
ax2 = axes('Parent', fig2);
plot(ax2, v, abs(Y), 'LineWidth', 1.5, 'Color', [0 0.4470 0.7410]);
grid(ax2, 'on');

set(ax2, 'Position', [0.12, 0.25, 0.83, 0.70], 'TickLabelInterpreter', 'latex');
xlabel(ax2, '$\nu$', 'FontSize', 14, 'Interpreter', 'latex');
ylabel(ax2, '$|\hat{f}(\nu)|$', 'FontSize', 14, 'Interpreter', 'latex');
xlim(ax2, [min(v), max(v)]);

lgd2 = legend(ax2, '$|\hat{f}(\nu)|$', 'FontSize', 14, 'Interpreter', 'latex');
set(lgd2, 'Location', 'none', 'Units', 'normalized');
drawnow;
lgd2.Position = [ax2.Position(1), 0.05, lgd2.Position(3), lgd2.Position(4)];

exportgraphics(fig2, 'audio_f_nu.pdf', 'ContentType', 'vector', 'BackgroundColor', 'none');