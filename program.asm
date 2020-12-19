.data
            terms: 4
            zero: 0
.code   
            ldi 1 zero      
            ld 0 1   
            ldi 7 terms
            ld 7 7      
main        mov 6 7         
            ldi 1 zero   
            ld 1 1      
loop        add 1 1 7       
            dec 6           
            jz endloop
            jmp loop
endloop     add 0 0 1       
            dec 7           
            jz exit         
            jmp main    
exit        jmp exit       