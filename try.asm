IDEAL
		
MODEL small

STACK 256

DATASEG
;https://www.fountainware.com/EXPL/vga_color_palettes.htm color palette
Clock equ es:6Ch

Time_Aux db 0
time_changes dw 0
paused db 1

play db 1
gameover_str db "Game Over$"
len_game_over_str db 0
restart_str db "Press 'r' to restart$"
len_restart_str db 0
pause_str db "PAUSED", 3 dup(0ah), "press 'esc' to pause/continue$"

background_color db 00
boundry dw 5

;points
points_str db "000", "$"
points dw 00


;spaceship draw
space_ship_size dw 6
space_ship_color db 77h
space_ship_animation_color db 2fh
wing_distance dw 3
wings_size dw 3
window_color db 16h

last_key_pressed db 0
timer_pressed db 8

;player stats
x_pos dw 160
y_pos dw 100
velocity_x dw 0
velocity_y dw 0
max_velocity_x dw 5
max_velocity_y dw 3
dush_speed dw 0
health dw 5
health_str db "005", "$"

;energy
energy_weight dw 7
energy_height dw 10
energy_color db 00h, 37h, 34h, 2ch
;black, dark blue, cyan, yellow

energy_color_array db 0,0,21 dup (0), 4 dup(1), 3 dup(0), 5 dup(1),0, 0,1,1,2,2,1,0, 1,1,2,2,2,1,1, 2 dup(2 dup(1), 2,3,3,1,1), 13 dup(1),0,0,6 dup(1) 
;0,0,21 dup (0) ;;
;4 dup(1), 3 dup(0), ;;
;5 dup(1),0, ;;
;0,1,1,2,2,1,0, ;;
;1,1,2,2,2,1,1, ;;
;2 dup(2 dup(1), 2,3,3,1,1) ;; 
;13 dup(1),0,0,6 dup(1) ;;

energy_pos_x dw 100
energy_pos_y dw 150

;astroids
astroids_array dw 50, 77, 58, 158, 200, 50, 7 dup(0, 0)     ;x1,y1,x2,y2,x3,y3...
boosters dw 200, 170, 320,150, 8 dup(0,0)
number_of_astroids dw 3
number_of_boosters dw 2
max_number_of_astroids dw 10
max_number_of_boosters dw 10
astroid_size_x dw 15
astroid_size_y dw 10

;astroids colors
astroid_color db 00, 1bh, 16h, 13h ;darker
astroids_color_array db 5 dup(0), 5 dup(1), 5 dup(0)    ,4 dup(0), 3 dup(1), 5 dup(2), 3 dup(0)      ,2 dup(0), 7 dup(2), 3 dup(1), 3 dup(0)      ,0, 5 dup(2), 3 dup(3), 4 dup(1), 2 dup(0)      ,7 dup(2), 5 dup(3), 3 dup(0)      ,6 dup(3), 3 dup(1), 6 dup(3)      ,7 dup(3), 3 dup(1), 5 dup(3)      ,0,0,2, 5 dup(3), 5 dup(2),0,0     ,3 dup(0), 9 dup(2), 3 dup(0)      ,4 dup(0), 4 dup(2), 3 dup(1), 4 dup(0)

boosters_colors db 00, 1bh, 16h, 13h, 37h ;darker, cyan
boosters_color_array db 5 dup(0), 5 dup(1), 5 dup(0)    ,4 dup(0), 3 dup(1), 5 dup(2), 3 dup(0)      ,2 dup(0), 7 dup(2), 3 dup(4), 3 dup(0)      ,0, 5 dup(2), 3 dup(4), 4 dup(1), 2 dup(0)      ,7 dup(2), 5 dup(4), 3 dup(0)      ,6 dup(3), 3 dup(4), 6 dup(3)      ,7 dup(3), 3 dup(4), 5 dup(3)      ,0,0,2, 5 dup(3), 5 dup(2),0,0     ,3 dup(0), 9 dup(2), 3 dup(0)      ,4 dup(0), 4 dup(2), 3 dup(1), 4 dup(0)

;astroids' velocities
wave dw 5 ;for hardness functionality
astroids_spawn_rate dw 50
time_since_last_spawn dw 0
astroid_velocity_x dw 2
astroid_velocity_y dw 0


		
CODESEG

