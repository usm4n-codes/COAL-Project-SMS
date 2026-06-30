    [org 0x0100]
    jmp start
    menu db 10,10,13," STUDENT MANAGEMENT SYSTEM ",10,13
     db 10,13,"1. Add Student",10,13
     db "2. View Students",10,13
     db "3. Take Attendence",10,13
     db "4. View Attendence",10,13
     db "5. Manage Fee Record",10,13
     db "6. View Fee Record",10,13
     db "7. Exit",10,13
     db "Enter Choice: $"

     choice : db 0
     

     ;student input messages
     namein : db 13,10,10,"Please enter student name : $"
     rollin : db 13,10,"Please enter student Roll Number : $"
     agein : db 13,10,"Please enter student Age : $"
     feein : db 13,10,"Please enter student Fee status (0/1) : $"
     marksin : db 13,10,"Please enter student Marks : $",13,10

     ;student out messages
     norecord : db 13,10,"!! Student table has no record !!$",13,10
     stdname: db 13,10,10,"name of the student is : $";0-4
     stdroll: db 13,10,"Roll Number of the student is : $";5
     stdage: db 13,10,"Age of the student is : $";6-7
     stdfee: db 13,10,"Fee Status of the student is : $";8
     stdmarks: db 13,10,"Marks of the student are : $",13,10;9-10
     student db 0,0,0,0,0,0,0,0,0,0,0   ;0-10 std1
        db 0,0,0,0,0,0,0,0,0,0,0    ;11-21 std2
        db 0,0,0,0,0,0,0,0,0,0,0    ;22-32 std3
        db 0,0,0,0,0,0,0,0,0,0,0    ;33-43 std4
        db 0,0,0,0,0,0,0,0,0,0,0    ;44-54 std5
     stdpointer : db 0
     stdcounter : db 0 
     ;student end
     
     ;attendence
     dsp_takingatten: db 13,10,10, "!!         Taking Attendence      !!",13,10,"$"
     dsp_atten: db 13,10,10, "!!         Showing Attendence      !!",13,10,"$"
     attenin : db 13,10,"enter attendence of rollnumber $"
     space : db " : $"
     slash : db " | $"
     attenout: db 13,10,"attendence record of rollnumber $"
     atten  db 0,0,0,0,0,0 ;0-5 s1 0 serial number
            db 0,0,0,0,0,0 ;6-11 s2 6 serial number
            db 0,0,0,0,0,0 ;12-17 s3 12 serial number
            db 0,0,0,0,0,0 ;18-23 s4 18 serial number
            db 0,0,0,0,0,0 ;24-29 s5 24 serial number
     atpointercol: dw 0 ;1,2,3,4,5
     atpointerrow: dw 0
     ;attendence end
     

    ;-------------------------------------------------------------------------------------
    ;-------------------------------------------------------------------------------------
    ;-------------------------------    MACROS    ----------------------------------------
    ;-------------------------------------------------------------------------------------
    ;-------------------------------------------------------------------------------------
    %macro add_student 1
        mov bl,[stdpointer]
        mov bh,0

        mov si,0 ;counter 0-11  (0-4(name),5(rollnumber),6-7(age),8(fee status),9-10(marks))
        ;Name
        mov di,[atpointerrow]
        mov ah,09h
        mov dx,namein
        int 21h
        %%input_name_loop:
            mov ah,01
            int 21h
            mov [%1+bx+si],al 
            add si,1
            cmp si,5
            jne %%input_name_loop
        ;Roll Number
        mov ah,09h
        mov dx,rollin
        int 21h
        %%input_roll_loop:
            mov ah,01
            int 21h
            mov [%1+bx+si],al
            mov [atten+di],al
            add si,1
            cmp si,6
            jne %%input_roll_loop
        ;Age
        mov ah,09h
        mov dx,agein
        int 21h
        %%input_age_loop:
            mov ah,01
            int 21h
            mov [%1+bx+si],al 
            add si,1
            cmp si,8
            jne %%input_age_loop
        ;Fee status
        mov ah,09h
        mov dx,feein
        int 21h
        %%input_fee_loop:
            mov ah,01
            int 21h
            mov [%1+bx+si],al 
            add si,1
            cmp si,9
            jne %%input_fee_loop
        ;Marks status
        mov ah,09h
        mov dx,marksin
        int 21h
        %%input_marks_loop:
            mov ah,01
            int 21h
            mov [%1+bx+si],al 
            add si,1
            cmp si,11
            jne %%input_marks_loop
        add bx,11
        add di,6
        mov [atpointerrow],di
        mov [stdpointer],bl
        add byte [stdcounter],1

    %endmacro

    %macro show_student 1
        mov bl,0
        mov bh,0
        mov di,0
        cmp byte[stdpointer],0
        je %%jump
        jne %%outer_show_student
        %%jump:
            jmp %%skip_dspstudent

        %%outer_show_student:
        ;suppose stdpointer is 22 mean we have two students std1 0-10,std2 11-21
        mov si,0 ;counter 0-11  (0-4(name),5(rollnumber),6-7(age),8(fee status),9-10(marks))
        ;Name
        
        mov dx,stdname
        mov ah,09h
        int 21h
        %%output_name_loop:
            mov dl,[%1+si+bx]
            mov ah,02
            int 21h
            add si,1
            cmp si,5
            jne %%output_name_loop
        ;Roll number
        mov dx,stdroll
        mov ah,09h
        int 21h
        %%output_roll_loop:
            ;mov dl,[student+si+bx]
            mov dl,[atten+di]
            mov ah,02
            int 21h
            add si,1
            add di,6
            cmp si,6
            jne %%output_roll_loop
        ;Age
        mov dx,stdage
        mov ah,09h
        int 21h
        %%output_age_loop:
            mov dl,[%1+si+bx]
            mov ah,02
            int 21h
            add si,1
            cmp si,8
            jne %%output_age_loop
        ;Fee status
        mov dx,stdfee
        mov ah,09h
        int 21h
        %%output_fee_loop:
            mov dl,[%1+si+bx]
            mov ah,02
            int 21h
            add si,1
            cmp si,9
            jne %%output_fee_loop
        ;Marks
        mov dx,stdmarks
        mov ah,09h
        int 21h
        %%output_marks_loop:
            mov dl,[%1+si+bx]
            mov ah,02
            int 21h
            add si,1
            cmp si,11
            jne %%output_marks_loop    
        mov dl,13
        add bl,11
        cmp bl,[stdpointer]
        jl %%outer_show_student
        jmp %%t1
        %%skip_dspstudent:
            mov dx,norecord
            mov ah,09h
            int 21h
        %%t1:
        int 21h
    %endmacro

    %macro take_attendence 1: 
       mov di,[atpointerrow]
       cmp di,0
       je skip_take_attendence
       mov dx,dsp_takingatten
       mov ah,09h
       int 21h
       ;di 6,12,26

    ;    mov cl,0
       mov si,0
       mov bx,[atpointercol]
    ;    mov bh,0
       add bx,1
       label:
       ;// input show block
              mov dx,attenin
              mov ah,09h
              int 21h

              mov ch,[%1+si]
              ;add ch,30h
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

              mov [%1+si+bx],al
       ;end iput block
            ;   add cl,6
              add si,6
              cmp si,[atpointerrow]
              jl label
       mov [atpointercol],bx
       jmp t2
       skip_take_attendence:
            mov dx,norecord
            mov ah,09h
            int 21h
       t2:

    %endmacro

    %macro show_attendence 1:
       mov di,[atpointerrow]
       cmp di,0
       je skip_show_attendence
       mov dx,dsp_atten
       mov ah,09h
       int 21h
     ;[atpointer] have the toatal number of attendence so show
     ;attendence upto [atpointer value]
    ;    mov cl,1
       mov bx,[atpointercol]
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

              mov ch,[%1+si]
            ;   add ch,30h
              mov dl ,ch
            ;   add dl,30h
              mov ah,02h
              int 21h

              mov dx,space
              mov ah,09h
              int 21h
              ;show record 
              show_inner:
                     mov dl,[%1+bp+si]
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
              cmp si,[atpointerrow]
              jl show_outer
              endb:
                jmp t3
                skip_show_attendence:
                    mov dx,norecord
                    mov ah,09h
                    int 21h
                t3:
    %endmacro
     submit_ammount_message: db 13,10,"Enter the amount you want to submit : $"
     fee_left_message : db 13,10,"Remaing amount to submit is : $"
     total_submitted_message : db 13,10,"Your current balance is : $"
     submitted_message : db 13,10,"Fee is sucessfully submitted : $"
     big_amount : db 13,10,"You submitted balance exceds the total amount $"
     student_number_message : db 13,10,"Enter the number of student : $"
     fee_record_message : db 13,10,"Fee record of rollnumber $"
     student_not_found : db 13,10,"!!!!!!!!!!!Student doesn't exist !!!!!!!!!!!!$"
     totalamount: dw 10000
     submitted_amounts: dw 0,0,0,0,0
     submitted : db '$','$','$','$','$'
     reminder : db '0','0','0','0','0'
     remain: dw 0
     snum: dw 0
     ;choice: db 0
     status: db 0
     roll_number : db 0
    %macro fee_add_to_record 2
        mov bl,[%2] ; [roll_number]
        mov bh,0
        shl bx,1 
        mov ax,[submitted_amounts+bx]
        add ax,[%1] ; [snum]
        mov [submitted_amounts+bx],ax
        balance_exceed_check [totalamount],[submitted_amounts+bx]
        ; fee_remain [totalamount],[submitted_amounts+bx]
    %endmacro
    %macro roll_number_input 1
        mov dx,student_number_message
        mov ah,09h
        int 21h

        mov ah,01h
        int 21h
        sub al,30h
        sub al,1
        mov bh,[stdcounter]
        cmp al,bh ; not the actual rollnumber but the student number
        jg near student_not_exists
        mov byte[%1],al ;rollnumber
        amount_submit_macro [snum]
        fee_add_to_record snum,%1 ;1 represent the location 
        jmp near rollnumber_added
        student_not_exists:
        mov dx,student_not_found
        mov ah,09h
        int 21h
        rollnumber_added:
    %endmacro
    %macro fee_remain 2 ;totalamount,submitted_amounts+bx
        mov ax,%1 
        sub ax,%2
        mov [remain],ax
        mov dx,fee_left_message
        mov ah,09h
        int 21h
        display_fee [remain]
        ; mov word [remain],ax
        %endmacro
    %macro balance_exceed_check 2
        mov ax,%2 ;2 holds submitted amount
        cmp ax,%1 ;1 holds total
        
        jg near %%amount_exceed
        fee_remain %1,%2
        
        jmp near %%donecheck
        %%amount_exceed:
            mov dx,big_amount
            mov ah,09h
            int 21h
        %%donecheck:
        %endmacro
    ; %macro conversion_dec_to_remin
    
    %macro display_fee 1 ;remain 121
        mov ax,%1 ;ax=121
        mov bx,0
        ; mov ax,[snum]
        %%decimal_to_reminder_loop:
            mov dx,0
            mov cx,10
            div cx
            mov [reminder+bx],dl
            mov dl,0
            add bx,1
            cmp bx,5
            jne %%decimal_to_reminder_loop
        mov bx,5
        %%print_remaining:
            sub bx,1
            mov dl,[reminder+bx]
            add dl,'0'
            mov ah,02h
            int 21h
            cmp bx,0
            jne %%print_remaining
    %endmacro

    %macro amount_submit_macro 1
        mov dx,submit_ammount_message
        mov ah,09h
        int 21h
        mov ch,0
        mov bx,0
        mov word[snum],0
        mov byte[submitted],'$'
        mov byte[submitted+1],'$'
        mov byte[submitted+2],'$'
        mov byte[submitted+3],'$'
        mov byte[submitted+4],'$'
        %%ammount_submit_loop:
            mov ah,01h
            int 21h
            cmp al,13
            je %%done
            sub al,'0'
            mov [submitted+bx],al
            add bx,1

            add ch,1
            cmp ch,5
            jne %%ammount_submit_loop
            %%done: 
            mov bx,0
            mov ax,0
            ;'6','5','0','0'->6500->snum
            %%submitted_to_decimal_loop:
                cmp byte[submitted+bx],'$'
                je %%done1
                mov ax,10
                mov si,[snum] 
                mul si
                mov cl,[submitted+bx]
                mov ch,0
                add ax,cx
                
                mov word %1,ax
                add bx,1
                cmp bx,5
                jne %%submitted_to_decimal_loop
                %%done1:
    %endmacro

    %macro show_fee_record 1

        cmp byte[stdcounter],0
        je near %%skip_show_fee_record
        mov cl,[stdcounter];
        mov ch,0
        mov bx,0
        mov si,0
        %%show_fee_record_loop:
            mov dx,fee_record_message
            mov ah,09h
            int 21h

            mov dl,[atten+bx]
            mov ah,02h
            int 21h

            mov dx,space
            mov ah,09h
            int 21h
            mov ax,[submitted_amounts+si]
            mov di,0
            %%decimal_to_reminder_loop_fee:
                mov dx,0
                mov bp,10
                div bp
                mov [reminder+di],dl
                mov dl,0
                add di,1
                cmp di,5
                jne %%decimal_to_reminder_loop_fee
            mov di,5
            %%print_remaining_fee:
                sub di,1
                mov dl,[reminder+di]
                add dl,'0'
                mov ah,02h
                int 21h
                cmp di,0
                jne %%print_remaining_fee

            add bx,6
            add si,2
        loop %%show_fee_record_loop
        %%skip_show_fee_record:
        %endmacro



    start:
    mov dx,menu
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    mov [choice],al 

    cmp byte[choice],'1'
    jne check2
    jmp opt1

    check2:
    cmp byte[choice],'2'
    jne check3
    jmp opt2

    check3:
    cmp byte[choice],'3'
    jne check4
    jmp opt3

    check4:
    cmp byte[choice],'4'
    jne check5
    jmp opt4

    check5:
    cmp byte[choice],'5'
    jne check6
    jmp opt5

    check6:
    cmp byte[choice],'6'
    jmp opt6

    check7:
    cmp byte[choice],'7'
    jne done
    jmp opt7




    done:


    jmp exit
    opt1:
        add_student student  
        jmp start
    opt2:
        show_student student
        jmp start
    opt3:
        take_attendence atten
        jmp start
    opt4:
        show_attendence atten
        jmp start
    opt5:
        roll_number_input roll_number
        jmp start
    opt6:
        show_fee_record submitted_amounts
        jmp start
    opt7:

        
    exit:
    mov ax,0x4c00
    int 21h