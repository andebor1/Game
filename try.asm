IDEAL
		
MODEL small

STACK 256

DATASEG
Clock equ es:6Ch

Time_Aux db 0
time_changes dw 0

background_color db 00
boundry dw 5

;points
points_str db "000", "$"
points dw 00


;spaceship draw
space_ship_size dw 6
space_ship_color db 10
wing_distance dw 3
wings_size dw 3
window_color db 16h

;player stats
x_pos dw 160
y_pos dw 100
velocity_x dw 0
velocity_y dw 0
max_velocity_x dw 3
max_velocity_y dw 3
dush_speed dw 5
health dw 5
health_str dw "00$"

;astroids
astroids_array dw 50, 77, 58, 158, 200, 50, 7 dup(0, 0)
number_of_astroids dw 3
max_number_of_astroids dw 10
astroid_color db 16h
astroid_size_x dw 15
astroid_size_y dw 10

;astroids' velocities
astroids_spawn_rate dw 50
time_since_last_spawn dw 0
astroid_velocity_x dw 2
astroid_velocity_y dw 0


		
CODESEG

proc clear_screen
    mov ax, 13h ;320x200
    int 10h 

    mov bx, 00h
    mov ah, 0bh
    int 10h
    ret
endp

proc clear_player
    push ax
    push bx

    mov al, [space_ship_color]
    mov ah, [window_color]

    mov bl, [background_color]
    mov [space_ship_color], bl
    mov [window_color], bl
    call draw_space_ship
    
    mov [space_ship_color], al
    mov [window_color], ah

    pop bx
    pop ax
    ret
endp

proc draw_wing_left_line
    left_line:
        mov bh, 0h 
        mov al, [space_ship_color]
        mov ah, 0ch 
        int 10h
        dec cx
        mov ax, [x_pos]
        sub ax, [wing_distance]
        sub ax, [wings_size]
        cmp cx, ax
        jg left_line
        ret
endp

proc draw_wing_right_line
    right_line:
        mov bh, 0h 
        mov al, [space_ship_color] 
        mov ah, 0ch 
        int 10h
        inc cx
        mov ax, [x_pos]
        add ax, [space_ship_size]
        add ax, [wing_distance]
        add ax, [wings_size]
        cmp cx, ax
        jl right_line
        ret
endp

proc draw_wing_up
    dec dx
    mov ax, [y_pos]
    sub ax, [wing_distance]
    sub ax, [wing_distance]
    sub ax, [wings_size]
    cmp dx, ax
    ret
endp

proc draw_wing_down
    inc dx
    mov ax, [y_pos]
    add ax, [space_ship_size]
    add ax, [wing_distance]
    add ax, [wing_distance]
    add ax, [wings_size]
    cmp dx, ax
    ret
endp

