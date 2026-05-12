% ЛАБОРАТОРНАЯ РАБОТА №6
% 9. Восстановление картинки (Математически точный метод)

clear; clc; close all;

% --- Имена файлов ---
image_path = '15.png';
edited_img_path = '15_fourier_spectrum3.png';
output_path = '15_restored_math_method3.png';

% =========================================================================
% ЭКВИВАЛЕНТ: load_and_normalize_image
% =========================================================================
img_array = double(imread(image_path)) / 255.0;
[H, W, C] = size(img_array);

% =========================================================================
% ЭКВИВАЛЕНТ: compute_fft
% =========================================================================
fft_channels = zeros(H, W, C);
magnitude_channels = zeros(H, W, C);
phase_channels = zeros(H, W, C);

for c = 1:C
    fft_channels(:,:,c) = fftshift(fft2(img_array(:,:,c)));
    magnitude_channels(:,:,c) = abs(fft_channels(:,:,c));
    phase_channels(:,:,c) = angle(fft_channels(:,:,c));
end

% =========================================================================
% ЭКВИВАЛЕНТ: log_normalize_magnitude
% =========================================================================
% Используем log1p (аналог np.log1p в питоне), вычисляет ln(1+x)
log_magnitude = log1p(magnitude_channels);

% Находим глобальные минимум и максимум по всем 3 каналам сразу
log_min = min(log_magnitude(:));
log_max = max(log_magnitude(:));

% Нормализуем
log_mag_norm = (log_magnitude - log_min) / (log_max - log_min);

% =========================================================================
% ЭКВИВАЛЕНТ: restore_magnitude_from_edited_spectrum
% =========================================================================
% Загружаем отредактированный спектр
edited_array = double(imread(edited_img_path)) / 255.0;

% В Питоне был .convert("RGB"). В Матлабе, если вы сохранили ч/б спектр 
% (1 канал), нам нужно размножить его до 3 каналов, чтобы размерности совпали.
if size(edited_array, 3) == 1 && C == 3
    edited_array = repmat(edited_array, [1, 1, 3]);
end

% 1. Де-нормализация
log_mag_restored = edited_array * (log_max - log_min) + log_min;

% 2. Де-логарифмирование (expm1 аналог np.expm1, вычисляет e^x - 1)
magnitude_restored = expm1(log_mag_restored);

% 3. Сборка комплексного Фурье-образа с оригинальными фазами
fft_channels_restored = magnitude_restored .* exp(1i * phase_channels);

% =========================================================================
% ЭКВИВАЛЕНТ: reconstruct_image
% =========================================================================
reconstructed_image = zeros(H, W, C);

for c = 1:C
    % Обратный сдвиг и обратное Фурье
    img_ifft = ifft2(ifftshift(fft_channels_restored(:,:,c)));
    
    % Берем вещественную часть
    reconstructed = real(img_ifft);
    
    % Ограничиваем (клипаем) значения строго от 0 до 1 (аналог np.clip)
    reconstructed_image(:,:,c) = max(0, min(1, reconstructed));
end

% =========================================================================
% СОХРАНЕНИЕ И ВЫВОД НА ЭКРАН
% =========================================================================
imwrite(reconstructed_image, output_path);
disp(['Изображение успешно восстановлено и сохранено как: ', output_path]);

figure('Name', 'Сравнение результатов', 'NumberTitle', 'off', 'Position', [100, 100, 1200, 450]);

subplot(1, 3, 1);
imshow(img_array);
title('Оригинальное изображение');

subplot(1, 3, 2);
imshow(edited_array);
title('Отредактированный спектр');

subplot(1, 3, 3);
imshow(reconstructed_image);
title('Фильтрованное изображение');