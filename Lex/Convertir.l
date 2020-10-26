%{
// Paula Villanueva Nuñez

#include <stdio.h>
#include <string.h>

void seccion (char* cadena, int longitud, int tipo);// Convertir sección
void negrita (char* cadena, int longitud);          // Convertir negrita
void subrayado (char* cadena, int longitud);        // Convertir subrayado
void cursiva (char* cadena, int longitud);          // Convertir cursiva
void tachado (char* cadena, int longitud);          // Convertir tachado
void titulo (char* cadena, int longitud);           // Convertir título
void eliminar (char* cadena, int longitud);         // Eliminar caracteres inútiles
void lista (char* cadena, int longitud);            // Convertir lista con items
void autor (char* cadena, int longitud);            // Convertir autor
void fecha (char* cadena, int longitud);            // Convertir fecha
void ecuacion (char* cadena, int longitud);         // Convertir ecuación
void link_href (char* cadena, int longitud);        // Convertir link con descripción
void link_url (char* cadena, int longitud);         // Convertir link sin descripción
void imagen (char* cadena, int longitud);           // Convertir imagen
%}

%%
    /* Sección de Reglas */

    /* Paquetes */
"\\usepackage"[^"}"]*"}"\n    {eliminar(yytext, yyleng);}
"\\documentclass{"[^"}"]*"}"\n {eliminar(yytext, yyleng);}

    /* Empezar o terminar documento */
("\\begin{document}"|"\\end{document}")\n     {eliminar(yytext, yyleng);}

    /* Título principal */
"\\title{"[^"}"]*"}"   {titulo(yytext, yyleng);}
"\\maketitle"\n   {eliminar(yytext, yyleng);}

    /* Fecha */
"\\date{"[^"}"]*"}"   {fecha(yytext, yyleng);}

    /* Autor */
"\\author{"[^"}"]*"}"   {autor(yytext, yyleng);}

    /* Secciones */
"\\subsubsection{"[^"}"]*"}"   {seccion(yytext, yyleng, 4);}
"\\subsection{"[^"}"]*"}"  {seccion(yytext, yyleng, 3);}
"\\section{"[^"}"]*"}"     {seccion(yytext, yyleng, 2);}

    /* Negrita */
"\\textbf{"[^"}"]*"}"  {negrita(yytext, yyleng);}

    /* Subrayado */
"\\underline{"[^"}"]*"}"  {subrayado(yytext, yyleng);}

    /* Cursiva */
"\\textit{"[^"}"]*"}"   {cursiva(yytext, yyleng);}

    /* Tachado */
"\\textst{"[^"}"]*"}"    {tachado(yytext, yyleng);}

    /* Comentarios */
"%"[^\n]*\n {eliminar(yytext, yyleng);}

    /* Lista de items */
"\\begin{itemize}"\n    {eliminar(yytext, yyleng);}
"\\end{itemize}"\n  {eliminar(yytext, yyleng);}
"\\item "   {lista(yytext, yyleng);}

    /* Ecuaciones */
"\\begin{equation}"\n    {ecuacion(yytext, yyleng);}
\n"\\end{equation}"\n     {ecuacion(yytext, yyleng);}
    
    /* Links */
"\\href{"[^"}"]*"}{"[^"}"]*"}"  {link_href(yytext, yyleng);}
"\\url{"[^"}"]*"}"  {link_url(yytext, yyleng);}

    /* Imágenes */
"\\includegraphics{"[^"}"]*"}"  {imagen(yytext, yyleng);}

%%
    /* Sección de Procedimientos */
int main (int argc, char* argv[]){
    if (argc == 1){
        printf("Error en los argumentos\n");
        exit(-1);
    }

    // Abro el archivo latex para leer
    yyin = fopen("Ejemplo_latex.tex", "rt");

    // Si no se ha podido abrir el archivo
    if (yyin == NULL){
        printf("Error: no se pudo abrir el fichero %s\n", argv[1]);
        exit(-1);
    }

    printf("Se empieza a traducir\n");

    // Abro el archivo markdown para escribir
    yyout = fopen("Ejemplo_md.md", "w");

    yylex();

    return 0;
}   