proc draw_space_ship
    push ax
    push bx
    push cx
    push dx

    mov dx, [y_pos] 
    mov cx, [x_pos] 

    push dx
    push cx

        wings1: ;draws the line to the place that the wing should be at
            dec cx
            mov bh, 0h 
            mov al, [space_ship_color]
            mov ah, 0ch 
            int 10h
            sub dx, 2
            mov bh, 0h 
            mov al, [space_ship_color]
            mov ah, 0ch 
            int 10h
        
            mov ax, [x_pos]
            sub ax, [wing_distance]
            cmp cx, ax
            jg wings1
        
        wingsY1: ;draws the square (the wing)
            mov cx, [x_pos] 
            sub cx, [wing_distance]

        wingsX1:
            call draw_wing_left_line
            call draw_wing_up
            jg wingsY1

        pop cx
        pop dx


    Yagain: ;draws the spaceship (a square)
        mov cx, [x_pos] 

    Xagain:
        mov bh, 0h 
        mov al, [space_ship_color]
        mov ah, 0ch 
        int 10h
        inc cx
        mov ax, [x_pos]
        add ax, [space_ship_size]
        cmp cx, ax
        jl Xagain

        cmp dx, [y_pos]
        je start_wings3

        mov ax, [y_pos]
        add ax, [space_ship_size]
        sub ax, 1
        cmp dx, ax
        je start_wings4

        con:
        inc dx
        mov ax, [y_pos]
        add ax, [space_ship_size]
        cmp dx, ax
        jl Yagain

    push cx
    push dx

    window:
        mov dx, [y_pos]
        window_line:
        mov bh, 0h 
        mov al, [window_color] 
        mov ah, 0ch 
        int 10h
        inc dx
        mov ax, [y_pos]
        add ax, [space_ship_size]
        cmp dx, ax
        jl window_line
    inc cx
    mov ax, [x_pos]
    add ax, [space_ship_size]
    add ax, 2
    cmp cx, ax
    jl window
    
    pop dx
    pop cx


    jmp start_wings2

    start_wings3:
        push dx
        push cx

        wings3:
            inc cx
            mov bh, 0h 
            mov al, [space_ship_color] 
            mov ah, 0ch 
            int 10h
            sub dx, 2
            mov bh, 0h 
            mov al, [space_ship_color]
            mov ah, 0ch 
            int 10h
            
            mov ax, [x_pos]
            add ax, [space_ship_size]
            add ax, [wing_distance]
            cmp cx, ax
            jl wings3
            
        wingsY3:
            mov cx, [x_pos] 
            add cx, [space_ship_size]
            add cx, [wing_distance]

        wingsX3:
            call draw_wing_right_line
            call draw_wing_up
            jg wingsY3

        pop cx
        pop dx
        jmp con

    start_wings4:
        push dx
        push cx

        add dx, 1
        mov cx, [x_pos]
        wings4:
            dec cx
            mov bh, 0h 
            mov al, [space_ship_color] 
            mov ah, 0ch 
            int 10h
            add dx, 2
            mov bh, 0h 
            mov al, [space_ship_color] 
            mov ah, 0ch 
            int 10h
            
            mov ax, [x_pos]
            sub ax, [wing_distance]
            cmp cx, ax
            jg wings4
            
        wingsY4:
            mov cx, [x_pos] 
            sub cx, [wing_distance]

        wingsX4:    
            call draw_wing_left_line
            call draw_wing_down
            jl wingsY4

        pop cx
        pop dx
        jmp con

    start_wings2:
        push dx
        push cx

            wings2:
                inc cx
                mov bh, 0h 
                mov al, [space_ship_color]
                mov ah, 0ch 
                int 10h
                add dx, 2
                mov bh, 0h 
                mov al, [space_ship_color]
                mov ah, 0ch 
                int 10h
            
                mov ax, [x_pos]
                add ax, [space_ship_size]
                add ax, [wing_distance]
                cmp cx, ax
                jl wings2
            
            wingsY2:
                mov cx, [x_pos] 
                add cx, [space_ship_size]
                add cx, [wing_distance]

            wingsX2:
                call draw_wing_right_line
                call draw_wing_down
                jl wingsY2

            pop cx
            pop dx

    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp


proc draw_astroid
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov si, offset astroids_array
    
    mov cx, [number_of_astroids]
    cmp cx, 0
    jle dont_draw
    draw_next:
        push cx
        mov dx, [word si + 2]
    vertical:
        mov cx, [word si]
    horizontal:
         mov bh, 0
         mov al, [astroid_color]
         mov ah, 0ch
         int 10h
         inc cx
         mov ax, [word si]
         add ax, [astroid_size_x]
         cmp cx, ax
         jl horizontal
         inc dx
         mov ax, [word si + 2]
         add ax, [astroid_size_y]
         cmp dx, ax
         jl vertical
    add si, 4
    pop cx
    loop draw_next

    dont_draw:

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

