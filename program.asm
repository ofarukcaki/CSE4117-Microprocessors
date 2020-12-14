.data
            terms: 40
            result: 40
.code
            ldi 4 0
            ldi 0 terms
mainLoop    ld 0 0
            mov 1 0
            mov 2 0
            ldi 3 0
loop        add 3 3 1
            dec 2
            jz out
            jmp loop
out         add 4 4 3
            dec 0
            jz out2
            jmp mainLoop
out2        ldi 5 result
            st 5 4
end         jmp end
