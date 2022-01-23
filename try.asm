IDEAL
		
MODEL small

STACK 256

DATASEG
;https://www.fountainware.com/EXPL/vga_color_palettes.htm color palette
Clock equ es:6Ch
NextRandom dw 0

Time_Aux db 0
time_changes dw 0
paused db 1

play db 1
menu_str db "WELCOME TO SELF_DESTRUCT!$" 
menu2_str db "PRESS 'SPACE' TO START!$"
len_menu_str db 0
len_menu2_str db 0
gameover_str db "Game Over$"
len_game_over_str db 0
restart_str db "Press 'r' to restart$"
len_restart_str db 0
pause_str db "PAUSED", 3 dup(0ah), "press 'esc' to pause/continue$"

;menu image
filename db 'menu.bmp',0
filehandle dw ?
Header db 54 dup (0)
Palette db 256*4 dup (0)
ScrLine db 320 dup (0) ;320 deafult
ErrorMsg db 'Error in opening image', 13, 10 ,'$'
BMP_lines dw 200 ;200 deafult
BMP_rows dw 320 ;320 deafult

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
timer_pressed db 100

;player stats
x_pos dw 160
y_pos dw 100
speed dw 1
direction dw 0, 0
max_velocity_x dw 5
max_velocity_y dw 3
dush_speed dw 0
health dw 5
health_str db "005", "$"


;indicators
fire_time db 18
fire_weight dw 15
fire_height dw 10
fire_x_pos dw 0
fire_y_pos dw 0
fire_colors db 00h, 29h, 2ah, 2bh, 2ch ;black, red, red-orange, orange, yellow
fire_color_array db 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 1, 2, 3, 3
                 db 0, 0, 0, 0, 0, 0, 1, 2, 3, 3, 3, 3, 3, 3, 2
                 db 0, 1, 1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 3, 4, 2
                 db 2, 4, 4, 4, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 2
                 db 2, 4, 4, 4, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 2
                 db 1, 2, 4, 4, 4, 4, 3, 3, 3, 4, 4, 4, 2, 4, 2
                 db 0, 1, 2, 2, 4, 4, 3, 3, 3, 3, 2, 2, 2, 2, 2
                 db 0, 1, 2, 2, 2, 4, 3, 3, 3, 3, 3, 3, 3, 3, 2
                 db 0, 0, 1, 2, 3, 3, 3, 3, 2, 3, 3, 3, 3, 3, 2
                 db 0, 0, 0, 1, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 1

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
asteroids_array dw 50, 77, 58, 158, 200, 50, 7 dup(0, 0)     ;x1,y1,x2,y2,x3,y3...
boosters dw 200, 170, 300,150, 8 dup(0,0)
number_of_astroids dw 3
number_of_boosters dw 2
max_number_of_astroids dw 10
max_number_of_boosters dw 10
astroid_size_x dw 15
astroid_size_y dw 10

;astroids colors
astroid_color db 00, 1bh, 16h, 13h ;darker
astroids_color_array db 5 dup(0), 5 dup(1), 5 dup(0)
    db 4 dup(0), 3 dup(1), 5 dup(2), 3 dup(0)      
    db 2 dup(0), 7 dup(2), 3 dup(1), 3 dup(0)      
    db 0, 5 dup(2), 3 dup(3), 4 dup(1), 2 dup(0)      
    db 7 dup(2), 5 dup(3), 3 dup(0)      
    db 6 dup(3), 3 dup(1), 6 dup(3)      
    db 7 dup(3), 3 dup(1), 5 dup(3)      
    db 0,0,2, 5 dup(3), 5 dup(2),0,0     
    db 3 dup(0), 9 dup(2), 3 dup(0)      
    db 4 dup(0), 4 dup(2), 3 dup(1), 4 dup(0)

boosters_colors db 00, 1bh, 16h, 13h, 37h ;darker, cyan
boosters_color_array db 5 dup(0), 5 dup(1), 5 dup(0)    ,4 dup(0), 3 dup(1), 5 dup(2), 3 dup(0)      ,2 dup(0), 7 dup(2), 3 dup(4), 3 dup(0)      ,0, 5 dup(2), 3 dup(4), 4 dup(1), 2 dup(0)      ,7 dup(2), 5 dup(4), 3 dup(0)      ,6 dup(3), 3 dup(4), 6 dup(3)      ,7 dup(3), 3 dup(4), 5 dup(3)      ,0,0,2, 5 dup(3), 5 dup(2),0,0     ,3 dup(0), 9 dup(2), 3 dup(0)      ,4 dup(0), 4 dup(2), 3 dup(1), 4 dup(0)

