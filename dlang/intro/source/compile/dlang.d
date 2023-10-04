module compile.dlang;

/*
Introduction

master Contents [hide]
       Phases of Compilation
       Memory Model
       Object Model
Arithmetic

D is a general-purpose systems programming language with a 
C-like syntax that compiles to native code. It is statically 
typed and supports both automatic (garbage collected) and 
manual memory management. D programs are structured as modules 
that can be compiled separately and linked with external 
libraries to create native libraries or executables.

This document is the reference manual for the D Programming 
Language. For more information and other documents, see The 
D Language Website.
*/
@property void compile(dlang)(ref guile, language, terminate, program)
{

    void dlang(
         delegate guile,
         delegate language,
         delegate terminate,
         delegate program)
         {
                                       
            interface A1
            {
                delegate guile;
                delegate language;
                delegate terminate;
                delegate program;
            }

            interface A2
            {
                delegate guile;
                delegate language;
                delegate terminate;
                delegate program;
            }

            interface A3
            {
                delegate guile;
                delegate languge;
                delegate terminate;
                delegate program;
            }
         } 
         
  return dlang();       
}
                
