.data
            terms: 8
.code   
            ldi 0 0 
            ldi 7 terms
            ld 7 7      
main        mov 6 7         
            ldi 1 0   
loop        add 1 1 7       
            dec 6           
            jz endloop
            jmp loop
endloop     add 0 0 1       
            dec 7           
            jz exit         
            jmp main    
exit        ldi 1 0
            mov 7 0
            ldi 2 8
start       ldi 6 15 
            and 6 1 6
            ldi 5 0
            sub 5 6 5
            jz skip3
            ldi 5 1
            sub 5 6 5
            jz skip3
            ldi 5 2
            sub 5 6 5
            jz skip3
            ldi 5 3
            sub 5 6 5
            jz skip3
            ldi 5 4
            sub 5 6 5
            jz skip3
            ldi 5 3
            add 1 1 5
skip3       ldi 6 240
            and 6 1 6
            ldi 5 0
            sub 5 6 5
            jz skip32
            ldi 5 16
            sub 5 6 5
            jz skip32
            ldi 5 32
            sub 5 6 5
            jz skip32
            ldi 5 48
            sub 5 6 5
            jz skip32
            ldi 5 64
            sub 5 6 5
            jz skip32
            ldi 5 48
            add 1 1 5
skip32      ldi 6 3840
            and 6 1 6
            ldi 5 0
            sub 5 6 5
            jz skip33
            ldi 5 256
            sub 5 6 5
            jz skip33
            ldi 5 512
            sub 5 6 5
            jz skip33
            ldi 5 768
            sub 5 6 5
            jz skip33
            ldi 5 1024
            sub 5 6 5
            jz skip33
            ldi 5 768
            add 1 1 5
skip33      add 1 1 1
            mov 5 2
            dec 5
            jz handlelast
            ldi 4 1
ll          add 4 4 4
            dec 5
            jz exitll
            jmp ll         
exitll      and 4 7 4
            jz iszero
            ldi 5 1
            add 1 1 5
iszero      dec 2
            jz endbcd
            jmp start
endbcd      mov 0 1
uzay        jmp uzay
handlelast  ldi 5 1
            and 5 7 5
            jz endbcd
            ldi 5 1
            add 1 1 5
            jmp endbcd