;astroids' velocities
wave dw 5 ;for hardness functionality
astroids_spawn_rate dw 50
time_since_last_spawn dw 0
astroid_velocity_x dw 2
astroid_velocity_y dw 0


		
CODESEG

;; returns pseudo random number of 2 bytes in ax. The seed is set and updated in NextRandom.
proc prg
    push dx
    xor dx, dx

    mov ax, [NextRandom]
    mov dx, 25173
    imul dx

    add  ax, 13849
    xor  ax, 62832
    mov  [NextRandom], ax

    pop dx
    ret
endp

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

    mov al, [space_ship_color] ;saves the original colors of the spaceship
    mov ah, [window_color]
    mov cl, [space_ship_animation_color]

    mov bl, [background_color] ;changes the colors to the background color
    mov [space_ship_color], bl
    mov [space_ship_animation_color], bl
    mov [window_color], bl
    call draw_space_ship
    
    mov [space_ship_color], al ;bring back the original colors
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
    
    mov si, offset asteroids_array
    
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
    
    mov si, offset asteroids_array
    
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

proc draw_fire
    push ax
    push bx
    push cx
    push dx
    push si

    mov si, offset fire_color_array
    mov dx, [fire_y_pos]
    fire_veticalV2:
        mov cx, [fire_x_pos]
    fire_horizontalV2:
        mov bh, 0
        mov bx, offset fire_colors
        add bl, [byte si]
        mov al, [bx]
        mov ah, 0ch
        int 10h
        inc si
        inc cx
        mov ax, [fire_x_pos]
        add ax, [fire_weight]
        cmp cx, ax
        jl fire_horizontalV2
        mov ax, [fire_y_pos]
        add ax, [fire_height]
        inc dx
        cmp dx, ax
        jl fire_veticalV2

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