// Titulo: \title{Titulo}
void titulo (char* cadena, int longitud){
    char resultado[100];
    int j = 0, i = 0;

    // Encabezado del título
    for (j = 0; j < 3; j++)
        resultado[j] = '-';

    resultado[j] = '\n';

    j++;

    // Copio la palabra title
    for (i = 1; cadena[i] != '{'; i++, j++){
        resultado[j] = cadena[i];
    }

    // Pongo el formato
    resultado[j] = ':';
    j++;
    resultado[j] = ' ';
    j++;

    // Copio el título
    for (i++; cadena[i] != '}'; i++, j++)
        resultado[j] = cadena[i];

    resultado[j] = '\0';

    fprintf(yyout, "%s\n", resultado);
}

// Seccion: \section{Seccion}, \subsection{Seccion}...
void seccion (char* cadena, int longitud, int tipo){
    char resultado[longitud], resultado2[longitud];
    int j = 0, i = 0;

    // Copio la cadena en resultado
    strcpy(resultado, cadena);

    // Añado el formato de la sección según el tipo
    for (j = 0; j < tipo; j++){
        resultado2[j] = '#';
    }

    resultado2[j] = ' ';
    j++;

    // Avanzo hasta donde está el texto
    while (resultado[i] != '{')
        i++;

    // Copio el texto de la sección
    for (i++; resultado[i] != '}'; i++, j++)
        resultado2[j] = resultado[i];
    
    resultado2[j] = '\0';

    fprintf(yyout, "%s\n", resultado2);
}

// Fecha: \date{Fecha}
void fecha (char* cadena, int longitud){
    char resultado[2*longitud];
    int j = 0, i = 0;

    // Copio el formato de fecha
    for (i = 1; cadena[i] != '{'; i++, j++){
        resultado[j] = cadena[i];
    }

    resultado[j] = ':';
    j++;
    resultado[j] = ' ';
    j++;

    // Copio el texto de la fecha
    for (i++; cadena[i] != '}'; i++, j++){
        resultado[j] = cadena[i];
    }

    resultado[j] = '\n';
    j++;

    // Termino el encabezado
    for (int i = 0; i < 3; i++, j++)
        resultado[j] = '-';

    resultado[j] = '\0';

    fprintf(yyout, "%s\n", resultado);
}

// Negrita: \textbf{Texto}
void negrita (char* cadena, int longitud){
    char resultado[longitud];
    int j = 0, i = 0;

    // Copio el formato
    for (; j < 2; j++)
        resultado[j] = '*';
    
    // Avanzo hasta donde empieza el texto
    while (cadena[i] != '{')
        i++;

    // Copio el texto en negrita
    for (i++; cadena[i] != '}'; i++, j++){
        resultado[j] = cadena[i];
    }

    // Copio el formato
    for (i = 0; i < 2; i++, j++)
        resultado[j] = '*';

    resultado[j] = '\0';

    fprintf(yyout, "%s", resultado);
}

// Subrayado: \underline{Texto}
void subrayado (char* cadena, int longitud){
    char resultado[50];
    int j = 0, i = 0;

    // Copio el formato
    for (; j < 2; j++)
        resultado[j] = '_';
    
    // Avanzo hasta donde empieza el texto
    while (cadena[i] != '{')
        i++;

    // Copio el texto subrayado
    for (i++; cadena[i] != '}'; i++, j++){
        resultado[j] = cadena[i];
    }

    // Copio el formato
    for (i = 0; i < 2; i++, j++)
        resultado[j] = '_';

    resultado[j] = '\0';

    fprintf(yyout, "%s", resultado);
}

// Cursiva: \textit{Texto}
void cursiva (char* cadena, int longitud){
    char resultado[50];
    int j = 0, i = 0;

    // Copio el formato
    resultado[j] = '_';
    j++;

    // Avanzo hasta donde empieza el texto
    while (cadena[i] != '{')
        i++;

    // Copio el texto en cursiva
    for (i++; cadena[i] != '}'; i++, j++){
        resultado[j] = cadena[i];
    }

    // Copio el formato
    resultado[j] = '_';
    j++;
    resultado[j] = '\0';

    fprintf(yyout, "%s", resultado);
}