proc clear_screen ;enters graphic mode and set the background color
    mov ax, 13h ;320x200
    int 10h 

    mov bl, [background_color]
    xor bh, bh
    mov ah, 0bh
    int 10h
    ret
endp

proc clear_player ;basicly draws the player with the background color
    push ax
    push bx
    push cx

    mov al, [space_ship_color]
    mov ah, [window_color]
    mov cl, [space_ship_animation_color]

    mov bl, [background_color]
    mov [space_ship_color], bl
    mov [space_ship_animation_color], bl
    mov [window_color], bl
    call draw_space_ship
    
    mov [space_ship_color], al
    mov [window_color], ah
    mov [space_ship_animation_color], cl

    pop cx
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

    mov ax, [time_changes] ;change the color of the animation
    mov dl, 20
    div dl
    cmp ah, 0
    jne stay_color
    mov al, [space_ship_animation_color]
    mov ah, [space_ship_color]
    mov [space_ship_color], al
    mov [space_ship_animation_color], ah

    stay_color:

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
        mov bx, offset astroids_color_array
        mov dx, [word si + 2]
    vertical:
        mov cx, [word si]
    horizontal:
        push bx

        mov al, [byte bx] ;select the color according to the array
        xor ah, ah
        add ax, offset astroid_color
        mov bx, ax
        mov al, [byte bx] ;the right color
        mov bh, 0
        mov ah, 0ch
        int 10h

        pop bx
        inc bx

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

proc clear_astroid
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov si, offset astroids_array
    
    mov cx, [number_of_astroids]
    cmp cx, 0
    jle CLdont_draw
    CLdraw_next:
        push cx
        mov dx, [word si + 2]
    CLvertical:
        mov cx, [word si]
    CLhorizontal:
        mov bh, 0
        mov al, [background_color]
        mov ah, 0ch
        int 10h

        inc cx
        mov ax, [word si]
        add ax, [astroid_size_x]
        cmp cx, ax
        jl CLhorizontal

        inc dx
        mov ax, [word si + 2]
        add ax, [astroid_size_y]
        cmp dx, ax
        jl CLvertical
    add si, 4
    pop cx
    loop CLdraw_next

    CLdont_draw:

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

proc draw_boosters
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov si, offset boosters
    
    mov cx, [number_of_boosters]
    cmp cx, 0
    jle dont_draw
    BSTdraw_next:
        push cx
        mov bx, offset boosters_color_array
        mov dx, [word si + 2]
    BSTvertical:
        mov cx, [word si]
    BSThorizontal:
        push bx

        mov al, [byte bx] ;select the color according to the array
        xor ah, ah
        add ax, offset boosters_colors
        mov bx, ax
        mov al, [byte bx] ;the right color
        mov bh, 0
        mov ah, 0ch
        int 10h

        pop bx
        inc bx

        inc cx
        mov ax, [word si]
        add ax, [astroid_size_x]
        cmp cx, ax
        jl BSThorizontal

        inc dx
        mov ax, [word si + 2]
        add ax, [astroid_size_y]
        cmp dx, ax
        jl BSTvertical
    add si, 4
    pop cx
    loop BSTdraw_next

    BSTdont_draw:

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

proc clear_boosters
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov si, offset boosters
    
    mov cx, [number_of_boosters]
    cmp cx, 0
    jle BSTCLdont_draw
    BSTCLdraw_next:
        push cx
        mov dx, [word si + 2]
    BSTCLvertical:
        mov cx, [word si]
    BSTCLhorizontal:
        mov bh, 0
        mov al, [background_color]
        mov ah, 0ch
        int 10h

        inc cx
        mov ax, [word si]
        add ax, [astroid_size_x]
        cmp cx, ax
        jl BSTCLhorizontal

        inc dx
        mov ax, [word si + 2]
        add ax, [astroid_size_y]
        cmp dx, ax
        jl BSTCLvertical
    add si, 4
    pop cx
    loop BSTCLdraw_next

    BSTCLdont_draw:

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

proc draw_energy
    push ax
    push bx
    push cx
    push dx
    push si

    mov si, offset energy_color_array
    mov dx, [energy_pos_y]
    energy_veticalV2:
        mov cx, [energy_pos_x]
    energy_horizontalV2:
        mov bh, 0
        mov bx, offset energy_color
        add bl, [byte si]
        mov al, [bx]
        mov ah, 0ch
        int 10h
        inc si
        inc cx
        mov ax, [energy_pos_x]
        add ax, [energy_weight]
        cmp cx, ax
        jl energy_horizontalV2
        mov ax, [energy_pos_y]
        add ax, [energy_height]
        inc dx
        cmp dx, ax
        jl energy_veticalV2

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

