.code       
            ldi 0 0
            ldi 1 2816
            ldi 2 2304
            ldi 3 2305
            ldi 7 450
dsp         call bcd
            ldi 6 0
loop        ld 4 3
            ldi 5 1
            and 4 4 5
            jz loop
            ld 4 2
            ldi 5 14
            sub 5 5 4
            jz mult
            ldi 5 15
            sub 5 5 4
            jz edt
            push 0
            push 4
            ldi 0 10
            mov 4 6
            call mult2
            mov 6 0
            pop 4
            pop 0
            add 6 6 4
            st 1 6
            jmp loop
edt         add 0 0 6
            jmp dsp
mult        push 1
            jmp multi
multend     pop 1
            jmp dsp
multi       mov 4 6
            mov 1 0
            ldi 5 0
mul1        add 5 5 1
            mov 0 5
            dec 4
            jz multend
            jmp mul1
mult2       push 1
            jmp multi2
multend2    pop 1
            ret
multi2      mov 4 6
            mov 1 0
            ldi 5 0
mul2        add 5 5 1
            mov 0 5
            dec 4
            jz multend2
            jmp mul2
bcd         push 0
            push 1
            push 2
            push 3
            push 4
            push 5
            push 6
            ldi 1 0
            mov 3 0
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
exitll      and 4 3 4
            jz iszero
            ldi 5 1
            add 1 1 5
iszero      dec 2
            jz endbcd
            jmp start
endbcd      mov 0 1
            pop 6
            pop 5
            pop 4
            pop 3
            pop 2
            pop 1
            st 1 0
            pop 0
            ret
uzay        jmp uzay
handlelast  ldi 5 1
            and 5 3 5
            jz endbcd
            ldi 5 1
            add 1 1 5
            jmp endbcd