// Tachado: \textst{Texto}
void tachado (char* cadena, int longitud){
    char resultado[50];
    int j = 0, i = 0;
    
    // Copio el formato
    for (; j < 2; j++)
        resultado[j] = '~';

    // Avanzo hasta donde empieza el texto
    while (cadena[i] != '{')
        i++;

    // Copio el texto tachado
    for (i++; cadena[i] != '}'; i++, j++)
        resultado[j] = cadena[i];

    // Copio el formato
    for (i = 0; i < 2; i++, j++)
        resultado[j] = '~';

    resultado[j] = '\0';

    fprintf(yyout, "%s", resultado);
}

// Eliminar caracteres inutiles
void eliminar (char* cadena, int longitud){}

// Lista: \item
void lista (char* cadena, int longitud){
    // Formato de la lista
    fprintf(yyout, "- ");
}

// Ecuacion: \begin{equation} ECUACION \end{equation}
void ecuacion (char* cadena, int longitud){
    // Formato de la ecuación
    fprintf(yyout, "$$");
}

// Autor: \author{Autor}
void autor (char* cadena, int longitud){
    char resultado[50];
    int j = 0, i = 0;

    // Copio el formato del autor
    for (i = 1; cadena[i] != '{'; i++, j++){
        resultado[j] = cadena[i];
    }

    resultado[j] = ':';
    j++;
    resultado[j] = ' ';
    j++;

    // Copio el texto del autor
    for (i++; cadena[i] != '}'; i++, j++)
        resultado[j] = cadena[i];

    resultado[j] = '\0';

    fprintf(yyout, "%s\n", resultado);
}

// Link: \href{Link}{Descripcion}
void link_href (char* cadena, int longitud){
    char c_url[longitud], c_descr[longitud], resultado[longitud];
    int i = 0, j = 0, k = 0;

    // Avanzo hasta donde empieza el link
    while (cadena[i] != '{')
        i++;

    // Copio el link
    for (i++; cadena[i] != '}'; i++, j++)
        c_url[j] = cadena[i];

    c_url[j] = '\0';

    // Copio la descripción
    for (j = 0, i = i + 2; (cadena[i] != '}') || (i<longitud -1); i++, j++)
        c_descr[j] = cadena[i];
    
    c_descr[j] = '\0';
    resultado[k] = '[';
    resultado[k+1] = '\0';

    strcat(resultado, c_descr);

    k = 0;

    // Calculo longitud
    while (resultado[k] != '\0')
        k++;

    resultado[k] = ']';
    k++;
    resultado[k] = '(';
    k++;
    resultado[k] = '\0';

    strcat(resultado, c_url);

    // Calculo longitud
    while (resultado[k] != '\0')
        k++;

    resultado[k] = ')';
    k++;
    resultado[k] = '\0';

    fprintf(yyout, "%s", resultado);
}

// Link: \url{Link}
void link_url (char* cadena, int longitud){
    char c_url[longitud];
    int i = 0, j = 0, k = 0;

    // Avanzo hasta donde empieza el link
    while (cadena[i] != '{')
        i++;

    // Copio el link
    for (i++; cadena[i] != '}'; i++, j++)
        c_url[j] = cadena[i];

    c_url[j] = '\0';

    fprintf(yyout, "%s", c_url);
}

// Imagen: \includegraphics{Imagen}
void imagen (char* cadena, int longitud){
    char c_url[longitud], resultado[] = "![](";
    int i = 0, j = 0;

    // Avanzo hasta donde empieza la imagen
    while (cadena[i] != '{')
        i++;

    // Copio el formato
    c_url[j] = '.';
    j++;
    c_url[j] = '/';
    j++;
    
    // Copio el link
    for (i++; cadena[i] != '}'; i++, j++)
        c_url[j] = cadena[i];

    c_url[j] = ')';
    j++;
    c_url[j] = '\0';

    fprintf(yyout, "%s%s\n", resultado, c_url);
}