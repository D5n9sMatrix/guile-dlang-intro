module memory.model;

/*

Memory Model

     The byte is the fundamental unit of storage. 
     Each byte has 8 bits and is stored at a unique 
     address. A memory location is a sequence of one 
     or more bytes of the exact size required to hold 
     a scalar type. Multiple threads can access separate 
     memory locations without interference.

Memory locations come in three groups:

    Thread-local memory locations are accessible from only one thread at a time.
    Immutable memory locations cannot be written to during their lifetime. 
    Immutable memory locations can be read from by multiple threads without 
    synchronization.
    Shared memory locations are accessible from multiple threads.
    Undefined Behavior: Allowing multiple threads to access a thread-local 
    memory location results in undefined behavior.
    Undefined Behavior: Writing to an immutable memory location during 
    its lifetime results in undefined behavior.
    Undefined Behavior: Writing to a shared memory location in one 
    thread while one or more additional threads read from or write 
    to the same location is undefined behavior unless all of the 
    reads and writes are synchronized.
    Execution of a single thread on thread-local and immutable memory 
    locations is sequentially consistent. This means the collective 
    result of the operations is the same as if they were executed 
    in the same order that the operations appear in the program.

A memory location can be transferred from thread-local to immutable 
or shared if there is only one reference to the location.

A memory location can be transferred from shared to immutable 
or thread-local if there is only one reference to the location.

A memory location can be temporarily transferred from shared 
to local if synchronization is used to prevent any other 
threads from accessing the memory location during 
the operation.

*/
@property void memory(model)(ref local, bios, matrix, single)
{
    void model(
         delegate local,
         delegate bios,
         delegate matrix,
         delegate single)
         {
            interface A7
            {
                delegate local;
                delegate bios;
                delegate matrix;
                delegate single;
            }

            interface A8
            {
                delegate local;
                delegate bios;
                delegate matrix;
                delegate single;
            }

            interface A9
            {
                delegate local;
                delegate bios;
                delegate matrix;
                delegate single;
            }
         }

    return model();    
}    
