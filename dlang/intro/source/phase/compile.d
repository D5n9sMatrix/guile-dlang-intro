module phase.compile;

/*
Phases of Compilation

      The process of compiling is divided into multiple phases. 
      Each phase is independent of subsequent phases. 
      For example, the scanner is not affected by the semantic analyzer. 
      This separation of passes makes language tools like syntax-directed 
      editors relatively easy to create.

source character set

    The source file is checked to determine its encoding and the appropriate 
scanner is loaded. 7-bit ASCII and UTF encodings are accepted.

script line

    If the first line starts with "#!", then that line is ignored.

lexical analysis

    The source file is divided into a sequence of tokens. 
Special tokens are replaced with other tokens. 

    SpecialTokenSequences are processed and removed.

syntax analysis

    The sequence of tokens is parsed to form syntax trees.

semantic analysis
      The syntax trees are traversed to declare variables, load symbol tables, 
assign types, and determine the meaning of the program.

optimization

     Optimization is an optional pass that attempts to rewrite the program 
in a semantically equivalent, more performant, version.

code generation

   Instructions are selected from the target architecture to implement 
   the semantics of the program. The typical result will be an object 
   file suitable for input to a linker.
*/
@property void phase(compile)(ref source, character, set, load)
{
    void compile(
         delegate source,
         delegate character,
         delegate set,
         delegate load)
         {
            interface A4
            {
                delegate source;
                delegate character.
                delegate set;
                delegate load;
            }

            interface A5
            {
                delegate source;
                delegate character;
                delegate set;
                delegate load;
            }

            interface A6
            {
                delegate source;
                delegate character;
                delegate set;
                delegate load;
            }
         }
         
    return compile();      
}

                    