proc move_player
    push ax

    mov ah, 01h
    int 16h

    jz finish_closer
    
    mov ah, 00h
    int 16h

    cmp al, 74h
    je quit_closer
    cmp al, 54h
    je quit_closer

    cmp al, 77h
    je move_up
    cmp al, 57h
    je move_up

    cmp al, 73h
    je move_down
    cmp al, 53h
    je move_down

    cmp al, 64h
    je move_right
    cmp al, 44h
    je move_right

    cmp al, 61h
    je move_left
    cmp al, 41h
    je move_left

    cmp al, 20h
    je dush_closer

    finish_closer:
        jmp finish_closer_closer
    
    quit_closer:
        call quit


    move_up:
        mov ax, [velocity_y]
        add ax, [max_velocity_y]
        cmp ax, 0
        jle finish_closer_closer
        cmp ax, [max_velocity_y]
        jg doubleU
        sub [velocity_y], 1
        jmp finish_closer_closer
        doubleU:
            sub [velocity_y], 3
            jmp finish_closer_closer

    move_down:
        mov ax, [velocity_y]
        cmp ax, [max_velocity_y]
        jge finish
        cmp ax, 0
        jl doubleD
        add [velocity_y], 1
        jmp finish
        doubleD:
            add [velocity_y], 3
            jmp finish

    dush_closer:
        jmp dush

    move_right:
        mov ax, [velocity_x]
        cmp ax, [max_velocity_x]
        jge finish
        cmp ax, 0
        jl doubleR
        add [velocity_x], 1
        jmp finish
        doubleR:
            add [velocity_x], 3
            jmp finish

    finish_closer_closer:
        jmp finish

    move_left:
        mov ax, [velocity_x]
        add ax, [max_velocity_x]
        cmp ax, 0
        jle finish
        cmp ax, [max_velocity_x]
        jg doubleL
        sub [velocity_x], 1
        jmp finish
        doubleL:
            sub [velocity_x], 3
            jmp finish

    dush:
        mov ax, [dush_speed]
        mov [velocity_x], ax
        jmp finish

    finish:
        mov ax, [x_pos]
        add ax, [velocity_x]
        sub ax, [wing_distance]
        sub ax, [wings_size]
        cmp ax, [boundry]
        jle change_y
        add ax, [space_ship_size]
        add ax, [wing_distance]
        add ax, [wing_distance]
        add ax, [wings_size]
        add ax, [wings_size]
        add ax, [boundry]
        cmp ax, 320
        jge change_y
        mov ax, [velocity_x]
        add [x_pos], ax

        change_y:
            mov ax, [y_pos]
            add ax, [velocity_y]
            sub ax, [wing_distance]
            sub ax, [wing_distance]
            sub ax, [wings_size]
            sub ax, [wings_size]
            cmp ax, [boundry]
            jle qfunc
            add ax, [space_ship_size]
            xor cx, cx
            add cx, 4
            add_wing_distance:
                add ax, [wing_distance]
                loop add_wing_distance
            xor cx, cx
            add cx, 4
            add_wing_size:
                add ax, [wings_size]
                loop add_wing_size
            add ax, [boundry]
            cmp ax, 200
            jge qfunc
            mov ax, [velocity_y]
            add [y_pos], ax

    qfunc:
        call draw_space_ship

    pop ax
    ret
endp

proc move_astroids
    push ax
    push bx
    push cx
    push si

    mov si, offset astroids_array

    mov bl, [astroid_color]
    mov al, [background_color]
    mov [astroid_color], al
    call draw_astroid
    mov [astroid_color], bl

    xor cx, cx

    cmp [number_of_astroids], 0
    jle no_astroids_closer
    
    next_astroid:

    mov ax, [word astroid_velocity_x]
    sub [word si], ax
    mov ax, [word astroid_velocity_y]
    add [word si + 2], ax
    cmp [word si], 0
    jle remove
    mov ax, 200
    sub ax, [astroid_size_y]
    cmp [word si + 2], ax
    jl dont_remove

    remove:
    push si
    call remove_astroid
    pop si
    jmp no_collision

    no_astroids_closer:
        jmp no_astroids

    next_astroid_closer:
        jmp next_astroid

    dont_remove:
    mov ax, [x_pos]
    add ax, [space_ship_size]
    add ax, [wing_distance]
    add ax, [wings_size]
    cmp [word si], ax ;checks if the x position is greater then the player's
    jg no_collision

    mov ax, [x_pos]
    sub ax, [wing_distance]
    sub ax, [wings_size]
    sub ax, [astroid_size_x]
    cmp [word si], ax ;checks if the x position is lower then the player's
    jl no_collision

    mov ax, [y_pos]
    add ax, [space_ship_size]
    add ax, [wing_distance]
    add ax, [wing_distance]
    add ax, [wings_size]
    cmp [word si + 2], ax
    jg no_collision

    mov ax, [y_pos]
    sub ax, [wing_distance]
    sub ax, [wing_distance]
    sub ax, [wings_size]
    sub ax, [astroid_size_y]
    cmp [word si + 2], ax
    jl no_collision

    call collided_player
    jmp remove


    no_collision:
    add si, 4
    inc cx
    cmp cx, [number_of_astroids]
    jl next_astroid_closer

    call draw_astroid

    no_astroids:

    pop si
    pop cx
    pop bx
    pop ax
    ret
