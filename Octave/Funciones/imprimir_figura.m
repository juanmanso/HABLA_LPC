
% Función auxiliar para imprimir "más rápido" las figuras

function [] = imprimir_figura(nombre)

%	set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5.9 0]);
	set(get(gca,'ylabel'),'rotation',90);

	format_out_name=".tex";			% Configuro el formato de impresión
%	format_out_name=".png";			% Configuro el formato de impresión
%	format_out_name=".pdf";			% Configuro el formato de impresión
	format_print_config="-depslatex";	% Idem
%	format_print_config="-dpng";	% Idem
	format_print_config="-dpdflatex";	% Idem
	print_path="./graf_";	% Ruta de salida

	print([print_path,nombre,format_out_name],format_print_config, "-color");
%	print(gcf,[print_path,nombre,format_out_name],format_print_config);

endfunction