proc clear_energy
    push ax
    push bx
    push cx
    push dx

    mov dx, [energy_pos_y]
    CLenergy_veticalV2:
        mov cx, [energy_pos_x]
    CLenergy_horizontalV2:
        mov bh, 0
        mov bx, offset energy_color
        mov al, [background_color]
        mov ah, 0ch
        int 10h
        inc cx
        mov ax, [energy_pos_x]
        add ax, [energy_weight]
        cmp cx, ax
        jl CLenergy_horizontalV2
        mov ax, [energy_pos_y]
        add ax, [energy_height]
        inc dx
        cmp dx, ax
        jl CLenergy_veticalV2

    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp



proc move_player
    push ax
    push cx

    mov ah, 01h
    int 16h

    jz dont_start_timer
    mov [timer_pressed], 8

    jmp move

    dont_start_timer: ;handle the long press delay
    dec [timer_pressed]
    cmp [timer_pressed], 0
    jle finish_closer
    cmp [last_key_pressed], 1bh
    je finish_closer
    mov al, [last_key_pressed]


    move:

    ;;;; clear keyboard buffer
    push ax
    mov ah, 0ch
    mov al, 00
    int 21h
    pop ax
    ;;;;
    mov [last_key_pressed], al
    

    cmp al, 1bh ;'esc'
    je pause_check
    cmp [paused], 0
    jne dont_pasue_here

    call draw_pause_UI
    jmp qfunc_closer

    dont_pasue_here:

    cmp al, 74h ;t
    je quit_closer
    cmp al, 54h ;T
    je quit_closer

    cmp al, 77h ;w
    je move_up_closer
    cmp al, 57h ;W
    je move_up_closer

    cmp al, 73h ;s
    je move_down_closer
    cmp al, 53h ;S
    je move_down_closer

    cmp al, 64h ;d
    je move_right_closer
    cmp al, 44h ;D
    je move_right_closer

    cmp al, 61h ;a
    je move_left_closer
    cmp al, 41h ;A            
    je move_left_closer

    cmp al, 20h ;'space'
    je dush_closer

    qfunc_closer:
    jmp qfunc

    finish_closer:
        cmp [velocity_x], 0
        jl addoneX
        je checkY
        dec [velocity_x]
        jmp checkY
        addoneX:
        inc [velocity_x]

        checkY:
        cmp [velocity_y], 0
        jl addoneY
        je finish_helper
        dec [velocity_y]
        jmp finish_helper
        addoneY:
        inc [velocity_y]

        finish_helper:
        jmp finish_closer_closer
    
    pause_check:
        call pause
        jmp qfunc

    quit_closer:
        call quit

    move_up_closer:
        jmp move_up
    move_down_closer:
        jmp move_down
    move_left_closer:
        jmp move_left
    move_right_closer:
        jmp move_right


    move_up:
        mov ax, [velocity_y]
        add ax, [max_velocity_y]
        cmp ax, 0
        jle finish_closer_closer
        cmp ax, [max_velocity_y]
        jge doubleU ;changes velocity faster if the player going the other direction
        sub [velocity_y], 2
        jmp finish_closer_closer
        doubleU:
            sub [velocity_y], 3
            jmp finish_closer_closer

    dush_closer:
        jmp dush

    move_down:
        mov ax, [velocity_y]
        cmp ax, [max_velocity_y]
        jge finish
        cmp ax, 0
        jle doubleD ;changes velocity faster if the player going the other direction
        add [velocity_y], 2
        jmp finish
        doubleD:
            add [velocity_y], 3
            jmp finish

    move_right:
        mov ax, [velocity_x]
        cmp ax, [max_velocity_x]
        jge finish
        cmp ax, 0
        jle doubleR ;changes velocity faster if the player going the other direction
        add [velocity_x], 2
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
        jge doubleL ;changes velocity faster if the player going the other direction
        sub [velocity_x], 2
        jmp finish
        doubleL:
            sub [velocity_x], 3
            jmp finish

    dush: ;an optional feature, might remove it later
        mov ax, [dush_speed]
        mov [velocity_x], ax
        jmp finish

    finish: ;checks the boundries of the x axis
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

        change_y: ;checks the boundries of the y axis
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

    qfunc: ;checks if touches the energy
        call draw_space_ship
        mov ax, [energy_pos_x]
        add ax, [energy_weight]
        cmp [x_pos], ax
        jg no_energy
        mov ax, [x_pos]
        add ax, [space_ship_size]
        add ax, [wing_distance]
        add ax, [wings_size]
        cmp ax, [energy_pos_x]
        jl no_energy
        mov ax, [y_pos]
        add ax, [space_ship_size]
        add ax, [wing_distance]
        add ax, [wing_distance]
        add ax, [wings_size]
        cmp ax, [energy_pos_y]
        jl no_energy
        mov ax, [energy_pos_y]
        add ax, [energy_height]
        cmp [y_pos], ax
        jg no_energy
        call collect_energy

        no_energy:

    pop cx
    pop ax
    ret
