/*----------------------------------------------------------------------------
--------------------- 1ra. Area: Codigo de Usuario
----------------------------------------------------------------------------*/

//-------> Paquete, importaciones

package Analizadores;

import java_cup.runtime.*;
import java.util.LinkedList;
import Internal.*;

/*----------------------------------------------------------------------------
--------------------- 2da. Area: Opciones y Declaraciones
----------------------------------------------------------------------------*/
%%

//-------> Codigo de Usuario
%{
    public static String ANY = "";
    public static LinkedList<Token> errores =new LinkedList<Token>();
    public static LinkedList<Token> tokens =new LinkedList<Token>();

    public  LinkedList<Token> getErrores() {
        return errores;
    }
    public  LinkedList<Token> getTokens() {
        return tokens;
    }

public int reserved(String s){
    s = s.toLowerCase();

    switch(s){
    //------------Aqui van declarados ID's de etiquetas-----------------------------
    case "compi":
        return sym.compi;
    case "cabecera":
        return sym.cabecera;
    case "titulo":
        return sym.titulo;
    case "cuerpo":
        return sym.cuerpo;
    case "parrafo":
        return sym.parrafo;
    case "salto":
        return sym.salto;
    case "tabla":
        return sym.tabla;
    case "imagen":
        return sym.imagen;
    case "textoa":
        return sym.textoa;
    case "textob":
        return sym.textob;
    case "boton":
        return sym.boton;
    case "espacio":
        return sym.espacio;
    case "fila":
        return sym.fila;
    case "columnac":
        return sym.columnac;
    case "columna":
        return sym.columna;
    case "true":
        return sym.bool;
    case "false":
        return sym.bool;

    //------------Aqui van declarados ID's de atributos
    case "fondo":
            return sym.fondo;
    case "alineacion":
        return sym.alineacion;
    case "alto":
        return sym.alto;
    case "ancho":
        return sym.ancho;
    case "path":
        return sym.path;
    case "id":
        return sym.identificador;
    case "texto":
        return sym.texto;
    case "borde":
        return sym.borde;

    //--------------Aqui empiezan las declaraciones del lenguaje script
    case "hs":
        return sym.sScript;
    case "echo":
        return sym.echo;
    case "if":
        return sym.iff;
    case "else":
        return sym.elsse;
    case "repetir":
        return sym.repeat;
    case "crearimagen":
        return sym.makeImg;
    case "crearparrafo":
        return sym.makePar;
    case "creartextoa":
        return sym.makeText1;
    case "creartextob":
        return sym.makeText2;
    case "creartabla":
        return sym.makeTable;
    case "crearboton":
        return sym.makeButton;
    //---- declaraciones del parrafo
    case "clickboton":
        return sym.click;
    case "insertar":
        return sym.insert;
    case "settexto":
        return sym.setText;
    case "gettexto":
        return sym.getText;
    case "setcontenido":
        return sym.setCont;
    case "setalineacion":
        return sym.setAl;
    case "getcontenido":
        return sym.getCont;
    case "getalineacion":
        return sym.getAl;
    case "setpath":
        return sym.setPath;
    case "setborde":
        return sym.setB;
    case "setalto":
        return sym.setHeight;
    case "setancho":
        return sym.setWidth;
    case "getpath":
        return sym.getPath;
    case "getalto":
        return sym.getHeight;
    case "getancho":
        return sym.getWidth;
    
    
    default: return sym.id;
    }
}
%}

//-------> Directivas---------------------------------------
%public
%class scanner
%cupsym sym
%cup
%char
%line
%column
%8bit
%full
%unicode
%ignorecase

