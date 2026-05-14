    [org 0x0100]
    jmp start
    menu db 10,10,13," STUDENT MANAGEMENT SYSTEM ",10,13
     db 10,13,"1. Add Student",10,13
     db "2. View Students",10,13
     db "3. Take Attendence",10,13
     db "4. Show Attendence",10,13
     db "Enter Choice: $"

     choice : db 0
     

     ;student input messages
     namein : db 13,10,10,"Please enter student name : $"
     rollin : db 13,10,"Please enter student Roll Number : $"
     agein : db 13,10,"Please enter student Age : $"
     feein : db 13,10,"Please enter student Fee status (0/1) : $"
     marksin : db 13,10,"Please enter student Marks : $",13,10

     ;student out messages
     stdname: db 13,10,10,"name of the student is : $";0-4
     stdroll: db 13,10,"Roll Number of the student is : $";5
     stdage: db 13,10,"Age of the student is : $";6-7
     stdfee: db 13,10,"Fee Status of the student is : $";8
     stdmarks: db 13,10,"Marks of the student are : $",13,10;9-10
     std1:db 0,0,0,0,0,0,0,0,0,0,0
     std2:db 0,0,0,0,0,0,0,0,0,0,0
     std3:db 0,0,0,0,0,0,0,0,0,0,0
     std4:db 0,0,0,0,0,0,0,0,0,0,0
     std5:db 0,0,0,0,0,0,0,0,0,0,0
     stdcount : db 0
     ;student end
     
     ;attendence
     dsp_takingatten: db 13,10,10, "!!         Taking Attendence      !!",13,10,"$"
     dsp_atten: db 13,10,10, "!!         Showing Attendence      !!",13,10,"$"
     attenin : db 13,10,"enter attendence of rollnumber $"
     space : db " : $"
     slash : db " | $"
     attenout: db 13,10,"attendence record of rollnumber $"
     atten  db 1,0,0,0,0,0 ;0-5 s1
            db 2,0,0,0,0,0 ;6-11 s2
            db 3,0,0,0,0,0 ;12-17 s3
            db 4,0,0,0,0,0 ;18-23 s4
            db 5,0,0,0,0,0 ;24-29 s5
     atpointer: db 0 ;1,2,3,4,5
     ;attendence end

    start:
    mov dx,menu
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    mov [choice],al 

    cmp byte[choice],'1'
    je opt1
    cmp byte[choice],'2'
    je opt2
    cmp byte[choice],'3'
    je opt3
    cmp byte[choice],'4'
    je opt4

    jmp exit
    opt1:
        call add_student
        jmp start
    opt2:
        call show_student
        jmp start
    opt3:
        call take_attendence
        jmp start
    opt4:
        call show_attendence
        jmp start
    jmp exit

    add_student:
        mov bx,0 ;counter 0-11  (0-4(name),5(rollnumber),6-7(age),8(fee status),9-10(marks))
        ;Name
        mov ah,09h
        mov dx,namein
        int 21h
        input_name_loop:
            mov ah,01
            int 21h
            mov [std1+bx],al 
            add bx,1
            cmp bx,5
            jne input_name_loop
        ;Roll Number
        mov ah,09h
        mov dx,rollin
        int 21h
        input_roll_loop:
            mov ah,01
            int 21h
            mov [std1+bx],al 
            add bx,1
            cmp bx,6
            jne input_roll_loop
        ;Age
        mov ah,09h
        mov dx,agein
        int 21h
        input_age_loop:
            mov ah,01
            int 21h
            mov [std1+bx],al 
            add bx,1
            cmp bx,8
            jne input_age_loop
        ;Fee status
        mov ah,09h
        mov dx,feein
        int 21h
        input_fee_loop:
            mov ah,01
            int 21h
            mov [std1+bx],al 
            add bx,1
            cmp bx,9
            jne input_fee_loop
        ;Marks status
        mov ah,09h
        mov dx,marksin
        int 21h
        input_marks_loop:
            mov ah,01
            int 21h
            mov [std1+bx],al 
            add bx,1
            cmp bx,11
            jne input_marks_loop
        
        ret


    show_student:
        mov bx,0 ;counter 0-11  (0-4(name),5(rollnumber),6-7(age),8(fee status),9-10(marks))
        ;Name
        mov dx,stdname
        mov ah,09h
        int 21h
        output_name_loop:
            mov dl,[std1+bx]
            mov ah,02
            int 21h
            add bx,1
            cmp bx,5
            jne output_name_loop
        ;Roll number
        mov dx,stdroll
        mov ah,09h
        int 21h
        output_roll_loop:
            mov dl,[std1+bx]
            mov ah,02
            int 21h
            add bx,1
            cmp bx,6
            jne output_roll_loop
        ;Age
        mov dx,stdage
        mov ah,09h
        int 21h
        output_age_loop:
            mov dl,[std1+bx]
            mov ah,02
            int 21h
            add bx,1
            cmp bx,8
            jne output_age_loop
        ;Fee status
        mov dx,stdfee
        mov ah,09h
        int 21h
        output_fee_loop:
            mov dl,[std1+bx]
            mov ah,02
            int 21h
            add bx,1
            cmp bx,9
            jne output_fee_loop
        ;Marks
        mov dx,stdmarks
        mov ah,09h
        int 21h
        output_marks_loop:
            mov dl,[std1+bx]
            mov ah,02
            int 21h
            add bx,1
            cmp bx,11
            jne output_marks_loop    
        mov dl,13
        int 21h
        ret
    take_attendence: 
       mov dx,dsp_takingatten
       mov ah,09h
       int 21h

       mov cl,1
       mov si,0
       mov bl,[atpointer]
       mov bh,0
       add bx,1
       label:
       ;// input show block
              mov dx,attenin
              mov ah,09h
              int 21h

              mov ch,[atten+si]
              add ch,30h
              mov dl ,ch
              mov ah,02h
              int 21h

              mov dx,space
              mov ah,09h
              int 21h
       ;//end input show block

       ;//input attendence block

              mov ah,01h
              int 21h

              mov [atten+si+bx],al
       ;end iput block
              add cl,1
              add si,6
              cmp cl,6
              jne label
       mov [atpointer],bl
     ret
     show_attendence:
       mov dx,dsp_atten
       mov ah,09h
       int 21h
     ;[atpointer] have the toatal number of attendence so show
     ;attendence upto [atpointer value]
       mov cl,1
       mov bl,[atpointer]
       mov bh,0
       cmp bl,0
       je endb
       mov si,0
       show_outer:
              mov bp,1
              ;mov bp,0 ; for the inner loop
              mov dx,attenout
              mov ah,09h
              int 21h

              ; mov ch,[atten+si]
              ; add ch,30h
              mov dl ,cl
              add dl,30h
              mov ah,02h
              int 21h

              mov dx,space
              mov ah,09h
              int 21h
              ;show record 
              show_inner:
                     mov dl,[atten+bp+si]
                     mov ah,02h
                     int 21h

                     mov dx,slash
                     mov ah,09h
                     int 21h

                     add bp,1
                     cmp bp,bx 
                     jle show_inner

              add cl,1
              add si,6
              cmp cl,6
              jne show_outer
              endb:
              ret
        
    exit:
    mov ax,0x4c00
    int 21h