    [org 0x0100]
    jmp start
    menu db 10,13," STUDENT MANAGEMENT SYSTEM ",10,13
     db "1. Add Student",10,13
     db "2. View Students",10,13
     db "3. Fee Status",10,13
     db "4. Exit",10,13
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
     
     ;attendence
     attendencein : db 13,10,10,"Please enter student name : $"
     attendence: db 13,10,"attendence record : $";11-15

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
    jmp exit
    opt1:
        call add_student
        jmp start
    opt2:
        call show_student
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
        
    exit:
    mov ax,0x4c00
    int 21h