endp

proc remove_astroid
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si


    mov bx, [bp + 4]
    mov si, offset astroids_array

    xor cx, cx
    replace_astroid:
        cmp si, bx
        jle replace_next

        mov ax, [word si]
        mov [word si - 4], ax

        mov ax, [word si + 2]
        mov [word si - 2], ax

        replace_next:
        add si, 4
        inc cx
        cmp cx, [number_of_astroids]
        jl replace_astroid

        dec [number_of_astroids]

        pop si
        pop cx
        pop bx
        pop ax
        pop bp
        ret
endp

proc spawn_astroid
    push ax
    push cx
    push dx
    push si

    mov ax, [number_of_astroids]
    inc ax
    cmp ax, [max_number_of_astroids]
    jge dont_spawn

    mov cx, 13
    xor bx, bx
    xor dx, dx 

    RandLoop:
        mov ax, [Clock]         ; read timer counter
        mov ah, [byte cs:bx]    ; read one byte from memory
        xor al, ah              ; xor memory and counter
        and al, 00001111b       ; leave result between 0-15
        mov ah, 0
        add dx, ax
        inc bx
        loop RandLoop

    inc [number_of_astroids]
    mov si, offset astroids_array

    mov cx, [number_of_astroids]
    dec cx

    deeper_into_the_memory:
        add si, 4
        loop deeper_into_the_memory
    
    mov [word si], 320
    mov ax, [astroid_size_x]
    sub [word si], ax
    mov [word si + 2], dx
    
    dont_spawn:

    pop si
    pop dx
    pop cx
    pop ax
    ret
endp

proc update_health
    push ax
    push bx
    push cx
    push dx

    mov dl, 0ah

    mov bx, offset health_str
    
    gettoH$: ;set the bx in the right place
        inc bx
        cmp [byte bx], '$'
        jne gettoH$
    dec bx


    mov cx, [points]

    div10H:
    mov ax, cx
    div dl
    add ah, 30h
    mov [byte bx], ah
    dec bx
    xor ah, ah
    mov cx, ax

    cmp al, 0
    jg div10H

    pop dx
    pop cx
    pop bx
    pop ax
endp

proc add_points
    push ax
    push bx
    push cx
    push dx

    mov dl, 0ah

    mov bx, offset points_str
    
    getto$: ;set the bx in the right place
        inc bx
        cmp [byte bx], '$'
        jne getto$
    dec bx


    mov cx, [points]

    div10:
    mov ax, cx
    div dl
    add ah, 30h
    mov [byte bx], ah
    dec bx
    xor ah, ah
    mov cx, ax

    cmp al, 0
    jg div10

    pop dx
    pop cx
    pop bx
    pop ax
endp

proc draw_UI
    push ax
    push dx

    points:
    mov bh, 00h
    mov dh, 02h
    mov dl, 13h
    mov ah, 02h
    int 10h

    mov dx, offset points_str
    mov ah, 9h
    int 21h

    health:
    mov bh, 00h
    mov dh, 02h
    mov dl, 20h
    mov ah, 02h
    int 10h

    mov dx, offset health_str
    mov ah, 9h
    int 21h

    pop dx
    pop ax
    ret
endp

proc collided_player
    push ax

    mov ax, [health]
    cmp ax, 0
    jle Die
    sub [health], 1
    call update_health
    ret

    Die:
        call kill_player
    ret
endp

proc kill_player
    add [points], 1
    ret
endp

Start:
        mov ax, @data
        mov ds, ax

        mov ax, 40h
        mov es, ax

        call clear_screen
        mov bl, 0

        call draw_space_ship
       

        check_time:
            mov dl, [clock]
            cmp dl, [Time_Aux]
            je check_time
            mov [Time_Aux], dl
            inc [time_changes]
        
        cycle:
            call clear_player
            call move_player
            call move_astroids

            inc [time_since_last_spawn]
            mov ax, [time_since_last_spawn]
            cmp ax, [astroids_spawn_rate]
            jl dont_spawn_astroid
            mov [time_since_last_spawn], 0
            call spawn_astroid

            dont_spawn_astroid:

            call add_points
            call draw_UI
            jmp check_time

proc quit
    jmp Exit
    ret
endp

Exit:
        mov ax, 4C00h
        int 21h
		END start