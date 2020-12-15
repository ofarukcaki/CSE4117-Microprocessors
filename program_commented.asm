.data
            terms: 4
            zero: 0
.code   
            ldi 0 zero          // r0 = 0 inital value
            ld 0 0   
            ldi 7 terms
            ld 7 7              // r7 = terms
mainLoop    mov 6 7             // copy r7 into r6, and sum the value r7 for r6 times (taking square of a number)
            ldi 1 zero   
            ld 1 1              // r1 = 0, holds local sum
loop        add 1 1 7           // r1 = r1 + r7   , do that r6 times   
            dec 6               // r6--
            jz endloop          
            jmp loop
endloop     add 0 0 1           // add square result into sum, which is at r0
            dec 7               // decrement the terms variable once
            jz exit             // if we reach zero exit
            jmp mainLoop        // otherwise continue with the decremented value
exit        jmp exit            // infinite loop