//-------> Expresiones Regulares--------------------------------------------------------
digito = [0-9]
numero =  [0-9]*\.?[0-9]+
cadena =[\"] [^\"\n]* [\"\n]
letra = [a-zA-ZñÑ]
espacio = \t|\f|" "|\r|\n
id = {letra}+({letra}|{digito}|"_")*


//-------> Estados    EN ORDEN
%state COMENT_MULTI
%state COMENT_MULTIS
%state COMENT_SIMPLE
%state INSIDE_LABEL
%state SCRIPT
%%

/*-------------------------------------------------------------------
--------------------- 3ra. y ultima area: Reglas Lexicas
-------------------------------------------------------------------*/

//-------> Comentarios

<YYINITIAL,INSIDE_LABEL> "<!"                {yybegin(COMENT_MULTI);}     // Si la entrada es un comentario inicia aqui
<COMENT_MULTI> "!>"             {yybegin(YYINITIAL);}        // Si se acaba el comentario vuelve a YYINITIAL
<COMENT_MULTI> .                {}
<COMENT_MULTI> [ \t\r\n\f]      {}


<SCRIPT> "//"                {yybegin(COMENT_SIMPLE);}   // Si la entrada es comentario simple inicia aqui
<COMENT_SIMPLE> [^"\n"]         {}                          // 
<COMENT_SIMPLE> "\n"            {yybegin(SCRIPT);}       // aqui sale del estado


//-------> Empieza el lenguaje Script

<YYINITIAL> "?hs"              {yybegin(SCRIPT); 
                                Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Start Script", "");
                                tokens.add(temp);
                                return new Symbol(sym.sScript, yycolumn, yyline, yytext());
                               }     // Si la entrada es un comentario inicia aqui
<SCRIPT> "?"                { yybegin(YYINITIAL);
                            System.out.println("Reconocido: <<"+yytext()+">>, interrogacion cerrar");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "interrogacion cerrar", "");
                            tokens.add(temp);
                            return new Symbol(sym.closeQuestion, yycolumn, yyline, yytext());
                                }

<SCRIPT> "/*"                   {yybegin(COMENT_MULTIS);}     // Si la entrada es un comentario inicia aqui
<COMENT_MULTIS> "*/"             {yybegin(SCRIPT);}        // Si se acaba el comentario vuelve a YYINITIAL
<COMENT_MULTIS> .                {}
<COMENT_MULTIS> [ \t\r\n\f]      {}

//-------> sym------------------------------------------------------------


<SCRIPT> ";"         {   System.out.println("Reconocido: <<"+yytext()+">>, Punto y coma");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Punto y coma", "");
                                tokens.add(temp);
                            return new Symbol(sym.semicolon, yycolumn, yyline, yytext());
                     }

<SCRIPT> "#"         {   System.out.println("Reconocido: <<"+yytext()+">>, Numeral");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Numeral", "");
                            tokens.add(temp);
                            return new Symbol(sym.hashtag, yycolumn, yyline, yytext());
}

<SCRIPT> "{"         {   System.out.println("Reconocido: <<"+yytext()+">>, corchetes abiertos");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "corchetes abiertos", "");
                                tokens.add(temp);
                                return new Symbol(sym.openCB, yycolumn, yyline, yytext());}

<SCRIPT> "}"         {   System.out.println("Reconocido: <<"+yytext()+">>, corchetes cerrados");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "corchetes cerrados", "");
                                tokens.add(temp);
                                return new Symbol(sym.closeCB, yycolumn, yyline, yytext());}

<SCRIPT> "["         {   System.out.println("Reconocido: <<"+yytext()+">>, llaves abiertas");
                            
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "llaves abiertas", "");
                                tokens.add(temp);
                                return new Symbol(sym.openB, yycolumn, yyline, yytext());}

<SCRIPT> "]"         {   System.out.println("Reconocido: <<"+yytext()+">>, llaves cerradas");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "llaves cerradas", "");
                                tokens.add(temp);
                                return new Symbol(sym.closeB, yycolumn, yyline, yytext());}