endp

proc move_astroids
    push ax
    push bx
    push cx
    push dx
    push si

    mov si, offset astroids_array

    call clear_astroid

    xor cx, cx

    cmp [number_of_astroids], 0
    jle no_astroids_closer
    
    next_astroid: ;adds the velocity and checks if hit the boundries

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

    dont_remove: ;checks if collides the player
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


    push 0
    call collided_player
    pop ax
    jmp remove

    no_collision:
    add si, 4
    inc cx
    cmp cx, [number_of_astroids]
    jl next_astroid_closer

    call draw_astroid

    no_astroids:

    move_boosters: ;;;;;;;;;;;;;;;;;;;;boosters

    mov si, offset boosters

    call clear_boosters

    xor cx, cx

    cmp [number_of_boosters], 0
    jle BSTno_astroids_closer
    
    BSTnext_astroid: ;add the velocity and check if hits the boundries

    mov ax, [word astroid_velocity_x]
    sub [word si], ax
    mov ax, [word astroid_velocity_y]
    add [word si + 2], ax
    cmp [word si], 0
    jle BSTremove
    mov ax, 200
    sub ax, [astroid_size_y]
    cmp [word si + 2], ax
    jl BSTdont_remove

    BSTremove:
    push si
    call remove_booster
    pop si
    jmp BSTno_collision

    BSTno_astroids_closer:
        jmp BSTno_astroids

    BSTnext_astroid_closer:
        jmp BSTnext_astroid

    BSTdont_remove: ;check if the booster collides the player
    mov ax, [x_pos] 
    add ax, [space_ship_size]
    add ax, [wing_distance]
    add ax, [wings_size]
    cmp [word si], ax ;checks if the x position is greater then the player's
    jg BSTno_collision

    mov ax, [x_pos]
    sub ax, [wing_distance]
    sub ax, [wings_size]
    sub ax, [astroid_size_x]
    cmp [word si], ax ;checks if the x position is lower then the player's
    jl BSTno_collision

    mov ax, [y_pos]
    add ax, [space_ship_size]
    add ax, [wing_distance]
    add ax, [wing_distance]
    add ax, [wings_size]
    cmp [word si + 2], ax
    jg BSTno_collision

    mov ax, [y_pos]
    sub ax, [wing_distance]
    sub ax, [wing_distance]
    sub ax, [wings_size]
    sub ax, [astroid_size_y]
    cmp [word si + 2], ax
    jl BSTno_collision


    mov ax, offset boosters
    sub si, ax
    mov ax, si
    mov dl, 4 ;every booster has the x and y, both are word, so 4 bytes
    div dl
    xor ah, ah
    inc ax ;the first one is the same place as the boosters' offset

    push ax
    call collided_player
    pop ax
    add si, offset boosters
    jmp BSTremove

    BSTno_collision:
    add si, 4
    inc cx
    cmp cx, [number_of_boosters]
    jl BSTnext_astroid_closer


    BSTno_astroids:
    call draw_boosters

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

proc remove_astroid ;removes an astroid and sets the array correctly
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

