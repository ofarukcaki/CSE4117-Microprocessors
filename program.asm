.data
            terms: 4
            zero: 0
.code   
            ldi 0 zero      
            ld 0 0   
            ldi 7 terms
            ld 7 7      
mainLoop    mov 6 7         
            ldi 1 zero   
            ld 1 1      
loop        add 1 1 7       
            dec 6           
            jz endloop
            jmp loop
endloop     add 0 0 1       
            dec 7           
            jz exit         
            jmp mainLoop    
exit        jmp exit       