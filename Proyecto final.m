clc; clear;

% --- Datos de entrada ---
H = 5;               % Espesor de la capa de consolidación [m]
t = 2 * 365 * 24 * 3600;  % Tiempo deseado en segundos (ej: 2 años)
Tv_target = 0.197;   % Tiempo adimensional para 50% de consolidación
Sf = 0.05;           % Asentamiento final esperado [m]

% Tolerancia y parámetros para Newton-Raphson
tol = 1e-6;
max_iter = 100;
Cv_guess = 1e-7;     % Suposición inicial para Cv [m^2/s]

% --- Método de Newton-Raphson ---
Cv = Cv_guess;

for i = 1:max_iter
    f = (Cv * t) / H^2 - Tv_target;
    df = t / H^2;  % Derivada de f respecto a Cv

    Cv_new = Cv - f / df;

    if abs(Cv_new - Cv) < tol
        break;
    end

    Cv = Cv_new;
end

% Verificar convergencia
if i == max_iter
    warning('Newton-Raphson no convergió');
end

% Calcular asentamiento actual
U = 0.5;  % 50% de consolidación
S = U * Sf;

% --- Resultados ---
fprintf('Coeficiente de consolidación Cv = %.3e m^2/s\n', Cv);
fprintf('Asentamiento a t = %.2f años es: %.4f m\n', t/(365*24*3600), S);

% --- Gráfica de asentamiento vs. tiempo ---
t_anos = linspace(0, 2, 100);  % Tiempo de 0 a 2 años
t_seg = t_anos * 365 * 24 * 3600;  % Convertir a segundos

Tv = (Cv .* t_seg) / H^2;      % Tiempo adimensional
U_t = 1 - exp(-pi^2 * Tv);     % Aproximación para grado de consolidación (primera solución de Terzaghi)
S_t = U_t * Sf;                % Asentamiento instantáneo

% Crear gráfica
figure;
plot(t_anos, S_t, 'b', 'LineWidth', 2);
xlabel('Tiempo ');
ylabel('Asentamiento ');
title('Asentamiento ');
grid on;
xlim([0 2]);
ylim([0 Sf*1.1]);
