% Función para redondear la señal con cierta cantidad de bits.

function redondeada = redondear(senial, bits)
	offset = abs(min(senial));
	senial = senial + offset;
	niveles = 2^bits - 1;

	redondeada = round(senial * niveles)/niveles;

	redondeada = redondeada - offset;
end


