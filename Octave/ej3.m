%% eje3.m
% LPC codificación

clear all
close all
%graphics_toolkit('gnuplot');

[x,Fs] = audioread('fantasia.wav');

W = round(0.025*Fs); % La ventana mide 0.025 segundos, W es el tamaño de la venta
D = round(0.010*Fs); % Los coeficientes son los que están dentro de los 10ms pero el cálculo de los mismos son con W.

M = 20;

% Calcular la cantidad de pasos a realizar:
Lpasos = ceil(length(x)/D);
auxx=ceil(length(x)/W)*W-length(x); % Agrego los ceros que faltan
x = [x; zeros(auxx, 1)];

% Cálculo de los coeficientes ai y el error
za = [];
zb = [];
e_10ms = [];
xresint_10ms = [];
for n = 1:Lpasos
		senial_25msec = x((n-1)*D+1:((n-1)*D+W));
		senial_10msec = x((n-1)*D+1:((n-1)*D+D));
		ai(:,n) = funcionlpc(senial_25msec, M);		% Calculo lpc con 25ms
		[e,za] = filter([1; -ai(:,n)], 1, senial_10msec,za); %Corresponde al 10ms
		[xres, zb] = filter(1, [1; -ai(:,n)], e, zb);
		e_10ms = [e_10ms e];
		xresint_10ms = [xresint_10ms xres];
end

%% Plot de señal original y error
e = e_10ms(:);
t_e = linspace(0, (length(e)-1)/Fs, length(e));
t_x = linspace(0, (length(x)-1)/Fs, length(x));

figure
hold on
plot(t_x,x)
plot(t_e,e, 'r')
%legend('Señal original', 'Señal de error')
legend('Senal original', 'Senal de error')
xlabel('Tiempo [s]')
ylabel('Amplitud')


%% Reconstrucción de la señal original
%1) Codificación del error: floting point (verificación)

% Plot de señal original y señal reconstruida (verificar que sean exactamente iguales)
% Comentario: El cálculo se realizó dentro del mismo for que buscó los coeficientes y la señal de error

xres = xresint_10ms(:);
t_res = linspace(0, (length(xres)-1)/Fs, length(xres));
t_x = linspace(0, (length(x)-1)/Fs, length(x));

figure
hold on
plot(t_x,x)
plot(t_res,xres, 'r')
%legend('Señal original', 'Señal reconstruida')
legend('Senal original', 'Senal reconstruida')
xlabel('Tiempo [s]')
ylabel('Amplitud')



%% 2) Repetir para codificación del error en 16bits, 8 bits
e16bits = redondear(e_10ms, 16);
e8bits = redondear(e_10ms, 8);

za = [];
zb = [];
xresint16_10ms = [];
xresint8_10ms = [];
for n = 1:Lpasos
		[xres16, za] = filter(1, [1; -ai(:,n)], e16bits(:,n), za);
		[xres8, zb] = filter(1, [1; -ai(:,n)], e8bits(:,n), zb);
		xresint16_10ms = [xresint16_10ms xres16];
		xresint8_10ms = [xresint8_10ms xres8];
end


%% Plot error con diferentes cuantizaciones
figure
hold on
plot(t_e, e16bits(:))
plot(t_e, e8bits(:), 'r')
legend('Error - 16 Bits', 'Error - 8 Bits')
xlabel('Tiempo [s]')
ylabel('Amplitud')




%% Plot señal original y diferentes reconstrucciones.

figure
hold on
plot(t_x,x)
plot(t_res,[xresint8_10ms(:) xresint16_10ms(:)], '--')
%legend('Señal original', 'Redondeo 8 bits', 'Redondeo 16 bits')
legend('Senal original', 'Redondeo 8 bits', 'Redondeo 16 bits')
xlabel('Tiempo [s]')
ylabel('Amplitud')

