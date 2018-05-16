data Entradas;
input Nome$12. Tipo$ Categoria$ Preco ValorTotal ;
cards;
Produto1XXXX Consumo Cat1 150 300
Produto2XXXX Consumo Cat2 450 900
Produto3XXXX Consumo Cat3 250 500
Produto4XXXX Venda Cat4 350 700
Produto5XXXX Venda Cat5 550 110
Produto6XXXX Venda Cat6 150 300
;
run;



%macro ProjetoMacro(INPUT_DATA, VAR_CHAR, VAR_NUM);

/*
Cria a tabela METADADOS na WORK contendo, para cada campo da tabela definida em INPUT_DATA:
Nome, Label, Tipo (character / numérico), Length */

proc contents data=&INPUT_DATA. 
out= METADADOS;
title 'Contents da tabela Entradas';
run;	

/*Quantidade de registros da tabela de input*/

proc sql;
title 'Quantidade de registros da tabela de input';
select count(*) from &INPUT_DATA.;
quit;

/* Quantidade de campos numéricos e a quantidade de campos character da tabela de input */ 
proc summary data=METADADOS (where=(type=1)) print;
title 'Quantidade de campos numéricos da tabela de input';
run;

proc summary data=METADADOS (where=(type=2)) print;
title 'Quantidade de campos character da tabela de input';
run;

/* Quantidade de campos character da tabela de input que possuem length > 10 */

proc summary data=METADADOS (where=(type=2 and length > 10)) print;
title 'Quantidade de campos character da tabela de input que possuem length > 10';
run;

/* Média, desvio-padrão, mínimo e máximo de todos os campos definidos no parâmetro VAR_NUM */
proc means data=&INPUT_DATA. mean std min max;
var &VAR_NUM.;
title 'Média, desvio-padrão, mínimo e máximo';
run;

/* Os histogramas de todos os campos definidos no parâmetros VAR_NUM */
proc univariate data=&INPUT_DATA. ;
hist &VAR_NUM.;
title 'Histogramas de todos os campos numericos ';
run;

/* As distribuições de frequência dos campos definidos no parâmetro VAR_CHAR */ 
proc freq data= &INPUT_DATA.;
table &VAR_CHAR. / nopct norow nocol;
title 'Distribuições de frequência dos campos caracter';
run;

%Put Parcipantes: Giorgi Medeiros, Jefferson Pereira, Luiz Pereira;

%mend ProjetoMacro;

%ProjetoMacro(Entradas, Nome Categoria Tipo,Preco ValorTotal)