proc clear_fire
    push ax
    push bx
    push cx
    push dx

    mov dx, [fire_y_pos]
    CLfire_veticalV2:
        mov cx, [fire_x_pos]
    CLfire_horizontalV2:
        mov bh, 0
        mov bx, offset fire_colors
        mov al, [background_color]
        mov ah, 0ch
        int 10h
        inc cx
        mov ax, [fire_x_pos]
        add ax, [fire_weight]
        cmp cx, ax
        jl CLfire_horizontalV2
        mov ax, [fire_y_pos]
        add ax, [fire_height]
        inc dx
        cmp dx, ax
        jl CLfire_veticalV2

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
    mov [timer_pressed], 10

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
    je pause_check_closer
    cmp [paused], 0
    jne dont_pasue_here

    call draw_pause_UI
    jmp qfunc_closer

    dont_pasue_here:

    mov bx, [speed]

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
    jmp qfunc_closer_closer

    quit_closer:
        call quit

    pause_check_closer:
    jmp pause_check

    finish_closer:
        mov [word direction], 0
        mov [word direction + 2], 0

        finish_helper:
        jmp finish_closer_closer

        move_up_closer:
            jmp move_up
        move_down_closer:
            jmp move_down
        move_left_closer:
            jmp move_left
        move_right_closer:
            jmp move_right 
        dush_closer:
        jmp dush   
    
    pause_check:
        call pause
        jmp qfunc


    move_up:
        mov ax, [word direction + 2]
        add ax, [max_velocity_y]
        cmp ax, 0
        jle finish_closer_closer
        cmp ax, [max_velocity_y]
        jge doubleU ;changes velocity faster if the player going the other direction
        sub [word direction + 2], 2
        sub [word direction + 2], bx
        jmp finish_closer_closer
        doubleU:
            sub [word direction + 2], 3
            sub [word direction + 2], bx
            jmp finish_closer_closer

    move_down:
        mov ax, [word direction + 2]
        cmp ax, [max_velocity_y]
        jge finish
        cmp ax, 0
        jle doubleD ;changes velocity faster if the player going the other direction
        add [word direction + 2], 2
        add [word direction + 2], bx
        jmp finish
        doubleD:
            add [word direction + 2], 3
            add [word direction + 2], bx
            jmp finish

    move_right:
        mov ax, [word direction]
        cmp ax, [max_velocity_x]
        jge finish
        cmp ax, 0
        jle doubleR ;changes velocity faster if the player going the other direction
        add [word direction], 2
        sub [word direction], bx
        jmp finish
        doubleR:
            add [word direction], 3
            add [word direction], bx
            jmp finish

    finish_closer_closer:
        jmp finish

    qfunc_closer_closer:
    jmp qfunc

    move_left:
        mov ax, [word direction]
        add ax, [max_velocity_x]
        cmp ax, 0
        jle finish
        cmp ax, [max_velocity_x]
        jge doubleL ;changes velocity faster if the player going the other direction
        sub [word direction], 2
        sub [word direction], bx
        jmp finish
        doubleL:
            sub [word direction], 3
            sub [word direction], bx
            jmp finish

    dush: ;an optional feature, might remove it later
        mov ax, [dush_speed]
        mov [word direction], ax
        jmp finish

    finish: ;checks the boundries of the x axis
        mov ax, [x_pos]
        add ax, [word direction]
        add ax, bx
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
        mov ax, [word direction]
        add [x_pos], ax

        change_y: ;checks the boundries of the y axis
            mov ax, [y_pos]
            add ax, [word direction + 2]
            add ax, bx
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
            mov ax, [word direction + 2]
            add [y_pos], ax

    qfunc: ;checks if touches the energy
        call draw_space_ship
        mov ax, [energy_pos_x] ;24
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
        cmp ax, [energy_pos_y] ;225
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

    mov si, offset asteroids_array

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
    mov si, offset asteroids_array

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

    call prg
    and ax, 0000000001111111b
    add ax, 10h
    mov dx, ax

    call prg
    and ax, 0000000000001111b
    cmp ax, 12
    jge spawn_booster

    inc [number_of_astroids]
    mov si, offset asteroids_array

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
    call prg

    and ax, 0000000000001111b

    cmp ax, 9
    jg speed_boost
    cmp ax, 7
    jg points_boost

    health_boost:
        inc [health]
        call update_health
        jmp return

    speed_boost:
        inc [speed]
        mov ax, [x_pos]
        sub ax, 10
        mov [fire_x_pos], ax
        mov ax, [y_pos]
        add ax, 7
        mov [fire_y_pos], ax
        mov [fire_time], 18
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

    call prg ;gets a 2 bytes random number

    and ax, 0000000011111111b ;range 0 - 256
    add ax, 10h               ;range 16 - 272

    mov [energy_pos_x], ax

    call prg ;gets a 2 bytes random number

    and ax, 0000000001111111b ;range 0 - 128
    add ax, 10h               ;range 16 - 144

    mov [energy_pos_y], ax
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

proc check_indicators
    push ax

    cmp [fire_time], 1
    je dont_draw_fire
    jl check_indicators_ret

    call clear_fire
    mov ax, [x_pos]
    sub ax, 20
    mov [fire_x_pos], ax
    mov ax, [y_pos]
    mov [fire_y_pos], ax
    call draw_fire
    dec [fire_time]
    jmp check_indicators_ret

    dont_draw_fire:
    call clear_fire
    dec [fire_time]

    check_indicators_ret:

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

proc OpenFile

    ; Open file

    mov ah, 3Dh
    xor al, al
    mov dx, offset filename
    int 21h

    jc openerror
    mov [filehandle], ax
    ret

    openerror:
    mov dx, offset ErrorMsg
    mov ah, 9h
    int 21h
    ret
endp

proc ReadHeader

    ; Read BMP file header, 54 bytes

    mov ah,3fh
    mov bx, [filehandle]
    mov cx,54
    mov dx,offset Header
    int 21h
    ret
    endp ReadHeader
    proc ReadPalette

    ; Read BMP file color palette, 256 colors * 4 bytes (400h)

    mov ah,3fh
    mov cx,400h
    mov dx,offset Palette
    int 21h
    ret
endp

proc CopyPal

    ; Copy the colors palette to the video memory
    ; The number of the first color should be sent to port 3C8h
    ; The palette is sent to port 3C9h

    mov si,offset Palette
    mov cx,256
    mov dx,3C8h
    mov al,0

    ; Copy starting color to port 3C8h

    out dx,al

    ; Copy palette itself to port 3C9h

    inc dx
    PalLoop:

    ; Note: Colors in a BMP file are saved as BGR values rather than RGB.

    mov al,[si+2] ; Get red value.
    shr al,2 ; Max. is 255, but video palette maximal

    ; value is 63. Therefore dividing by 4.

    out dx,al ; Send it.
    mov al,[si+1] ; Get green value.
    shr al,2
    out dx,al ; Send it.
    mov al,[si] ; Get blue value.
    shr al,2
    out dx,al ; Send it.
    add si,4 ; Point to next color.

    ; (There is a null chr. after every color.)

    loop PalLoop
    ret