<SCRIPT> "("         {   System.out.println("Reconocido: <<"+yytext()+">>, Parentesis Abierto");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Parentesis Abierto", "");
                                tokens.add(temp);
                                return new Symbol(sym.openPar, yycolumn, yyline, yytext());}

<SCRIPT> ")"         {   System.out.println("Reconocido: <<"+yytext()+">>, Parentesis Cerrado");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Parentesis Cerrado", "");
                                tokens.add(temp);
                                return new Symbol(sym.closePar, yycolumn, yyline, yytext());}

<SCRIPT> "&"         {   System.out.println("Reconocido: <<"+yytext()+">>, And Logico");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "And Logico", "");
                                tokens.add(temp);
                                return new Symbol(sym.and, yycolumn, yyline, yytext());}

<SCRIPT> "|"         {   System.out.println("Reconocido: <<"+yytext()+">>, Or Logico");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Or Logico", "");
                                tokens.add(temp);
                                return new Symbol(sym.or, yycolumn, yyline, yytext());}

<SCRIPT> "!"         {   System.out.println("Reconocido: <<"+yytext()+">>, Admiracion Cerrar");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Admiracion Cerrar", "");
                                tokens.add(temp);
                                return new Symbol(sym.closeAdm, yycolumn, yyline, yytext());}

<SCRIPT> "."         {   System.out.println("Reconocido: <<"+yytext()+">>, Punto");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), " Punto", "");
                                tokens.add(temp);
                                return new Symbol(sym.point, yycolumn, yyline, yytext());}

<SCRIPT> ","         {   System.out.println("Reconocido: <<"+yytext()+">>, Coma");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Coma", "");
                                tokens.add(temp);
                                return new Symbol(sym.comma, yycolumn, yyline, yytext());}

<SCRIPT> "$"         {   System.out.println("Reconocido: <<"+yytext()+">>, Dolar");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Dolar", "");
                                tokens.add(temp);
                                return new Symbol(sym.dollar, yycolumn, yyline, yytext());}


<YYINITIAL, SCRIPT> "="         {   System.out.println("Reconocido: <<"+yytext()+">>, igual");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "igual", "");
                                tokens.add(temp);
                                return new Symbol(sym.equal, yycolumn, yyline, yytext());}

<YYINITIAL, SCRIPT> "/"         {   System.out.println("Reconocido: <<"+yytext()+">>, dividir");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "dividir", "");
                                tokens.add(temp);
                                return new Symbol(sym.slash, yycolumn, yyline, yytext());}

<INSIDE_LABEL> "<"           {   
                                            yybegin(YYINITIAL);
                                            System.out.println("Reconocido: <<"+yytext()+">>, Menor que");
                                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Menor que", "");
                                tokens.add(temp);
                                return new Symbol(sym.lessThan, yycolumn, yyline, yytext());
                                        }

<YYINITIAL> "<"                         {     
                                            System.out.println("Reconocido: <<"+yytext()+">>, Menor que");
                                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), " Menor que", "");
                                tokens.add(temp);
                                return new Symbol(sym.lessThan, yycolumn, yyline, yytext());
                                        }


<YYINITIAL> ">"                          { 
                                            yybegin(INSIDE_LABEL);
                                            System.out.println("Reconocido: <<"+yytext()+">>, Mayor que");
                                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Mayor que", "");
                                tokens.add(temp);
                                return new Symbol(sym.greaterThan, yycolumn, yyline, yytext());
                                        }

<SCRIPT> "<"                            {   
                                            System.out.println("Reconocido: <<"+yytext()+">>, Menor que");
                                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), " Menor que", "");
                                tokens.add(temp);
                                return new Symbol(sym.lessThan, yycolumn, yyline, yytext());
                                        }


<SCRIPT> ">"                            { 
                                            System.out.println("Reconocido: <<"+yytext()+">>, Mayor que");
                                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Mayor que", "");
                                tokens.add(temp);
                                return new Symbol(sym.greaterThan, yycolumn, yyline, yytext());
                                        }

