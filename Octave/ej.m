%% Análisis de una única ventana

clear all
close all
graphics_toolkit('gnuplot');
imprimir=1;

[x,Fs] = audioread('fantasia.wav');

W = round(0.025*Fs); % La ventana mide 0.025 segundos, W es el tamaño de la venta
D = round(0.010*Fs); % Los coeficientes son los que están dentro de los 10ms pero el cálculo de los mismos son con W.

M = 20;

primerSonido=14e3;
x_vent = x(primerSonido:primerSonido+W);

%% Cálculo de coeficientes LPC
[a, G] = funcionlpc(x_vent, M);

% Para chequear que están bien los coeficientes
% usar x_estimada=filter(a, 1, x_vent)
x_est = filter([0; a], 1, x_vent);
err = filter([1;-a],1,x_vent);

t_e = linspace(0, (length(err)-1)/Fs, length(err));
t_x = linspace(0, (length(x_vent)-1)/Fs, length(x_vent));
t_est = linspace(0, (length(x_est)-1)/Fs, length(x_est));
w = linspace(0,2*pi, 1024)*Fs/(2*pi);

% Comparación de las señales
if(imprimir)
	figure
	hold on
	grid minor
	plot(t_x, x_vent)
	plot(t_est, x_est, 'r')
	xlabel('Tiempo [s]')
	ylabel('Amplitud')
	Hleg = legend(['Original'; 'Reconstruida'], 'location','NorthEast');
		legend('boxon');
%		set(Hleg,'FontName','Arial','FontSize',8);
	axis([0 t_x(end), -0.5 0.5])
%	set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5.9 0]);
	set(get(gca,'ylabel'),'rotation',90);
end


% Gráfico del error
if(imprimir)
	figure
	hold on
%	plot(x_vent-x_est)
	plot(t_e,err)
	xlabel('Tiempo [s]')
	ylabel('Amplitud')
	Hleg = legend(['Error'], 'location','NorthEast');
		legend('boxon');
%		set(Hleg,'FontName','Arial','FontSize',8);
%	set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5.9 0]);
	set(get(gca,'ylabel'),'rotation',90);
	axis tight
	grid minor
end

close all
%% Grafico la fft
[H, f] = freqz(1,[1; -a]);
fft_a = abs(fft(x_vent,1024));

figure
hold on
plot(w(1:end/2),fft_a(1:end/2))
plot(w(1:end/2),abs(H),'r')
%title('Envolente')

%% Calcular la cantidad de pasos a realizar:
Lpasos = ceil(length(x)/D);
auxx=ceil(length(x)/W)*W-length(x); % Agrego los ceros que faltan
x = [x; zeros(auxx, 1)];

%% For para almacenar los coeficientes ai en una matriz
for n = 1:Lpasos
		senial_w = x((n-1)*D+1:((n-1)*D+W));
		ai(:,n) = funcionlpc(senial_w, M);
end

%% Calcular el espectro de la envolvente a partir de los coeficientes ai de cada frame:
for n = 1:size(ai,2),
		[Henv(:,n),w] = freqz(1, [1; -ai(:,n)]);
end

%% Graficar espectro envolvente
figure
t = (1:Lpasos);
tiempo_audio = length(x)/Fs;
t = (t-1)/Lpasos*tiempo_audio;
w = w*Fs/(2*pi);
s = pcolor(t, w,10*log(abs(Henv)));
shading interp
ylabel('Frecuencia [Hz]')
xlabel('Tiempo [s]')
axis([0, t(end)])
zlabel('Envolvente')


%% Graficar espectrograma
figure
specgram(x,W,Fs)


%% Graficar espectros superpuesto de las 4 vocales en la señal (un frame por vocal)
%% Identificar los picos, y realizar comentarios sobre la posición relacionado a la práctica de fonética.
% Del gráfico hayo que las vocales son para t= 69, 90, 122 y 135
figure
plot(w, (abs([Henv(:,69), Henv(:,90), Henv(:,122), Henv(:,135)])))
legend('fAn', 'tA', 'sÍ', 'A')
xlabel('Frecuencia [Hz]')
ylabel('Amplitud')
legend('boxon');
set(get(gca,'ylabel'),'rotation',90);
%axis tight
grid minor





close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Visualización del ej3 con 1 ventana %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
err = err(:);
err4 = redondear(err, 4);
err8 = redondear(err, 8);
err16 = redondear(err,16);
x_est4 = filter(1, [1; -a], err4);
x_est8 = filter(1, [1; -a], err8);
x_est16 = filter(1, [1; -a], err16);

t_e = linspace(0, (length(err)-1)/Fs, length(err));
t_x = linspace(0, (length(x_vent)-1)/Fs, length(x_vent));
t_est = linspace(0, (length(x_est)-1)/Fs, length(x_est));
todos = [x_est x_est4(:) x_est8(:) x_est16(:)];

% Gráfico de la señal original y las reconstrucciones
figure
hold on
plot(t_x, x_vent, 'LineWidth', 2)
plot(t_est, todos , '--')
legend('Señal original', 'Sin redondeo', 'Redondeo 4 bits', 'Redondeo 8 bits', 'Redondeo 16 bits', 'location','Southwest')
xlabel('Tiempo [s]')
ylabel('Amplitud')
axis([0 max(t_x(:)), min([x_vent(:); todos(:)]) max([x_vent(:); todos(:)])])
grid minor

% Gráfico de los errores
figure
hold on
%plot(t_e, err(:))
%plot(t_e, [err8(:), err16(:)], '--')
plot(t_est, todos-x_vent , '-')
lngd = legend('Error sin redondeo', 'Error - 4 Bits', 'Error - 8 Bits', 'Error - 16 Bits');
xlabel('Tiempo [s]')
ylabel('Amplitud')
grid minor
axis tight