proc remove_booster ;removes a booster and sets the array according
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si


    mov bx, [bp + 4]
    mov si, offset boosters

    xor cx, cx
    BSTreplace_astroid:
        cmp si, bx
        jle BSTreplace_next

        mov ax, [word si]
        mov [word si - 4], ax

        mov ax, [word si + 2]
        mov [word si - 2], ax

        BSTreplace_next:
        add si, 4
        inc cx
        cmp cx, [number_of_boosters]
        jl BSTreplace_astroid

        dec [number_of_boosters]

        pop si
        pop cx
        pop bx
        pop ax
        pop bp
        ret
endp

proc spawn_astroid ;spawn either an astroid or a boost.
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

        cmp al, 13
        jg spawn_booster

    inc [number_of_astroids]
    mov si, offset astroids_array

    mov cx, [number_of_astroids]
    dec cx

    deeper_into_the_memory: ;sets si to be in the first free place of the array
        add si, 4
        loop deeper_into_the_memory
    
    mov [word si], 320
    mov ax, [astroid_size_x]
    sub [word si], ax
    mov [word si + 2], dx

    jmp dont_spawn

    spawn_booster:
    inc [number_of_boosters]
    mov si, offset boosters

    mov cx, [number_of_boosters]
    dec cx

    BSTdeeper_into_the_memory: ;sets si to be in the first free place if the array
        add si, 4
        loop BSTdeeper_into_the_memory
    
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

proc pause
    push ax
    push bx

    mov al, 1 ;switches the pause value
    sub al, [paused]
    mov [paused], al
    cmp al, 0
    jne clear_draw_pause_UI

    call draw_pause_UI ;draws the indicator of the pause
    jmp pause_return
    
    clear_draw_pause_UI: ;clears the pause indicator
    call clear_screen

    pause_return:


    pop bx
    pop ax
    ret
endp

proc draw_pause_UI
    push ax
    push bx
    push dx

    mov bh, 00h ;page
    mov dh, 02h
    mov dl, 3h  ;line
    mov ah, 02h
    int 10h

    mov dx, offset pause_str
    mov ah, 9h
    int 21h

    pop dx
    pop bx
    pop ax
    ret
endp


proc update_health ;convert the health variable to string - need to be called when chaging health!
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


    mov cx, [health]

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

proc upadate_points ;convert the points from the number object to the string, no need to call when chaging points, it is done automaticly
    push ax
    push bx
    push cx
    push dx

    mov dl, 0ah

    mov bx, offset points_str
    
    getto$: ;set the bx in the right place
        mov [byte bx], '0'
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

    dec [wave]

    pop dx
    pop cx
    pop bx
    pop ax
endp

proc draw_UI ;draw the UI, points and health
    push ax
    push dx

    draw_points:
    mov bh, 00h
    mov dh, 02h
    mov dl, 13h
    mov ah, 02h
    int 10h

    mov dx, offset points_str
    mov ah, 9h
    int 21h

    draw_health:
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

proc collided_player ;funcion that called after the player is hit by something, get 0 if it is an astroid, else it gives a random boost
    push bp
    mov bp, sp
    push ax

    mov ax, [word bp + 4]
    cmp ax, 0
    jne boost
    
    cmp [health], 1
    jle Die
    sub [health], 1
    call update_health
    jmp return

    boost:
    xor bx, bx ;random boost

    mov ax, [Clock]         ; read timer counter
    mov ah, [byte cs:bx]    ; read one byte from memory
    xor al, ah              ; xor memory and counter
    and al, 00001111b       ; leave result between 0-15
    mov ah, 0
    inc bx

    cmp ax, 9
    jg speed_boost
    cmp ax, 7
    jg points_boost

    health_boost:
        inc [health]
        call update_health
        jmp return

    speed_boost:
        inc [velocity_x]
        jmp return

    points_boost:
        add [points], 5
        call make_harder

    return:

    pop ax
    pop bp
    ret

    Die:
        call kill_player
    pop ax
    pop bp
    ret
endp

proc collect_energy
    push ax
    push bx
    push cx
    push dx

    inc [points]
    call clear_energy

    mov cx, 20
    xor bx, bx
    xor dx, dx 

    RandLoopEnergy1:
        mov ax, [Clock]         ; read timer counter
        mov ah, [byte cs:bx]    ; read one byte from memory
        xor al, ah              ; xor memory and counter
        and al, 00001111b       ; leave result between 0-15
        mov ah, 0
        add dx, ax
        inc bx
        loop RandLoopEnergy1

    mov [energy_pos_x], dx

    mov cx, 12
    xor bx, bx
    xor dx, dx 

    RandLoopEnergy2:
        mov ax, [Clock]         ; read timer counter
        mov ah, [byte cs:bx]    ; read one byte from memory
        xor al, ah              ; xor memory and counter
        and al, 00001111b       ; leave result between 0-15
        mov ah, 0
        add dx, ax
        inc bx
        loop RandLoopEnergy2

    mov [energy_pos_y], dx
    call make_harder


    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