<SCRIPT> "=="                            { 
                                            System.out.println("Reconocido: <<"+yytext()+">>, Igual Igual");
                                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Igual Igual", "");
                                tokens.add(temp);
                                return new Symbol(sym.equalequal, yycolumn, yyline, yytext());
                                         }
<SCRIPT> "<="                            { 
                                            System.out.println("Reconocido: <<"+yytext()+">>, Menor Igual");
                                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Menor Igual", "");
                                tokens.add(temp);
                                return new Symbol(sym.lessequal, yycolumn, yyline, yytext());
                                         }       
  
<SCRIPT> ">="                            { 
                                            System.out.println("Reconocido: <<"+yytext()+">>, Mayor Igual");
                                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Mayor Igual", "");
                                tokens.add(temp);
                                return new Symbol(sym.greaterequal, yycolumn, yyline, yytext());
                                        }

<SCRIPT> "!="                            { 
                                            System.out.println("Reconocido: <<"+yytext()+">>, Diferente");
                                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "Diferente", "");
                                tokens.add(temp);
                                return new Symbol(sym.notequal, yycolumn, yyline, yytext());
                                        }

//------------> sym expresiones regulares--------------------------------------------------------------

<YYINITIAL, SCRIPT>  {numero}    {   System.out.println("Reconocido: <<"+yytext()+">>, numero ");
                                Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "numero", "");
                                tokens.add(temp);
                                return new Symbol(sym.number, yycolumn, yyline, yytext());}

<YYINITIAL, SCRIPT> {cadena}                {   System.out.println("Reconocido: <<"+yytext()+">>, cadena ");
                                Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "cadena", "");
                                tokens.add(temp);
                                return new Symbol(sym.cadena, yycolumn, yyline, yytext());}

<YYINITIAL,SCRIPT> {id}         {   System.out.println("Reconocido: <<"+yytext()+">>, id ");
                                Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "id | palabra reservada", "");
                                tokens.add(temp);
                                return new Symbol(reserved(yytext()), yycolumn, yyline, yytext());}

<YYINITIAL,SCRIPT> {espacio}                 {/* ignore white space. */ }

<INSIDE_LABEL> [\t]      {}

<INSIDE_LABEL> .                {  System.out.println("Reconocido: <<"+yytext()+">>, Cuerpo de Etiqueta ");
                                    return new Symbol(sym.any, yycolumn, yyline, yytext());}

<INSIDE_LABEL> [ \r\n\f]        {System.out.println("Reconocido: <<"+yytext()+">>, Cuerpo de Etiqueta ");
                                    return new Symbol(sym.any, yycolumn, yyline, yytext());}

//--------------------- Lenguaje Script 


<SCRIPT> "+"         {   System.out.println("Reconocido: <<"+yytext()+">>, mas");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "mas", "");
                                tokens.add(temp);
                                return new Symbol(sym.plus, yycolumn, yyline, yytext());}

<SCRIPT> "-"         {   System.out.println("Reconocido: <<"+yytext()+">>, menos");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "menos", "");
                                tokens.add(temp);
                                return new Symbol(sym.minus, yycolumn, yyline, yytext());}

<SCRIPT> "*"         {   System.out.println("Reconocido: <<"+yytext()+">>, por");
                            Token temp = new Token((yyline+1), (yycolumn+1), yytext(), "por", "");
                                tokens.add(temp);
                                return new Symbol(sym.by, yycolumn, yyline, yytext());}

 //------------> Errores Lexicos------------------------------------------------------------------------------
<YYINITIAL,SCRIPT>  .       {   System.out.println("Error Lexico: <<"+yytext()+">> ["+yyline+" , "+yycolumn+"]");
                                Token error = new Token((yyline+1), (yycolumn+1), yytext(), "Error Lexico", "Simbolo no existe en el lenguaje");
                                errores.add(error);
                            }