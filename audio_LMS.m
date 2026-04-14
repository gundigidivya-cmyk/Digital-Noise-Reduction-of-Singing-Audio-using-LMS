clc;
clear;
close all;

% Load audio file
[clean_signal, fs] = audioread('voice.wav');

% Convert stereo to mono
clean_signal = mean(clean_signal, 2);

% Normalize signal
clean_signal = clean_signal / max(abs(clean_signal));

% Add noise
noise = 0.6 * randn(size(clean_signal));
noisy_signal = clean_signal + noise;

% Create reference noise (correlaed noise)
reference_noise = filter([1 0.5], 1, noise);

% LMS Parameters
mu = 0.0005;   % Step size (learning rate)
M = 64;        % Filter order

% Initialization
w = zeros(M,1);
N = length(noisy_signal);

y = zeros(N,1);   % Filter output
e = zeros(N,1);   % Error (cleaned signal)

% LMS Algorithm
for n = M:N
    x = reference_noise(n:-1:n-M+1);  % Input vector
    y(n) = w' * x;                   % Output
    e(n) = noisy_signal(n) - y(n);   % Error
    w = w + mu * x * e(n);           % Update weights
end

% Normalize output
e = e / max(abs(e));

% Plot signals
figure;

subplot(3,1,1);
plot(noisy_signal);
title('Noisy Signal');

subplot(3,1,2);
plot(e);
title('Filtered Signal');

subplot(3,1,3);
plot(clean_signal);
title('Original Signal');

% Play audio
disp('Playing Noisy Signal...');
sound(noisy_signal, fs);
pause(4);

disp('Playing Filtered Signal...');
sound(e, fs);