proc make_harder ;called when collecting energy
    push ax
    push dx

    mov ax, [points]

    cmp ax, 30
    jl velocity_and_spawn_rate
    cmp ax, 70
    jl only_spawn_rate
    jmp only_velocity

    velocity_and_spawn_rate:
    mov dl, 10
    div dl
    xor ah, ah
    inc al
    mov [astroid_velocity_x], ax
    mov dx, 60
    sub dx, ax
    mov [astroids_spawn_rate], dx
    jmp make_harder_return

    only_spawn_rate:
    cmp [astroids_spawn_rate], 25
    jle make_harder_return
    mov dl, 5
    div dl
    mov al, ah
    xor ah, ah
    sub [astroids_spawn_rate], ax
    jmp make_harder_return

    only_velocity:
    cmp [astroid_velocity_x], 10
    jg make_harder_return
    mov dl, 4
    div dl
    cmp ah, 0
    jne make_harder_return
    inc [astroid_velocity_x]
    


    make_harder_return:

    pop dx
    pop ax
    ret
endp



proc kill_player
    mov [background_color], 0
    mov [play], 0
    call clear_player
    call clear_screen
    ret
endp

Start:
        mov ax, @data
        mov ds, ax

        mov ax, 40h
        mov es, ax

        startgame:

        mov bx, offset gameover_str
        find_length_gameover:
        cmp [byte bx], '$'
        je set_length_gameover
        inc bx
        jmp find_length_gameover

        set_length_gameover:
        sub bx, offset gameover_str
        mov ax, bx
        mov dl, 2
        div dl
        mov [len_game_over_str], al
        xor ah, ah

        mov bx, offset restart_str
        find_length_restart:
        cmp [byte bx], '$'
        je set_length_restart
        inc bx
        jmp find_length_restart

        set_length_restart:
        sub bx, offset restart_str
        mov ax, bx
        mov dl, 2
        div dl
        mov [len_restart_str], al
        xor ah, ah

        call clear_screen
        mov bl, 0

        call draw_space_ship
        call draw_energy
        call pause
       

        check_time:
            mov dl, [clock]
            cmp dl, [Time_Aux]
            je check_time
            mov [Time_Aux], dl
            inc [time_changes]
        
        cycle:
            cmp [play], 0
            je GameOver
            call clear_player
            call move_player
            cmp [paused], 0
            je check_time
            call move_astroids
            call draw_energy

            inc [time_since_last_spawn]
            mov ax, [time_since_last_spawn]
            cmp ax, [astroids_spawn_rate]
            jl dont_spawn_astroid
            mov [time_since_last_spawn], 0
            call spawn_astroid

            dont_spawn_astroid:

            call upadate_points
            call draw_UI
            jmp check_time

            jmp GameOver
            startgame_closer:
                jmp startgame

            GameOver:
            mov dl, 13h
            sub dl, [len_game_over_str]
            mov bh, 00h
            mov dh, 8h
            mov ah, 02h
            int 10h

            mov dx, offset gameover_str
            mov ah, 9h
            int 21h

            mov dl, 13h
            sub dl, [len_restart_str]
            mov bh, 00h
            mov dh, 010h
            mov ah, 02h
            int 10h

            mov dx, offset restart_str
            mov ah, 9h
            int 21h


            xor ah, ah
            int 16h
            cmp al, 72h
            je restart
            cmp al, 52h
            je restart
            
            call quit
            restart:
                mov [paused], 1
                mov [health], 5
                mov [points], 0
                mov [velocity_x], 0
                mov [velocity_y], 0
                mov [x_pos], 160
                mov [y_pos], 100
                mov [play], 1
                call update_health
                call upadate_points
                call draw_UI
                jmp startgame_closer

proc quit
    jmp Exit
    ret
endp

Exit:
        mov ax, 4C00h
        int 21h
		END start