endp

proc CopyBitmap

    ; BMP graphics are saved upside-down.
    ; Read the graphic line by line (200 lines in VGA format),
    ; displaying the lines from bottom to top.

    mov ax, 0A000h
    mov es, ax
    mov cx,[BMP_lines] ;BMP_lines is how many lines the file is
    PrintBMPLoop:
    push cx

    ; di = cx*320, point to the correct screen line

    mov di,cx
    shl cx,6
    shl di,8
    add di,cx

    ; Read one line

    mov ah,3fh
    mov cx,[BMP_rows]
    mov dx,offset ScrLine
    int 21h

    ; Copy one line into video memory

    cld 

    ; Clear direction flag, for movsb

    mov cx,320
    mov si,offset ScrLine
    rep movsb 

    ; Copy line to the screen
    ;rep movsb is same as the following code:
    ;mov es:di, ds:si
    ;inc si
    ;inc di
    ;dec cx
    ;loop until cx=0

    pop cx
    loop PrintBMPLoop
    ret
endp


proc menu_img
    ; Process BMP file
    call OpenFile
    call ReadHeader
    call ReadPalette
    call CopyPal
    call CopyBitmap
    ret
endp


proc menu
    push ax
    push bx
    push dx

    call menu_img

    mov dl, 13h ;prints the menu txt
    sub dl, [len_menu_str]
    mov bh, 00h
    mov dh, 05h
    mov ah, 02h
    mov al, 5
    int 10h

    mov dx, offset menu_str
    mov ah, 9h
    int 21h

    mov dl, 13h ;prints the menu2 txt
    sub dl, [len_menu2_str]
    mov bh, 00h
    mov dh, 15h
    mov ah, 02h
    int 10h

    mov dx, offset menu2_str
    mov ah, 9h
    int 21h

    wait_for_space:
    mov ah, 0
    int 16h
    cmp al, " "
    jne wait_for_space

    call clear_screen

    pop dx
    pop bx
    pop ax
    ret
endp

proc set_size ;set the unchanged sizes
    push ax
    push bx
    push dx

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

    mov bx, offset menu_str
    find_length_menu:
    cmp [byte bx], '$'
    je set_length_menu
    inc bx
    jmp find_length_menu

    set_length_menu:
    sub bx, offset menu_str
    mov ax, bx
    mov dl, 2
    div dl
    mov [len_menu_str], al
    xor ah, ah

    mov bx, offset menu2_str
    find_length_menu2:
    cmp [byte bx], '$'
    je set_length_menu2
    inc bx
    jmp find_length_menu2

    set_length_menu2:
    sub bx, offset menu2_str
    mov ax, bx
    mov dl, 2
    div dl
    mov [len_menu2_str], al
    xor ah, ah

    pop dx
    pop bx
    pop ax
    ret
endp


Start:
        mov ax, @data
        mov ds, ax

        mov ax, 40h
        mov es, ax

        startgame:
        call set_size

        call clear_screen
        mov bl, 0

        push es
        call menu
        pop es

        xor dx, [Clock]
        mov [NextRandom], dx

        call draw_space_ship
        call draw_energy

        check_time:
            mov dl, [Clock]
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
            call check_indicators

            inc [time_since_last_spawn] ;check ifneed to spawn an astroid
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
            mov dl, 13h ;prints the game over screen
            sub dl, [len_game_over_str]
            mov bh, 00h
            mov dh, 8h
            mov ah, 02h
            int 10h

            mov dx, offset gameover_str
            mov ah, 9h
            int 21h

            mov dl, 13h ;prints the restar screen
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
                mov [paused], 1 ;restart all the variables
                mov [health], 5
                mov [points], 0
                mov [word direction], 0
                mov [word direction + 2], 0
                mov [x_pos], 160
                mov [y_pos], 100
                mov [play], 1
                call update_health
                call upadate_points
                call draw_UI
                jmp startgame_closer

proc quit ;a debug function
    jmp Exit
    ret
endp

Exit:
        mov ax, 4C00h
        int 21h
		END start