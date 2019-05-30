
function [a,G] = funcionlpc(senial_w, cant_coefs)
	M = cant_coefs;
	r = xcorr(senial_w);
	r_utiles = r(round(end/2):round(end/2+M));
	r0 = r_utiles(1);
	R = toeplitz(r_utiles(1:M-1));
	r = r_utiles(2:M);

	a = inv(R)*r;		% Calculo los coeficientes
	G = sqrt(r0 - a' * r); 
end
