IDEAL
		
MODEL small

STACK 256

DATASEG
;https://www.fountainware.com/EXPL/vga_color_palettes.htm color palette
Clock equ es:6Ch
NextRandom dw 0

Time_Aux db 0
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
music_str db "D1B1D1D1  D1B1D1D1  B1D1G1F1E1E1    C1A1C1C1     C1A1C1C1   A1C1F1E1D1D1   D1B1D1D1  D1B1D1D1  B1D1G1F1E1E1   F1 F1 F1F1    F1 F1 F1F1   G1D1E1F1G1G1G1 $"
music_table dw 110, 123, 131, 147, 165, 175, 196
music_len dw 66
music_speed db 10
music_break_len db 1
nt db 0
mp dw 0

;menu image
filename db 'menu.bmp', 0
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
points_str db "000000", 4, "$"
points dw 00


;spaceship draw
space_ship_size dw 5 ;6
space_ship_color db 77h
space_ship_animation_color db 2fh
wing_distance dw 2 ;3
wings_size dw 3 ;3
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
health dw 5
health_str db "005", 3, "$"


;indicators
fire_time db 0
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

boost_speed dw 5

health_timer db 0
health_weight dw 16
health_height dw 13
health_x_pos dw 0
health_y_pos dw 0
health_color db 00, 28h ;black, red
health_color_array db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                   db 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0
                   db 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
                   db 0, 1, 1, 1, 1, 1, 1, 1 ,1, 1, 1, 1 ,1 ,1, 1, 0
                   db 16 dup (1)
                   db 16 dup(1)
                   db 16 dup(1)
                   db 0, 1, 1, 1, 1, 1, 1, 1 ,1, 1, 1, 1 ,1 ,1, 1, 1
                   db 0, 1, 1, 1, 1, 1, 1, 1 ,1, 1, 1, 1 ,1 ,1, 1, 0
                   db 0, 0, 1, 1, 1, 1, 1, 1 ,1, 1, 1, 1 ,1 ,1, 0, 0
                   db 0, 0, 0, 1, 1, 1, 1, 1 ,1, 1, 1, 1 ,1 ,0, 0, 0
                   db 0, 0, 0, 0, 1, 1, 1, 1 ,1, 1, 1, 1, 0, 0, 0, 0
                   db 0, 0, 0, 0, 0, 1, 1, 1 ,1, 1, 1, 0 ,0, 0, 0, 0
shield_timer db 0
shield_color db 37h
shield_weight dw 5
shield_height dw 20
shield_height_now dw 20
shield_x_pos dw 0
shield_y_pos dw 0


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
powerups dw 200, 170, 300,150, 8 dup(0,0)
number_of_astroids dw 3
number_of_powerups dw 2
max_number_of_astroids dw 10
max_number_of_powerups dw 10
asteroid_size_x dw 15
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

powerups_colors db 00, 1bh, 16h, 13h, 37h ;darker, cyan
powerups_color_array db 5 dup(0), 5 dup(1), 5 dup(0)    ,4 dup(0), 3 dup(1), 5 dup(2), 3 dup(0)      ,2 dup(0), 7 dup(2), 3 dup(4), 3 dup(0)      ,0, 5 dup(2), 3 dup(4), 4 dup(1), 2 dup(0)      ,7 dup(2), 5 dup(4), 3 dup(0)      ,6 dup(3), 3 dup(4), 6 dup(3)      ,7 dup(3), 3 dup(4), 5 dup(3)      ,0,0,2, 5 dup(3), 5 dup(2),0,0     ,3 dup(0), 9 dup(2), 3 dup(0)      ,4 dup(0), 4 dup(2), 3 dup(1), 4 dup(0)

;astroids' velocities
wave dw 5 ;for hardness functionality
astroids_spawn_rate dw 50
time_since_last_spawn dw 0
astroid_velocity_x dw 2
astroid_velocity_y dw 0

;fire astroids
fire_asteroids_array dw 10 dup(0, 0)     ;x1,y1,x2,y2,x3,y3...number_of_fire_asteroids dw 1
number_of_fire_asteroids dw 0
max_number_of_fire_astroid dw 10
fire_asteroids_weight dw 18
fire_asteroids_height dw 20

;super astroids colors
fire_astroid_colors db 00, 1bh, 16h, 29h, 2ah, 2ch ;black, dark grey, grey, red, orange, yellow
fire_astroids_color_array   db 0, 0, 0, 0, 0, 0, 0, 0, 5, 4, 4, 0, 0, 5, 3, 4, 4, 0 ;1
                            db 0, 0, 0, 0, 0, 0, 0, 3, 4, 4, 0, 0, 5, 3, 3, 0, 0, 3 ;2
                            db 0, 0, 0, 0, 0, 0, 3, 3, 4, 0, 0, 5, 3, 3, 0, 0, 5, 3 ;3
                            db 0, 0, 0, 0, 0, 3, 3, 4, 0, 5, 3, 3, 3, 0, 0, 4, 3, 3 ;4
                            db 0, 0, 0, 0, 3, 3, 4, 0, 3, 3, 3, 4, 0, 4, 4, 4, 0, 0 ;5
                            db 0, 0, 0, 3, 3, 4, 3, 3, 5, 0, 4, 0, 4, 4, 0, 0, 0, 5 ;6
                            db 0, 0, 0, 3, 4, 4, 5, 5, 4, 4, 0, 4, 4, 5, 0, 5, 5, 5 ;7
                            db 0, 0, 0, 4, 4, 5, 5, 4, 4, 0, 4, 5, 0, 5, 5, 5, 3, 3 ;8
                            db 0, 0, 0, 4, 5, 2, 2, 4, 5, 5, 4, 0, 5, 5, 4, 4, 3, 0 ;9
                            db 0, 0, 0, 5, 2, 2, 2, 5, 5, 4, 5, 5, 4, 4, 0, 0, 0, 3 ;10
                            db 0, 0, 2, 2, 2, 3, 5, 2, 4, 5, 5, 0, 4, 0, 5, 5, 3, 3 ;11
                            db 0, 2, 2, 2, 1, 1, 2, 4, 5, 2, 4, 4, 5, 5, 0, 3, 3, 4 ;12
                            db 0, 2, 2, 2, 1, 2, 2, 2, 2, 4, 4, 5, 0, 4, 3, 3, 0, 0 ;13
                            db 0, 2, 2, 1, 1, 2, 2, 2, 4, 5, 4, 4, 4, 0, 0, 0, 0, 0 ;14
                            db 2, 2, 2, 1, 2, 2, 2, 1, 1, 5, 4, 0, 0, 0, 0, 0, 0, 0 ;15
                            db 2, 2, 2, 2, 2, 2, 1, 1, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0 ;16
                            db 2, 2, 2, 1, 1, 1, 1, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0 ;17
                            db 0, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ;18
                            db 0, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ;19
                            db 18 dup(0)                                            ;20

;fire astroids' velocities
fire_astroids_spawn_rate dw 50
time_since_last_spawn_fireA dw 0
fire_astroid_velocity_x dw 3
fire_astroid_velocity_y dw 5


		
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

    mov al, [Time_Aux] ;change the color of the animation
    xor ah, ah
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
        add ax, [asteroid_size_x]
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
        add ax, [asteroid_size_x]
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

proc draw_fire_astroids
    push ax
    push cx
    push si

    mov si, offset fire_asteroids_array
    mov cx, [number_of_fire_asteroids]

    cmp cx, 0
    jle draw_fire_astroids_ret

    sub si, 4

    next_fire_astroid:
        push cx

        add si, 4
        push [fire_asteroids_height]
        push [fire_asteroids_weight]
        push [word si + 2]
        push [word si]
        push offset fire_astroids_color_array
        push offset fire_astroid_colors

        call draw_bytes

        mov cx, 6
        popfire_astroids:
        pop ax
        loop popfire_astroids

        pop cx
        loop next_fire_astroid

    draw_fire_astroids_ret:

    pop si
    pop cx
    pop ax
    ret
endp

proc clear_fire_astroids
    push ax
    push cx
    push si

    mov si, offset fire_asteroids_array
    mov cx, [number_of_fire_asteroids]

    cmp cx, 0
    jle clear_fire_astroids_ret

    sub si, 4

    CLnext_fire_astroid:
        push cx

        add si, 4
        push [fire_asteroids_height]
        push [fire_asteroids_weight]
        push [word si + 2]
        push [word si]

        call clear_bytes

        mov cx, 4
        CLpopfire_astroids:
        pop ax
        loop CLpopfire_astroids

        pop cx
        loop CLnext_fire_astroid

    clear_fire_astroids_ret:

    pop si
    pop cx
    pop ax
    ret
endp

proc draw_powerups
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov si, offset powerups
    
    mov cx, [number_of_powerups]
    cmp cx, 0
    jle BSTdont_draw
    BSTdraw_next:
        push cx
        mov bx, offset powerups_color_array
        mov dx, [word si + 2]
    BSTvertical:
        mov cx, [word si]
    BSThorizontal:
        push bx

        mov al, [byte bx] ;select the color according to the array
        xor ah, ah
        add ax, offset powerups_colors
        mov bx, ax
        mov al, [byte bx] ;the right color
        mov bh, 0
        mov ah, 0ch
        int 10h

        pop bx
        inc bx

        inc cx
        mov ax, [word si]
        add ax, [asteroid_size_x]
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

proc clear_powerups
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov si, offset powerups
    
    mov cx, [number_of_powerups]
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
        add ax, [asteroid_size_x]
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

proc draw_shield
    push ax
    push bx
    push cx
    push dx

    mov dx, [shield_y_pos]
    shield_vertical:
    mov cx, [shield_x_pos]
    shield_horizontal:
        mov bh, 0
        mov al, [shield_color]
        mov ah, 0ch
        int 10h
        inc cx
        mov ax, [shield_x_pos]
        add ax, [shield_weight]
        cmp cx, ax
        jl shield_horizontal
        inc dx
        mov ax, [shield_y_pos]
        add ax, [shield_height_now]
        cmp dx, ax
        jl shield_vertical

    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

proc clear_shield
    push [shield_height]
    push [shield_weight]
    push [shield_y_pos]
    push [shield_x_pos]

    call clear_bytes

    mov cx, 4
    popshieldloop:
        pop ax
        loop popshieldloop

    ret
endp



proc draw_fire
    push [fire_height]
    push [fire_weight]
    push [fire_y_pos]
    push [fire_x_pos]
    push offset fire_color_array
    push offset fire_colors

    call draw_bytes

    mov cx, 6
    popfireloop:
        pop ax
        loop popfireloop
    ret
endp

proc clear_fire
    push [fire_height]
    push [fire_weight]
    push [fire_y_pos]
    push [fire_x_pos]

    call clear_bytes

    mov cx, 4
    popCLfireloop:
        pop ax
        loop popCLfireloop
    ret
endp

proc draw_health
    push [health_height]
    push [health_weight]
    push [health_y_pos]
    push [health_x_pos]
    push offset health_color_array
    push offset health_color

    call draw_bytes

    mov cx, 6
    pophealthloop:
        pop ax
        loop pophealthloop
    ret
endp

proc clear_health
    push [health_height]
    push [health_weight]
    push [health_y_pos]
    push [health_x_pos]

    call clear_bytes

    mov cx, 4
    popCLhealthloop:
        pop ax
        loop popCLhealthloop
    ret
endp


proc draw_bytes ;gets: 1) colors offset, 2) bytes array offset, 3) x pos 4) y pos 5) weight 6) height
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si

    mov si, [bp + 6]
    mov dx, [bp + 10]
    bytes_veticalV2:
        mov cx, [bp + 8]
    bytes_horizontalV2:
        mov bh, 0
        mov bx, [bp + 4]
        add bl, [byte si]
        mov al, [bx]
        mov ah, 0ch
        int 10h
        inc si
        inc cx
        mov ax, [bp + 8]
        add ax, [bp + 12]
        cmp cx, ax
        jl bytes_horizontalV2
        mov ax, [bp + 10]
        add ax, [bp + 14]
        inc dx
        cmp dx, ax
        jl bytes_veticalV2

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret
endp

proc clear_bytes ;gets: 1) x pos 2) y pos 3) weight 4) height
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si

    mov dx, [bp + 6]
    CLbytes_veticalV2:
        mov cx, [bp + 4]
    CLbytes_horizontalV2:
        mov bh, 0
        mov al, [background_color]
        mov ah, 0ch
        int 10h
        inc si
        inc cx
        mov ax, [bp + 4]
        add ax, [bp + 8]
        cmp cx, ax
        jl CLbytes_horizontalV2
        mov ax, [bp + 6]
        add ax, [bp + 10]
        inc dx
        cmp dx, ax
        jl CLbytes_veticalV2

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret
endp

proc hit_player ;gets: 1) x position, 2) y position, 3) weight, 4) height returns in al: 0 if no hit, 1 if there is a hit
    push bp
    mov bp, sp
    push dx

    mov ax, [x_pos]
    add ax, [space_ship_size]
    add ax, [wing_distance]
    add ax, [wings_size]
    cmp ax, [word bp + 4]
    jl no_player_col

    mov ax, [x_pos]
    mov dx, [word bp + 4]
    add dx, [word bp + 8]
    cmp ax, dx
    jg no_player_col

    mov ax, [y_pos]
    sub ax, [wing_distance]
    sub ax, [wing_distance]
    sub ax, [wings_size]
    mov dx, [word bp + 6]
    add dx, [word bp + 10]
    cmp ax, dx
    jg no_player_col

    mov ax, [y_pos]
    add ax, [space_ship_size]
    add ax, [wing_distance]
    add ax, [wing_distance]
    add ax, [wings_size]
    cmp ax, [word bp + 6]
    jl no_player_col

    mov al, 1
    jmp hit_player_ret

    no_player_col:
    mov al, 0

    hit_player_ret:

    pop dx
    pop bp
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

    finish: ;checks the boundries of the x axis
        mov ax, [x_pos]
        add ax, [word direction]
        add ax, bx
        sub ax, [wing_distance]
        sub ax, [wings_size]
        cmp ax, [boundry]
        jle add_X_pos
        add ax, [space_ship_size]
        add ax, [wing_distance]
        add ax, [wing_distance]
        add ax, [wings_size]
        add ax, [wings_size]
        sub ax, bx
        sub ax, bx
        add ax, [boundry]
        cmp ax, 320
        jge sub_x_pos
        mov ax, [word direction]
        add [x_pos], ax
        jmp change_y

        add_X_pos:
        inc [x_pos]
        jmp change_y

        sub_x_pos:
        dec [x_pos]

        change_y: ;checks the boundries of the y axis
            mov ax, [y_pos]
            add ax, [word direction + 2]
            add ax, bx
            sub ax, [wing_distance]
            sub ax, [wing_distance]
            sub ax, [wings_size]
            sub ax, [wings_size]
            cmp ax, [boundry]
            jle add_y_pos
            add ax, [space_ship_size]
            mov cx, 4
            add_wing_distance:
                add ax, [wing_distance]
                loop add_wing_distance
            mov cx, 4
            add_wing_size:
                add ax, [wings_size]
                loop add_wing_size
            sub ax, bx
            sub ax, bx
            add ax, [boundry]
            cmp ax, 200
            jge sub_y_pos
            mov ax, [word direction + 2]
            add [y_pos], ax
            jmp qfunc

        add_y_pos:
        inc [y_pos]
        jmp qfunc

        sub_y_pos:
        dec [y_pos]

    qfunc: ;checks if touches the energy
        call draw_space_ship
        push [energy_height]
        push [energy_weight]
        push [energy_pos_y]
        push [energy_pos_x]
        
        call hit_player

        add sp, 8
        
        cmp al, 0
        je no_energy
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
    push cx
    push [astroid_size_y]
    push [asteroid_size_x]
    push [word si + 2]
    push [word si]

    call hit_player

    mov cx, 4
    popastroidcol:
        pop dx
        loop popastroidcol
    pop cx

    cmp al, 0
    je no_collision

    cmp [shield_timer], 1
    jge remove
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

    move_powerups: ;;;;;;;;;;;;;;;;;;;;powerups

    mov si, offset powerups

    call clear_powerups

    xor cx, cx

    cmp [number_of_powerups], 0
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
    push cx
    push [astroid_size_y]
    push [asteroid_size_x]
    push [word si + 2]
    push [word si]

    call hit_player ;returns al = 1 if hit player

    mov cx, 4
    popBSTastroidcol:
        pop dx
        loop popBSTastroidcol
    pop cx

    cmp al, 0
    je BSTno_collision

    push 1
    call collided_player
    pop ax
    jmp BSTremove

    BSTno_collision:
    add si, 4
    inc cx
    cmp cx, [number_of_powerups]
    jl BSTnext_astroid_closer


    BSTno_astroids:
    call draw_powerups

    cmp [points], 50
    ;jl no_fire_astroids_closer

    mov si, offset fire_asteroids_array

    call clear_fire_astroids

    xor cx, cx

    cmp [number_of_fire_asteroids], 0
    jle no_fire_astroids_closer
    
    move_next_fire_astroid: ;adds the velocity and checks if hit the boundries

    mov ax, [word fire_astroid_velocity_x]
    sub [word si], ax
    mov ax, [word fire_astroid_velocity_y]
    add [word si + 2], ax
    cmp [word si], 0
    jle fire_remove
    mov ax, 200
    sub ax, [fire_asteroids_height]
    cmp [word si + 2], ax
    jl dont_remove_fire

    fire_remove:
    push si
    call remove_fire_astroid
    pop si
    jmp no_collision_fire

    no_fire_astroids_closer:
        jmp no_fire_astroids

    next_fire_astroid_closer:
        jmp move_next_fire_astroid

    dont_remove_fire: ;checks if collides the player
    push cx
    push [fire_asteroids_height]
    push [fire_asteroids_weight]
    push [word si + 2]
    push [word si]

    call hit_player

    mov cx, 4
    popfireastroidcol:
        pop dx
        loop popfireastroidcol
    pop cx

    cmp al, 0
    je no_collision_fire

    cmp [shield_timer], 1
    jge fire_remove
    push 2
    call collided_player
    pop ax
    jmp fire_remove

    no_collision_fire:
    add si, 4
    inc cx
    cmp cx, [number_of_fire_asteroids]
    jl next_fire_astroid_closer

    call draw_fire_astroids

    no_fire_astroids:


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
    mov si, offset powerups

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
        cmp cx, [number_of_powerups]
        jl BSTreplace_astroid

        dec [number_of_powerups]

        pop si
        pop cx
        pop bx
        pop ax
        pop bp
        ret
endp

proc remove_fire_astroid ;removes a fire astroid and sets the array correctly
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si


    mov bx, [bp + 4]
    mov si, offset fire_asteroids_array

    xor cx, cx
    replace_fire_astroid:
        cmp si, bx
        jle replace_next_fire

        mov ax, [word si]
        mov [word si - 4], ax

        mov ax, [word si + 2]
        mov [word si - 2], ax

        replace_next_fire:
        add si, 4
        inc cx
        cmp cx, [number_of_fire_asteroids]
        jl replace_fire_astroid

        dec [number_of_fire_asteroids]

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
    mov ax, [asteroid_size_x]
    sub [word si], ax
    mov [word si + 2], dx

    jmp dont_spawn

    spawn_booster:
    inc [number_of_powerups]
    mov si, offset powerups

    mov cx, [number_of_powerups]
    dec cx

    BSTdeeper_into_the_memory: ;sets si to be in the first free place if the array
        add si, 4
        loop BSTdeeper_into_the_memory
    
    mov [word si], 320
    mov ax, [asteroid_size_x]
    sub [word si], ax
    mov [word si + 2], dx
    
    dont_spawn:

    cmp [points], 50
    jl dont_spawn_fire

    mov ax, [number_of_fire_asteroids]
    cmp ax, [max_number_of_fire_astroid]
    jge dont_spawn_fire

    call prg
    and ax, 0000000011111111b
    add ax, 50 ;range 50 - 306

    mov dx, ax

    inc [number_of_fire_asteroids]
    mov si, offset fire_asteroids_array
    sub si, 4
    mov cx, [number_of_fire_asteroids]

    deeper_into_the_memory_fire: ;sets si to be in the first free place of the array
        add si, 4
        loop deeper_into_the_memory_fire
    
    mov [word si], dx
    mov ax, [fire_asteroids_weight]
    sub [word si], ax
    mov ax, [fire_asteroids_height]
    mov [word si + 2], ax
    add [word si + 2], 5

    dont_spawn_fire:


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
        mov [byte bx], 0
        inc bx
        cmp [byte bx], 3
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
        mov [byte bx], 0
        inc bx
        cmp [byte bx], 4
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

    draw_health_func:
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
    cmp ax, 2
    je fire_damage
    cmp ax, 0
    jg boost
    
    cmp [health], 1
    jle Die_closer
    sub [health], 1
    call update_health
    jmp return

    fire_damage:
    cmp [health], 2
    jle Die_closer
    sub [health], 2
    call update_health
    jmp return

    boost:
    call prg

    and ax, 0000000001111111b ;range 0 - 128

    cmp ax, 100
    jg speed_boost
    cmp ax, 80
    jg points_boost
    cmp ax, 40
    jg shield_boost

    health_boost:
        inc [health]
        call update_health
        call clear_health
        mov [health_timer], 18
        mov ax, [x_pos]
        mov [health_x_pos], ax
        mov ax, [y_pos]
        mov [health_y_pos], ax
        jmp return

    speed_boost:
        call clear_fire
        mov ax, [boost_speed]
        add [speed], ax
        mov ax, [x_pos]
        sub ax, 10
        mov [fire_x_pos], ax
        mov ax, [y_pos]
        add ax, 7
        mov [fire_y_pos], ax
        mov [fire_time], 50
        jmp return

    Die_closer:
    jmp Die

    shield_boost:
        call clear_shield
        mov [shield_timer], 40
        mov ax, [shield_height]
        mov [shield_height_now], ax
        jmp return

    points_boost:
        add [points], 5
        call make_harder

    return:

    pop ax
    pop bp
    ret

    Die:
        mov [health], 0
        call update_health
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
    jl check_health

    call clear_fire
    mov ax, [x_pos]
    sub ax, 20
    mov [fire_x_pos], ax
    mov ax, [y_pos]
    mov [fire_y_pos], ax
    call draw_fire
    dec [fire_time]
    jmp check_health

    dont_draw_fire:
    call clear_fire
    mov ax, [boost_speed]
    mov [speed], 1
    dec [fire_time]

    check_health:
    cmp [health_timer], 1
    je dont_draw_health
    jl check_shield

    call draw_health
    dec [health_timer]
    jmp check_shield

    dont_draw_health:
    call clear_health
    dec [health_timer]

    check_shield:
    cmp [shield_timer], 1
    je dont_draw_shield
    jl check_indicators_ret

    call clear_shield
    mov ax, [y_pos]
    sub ax, [wing_distance]
    sub ax, [wing_distance]
    sub ax, [wings_size]
    mov [shield_y_pos], ax
    mov ax, [x_pos]
    add ax, [space_ship_size]
    add ax, [wing_distance]
    add ax, [wings_size]
    add ax, 5
    mov [shield_x_pos], ax
    call draw_shield
    dec [shield_timer]
    mov ax, [shield_height]
    cmp [shield_timer], al
    jg check_indicators_ret
    dec [shield_height_now]
    jmp check_indicators_ret

    dont_draw_shield:
    call clear_shield
    dec [shield_timer]
    mov ax, [shield_height]
    mov [shield_height_now], ax


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

    mov bx, offset music_str
    find_length_music:
    cmp [byte bx], '$'
    je set_length_music
    inc bx
    jmp find_length_music

    set_length_music:
    sub bx, offset music_str
    sub bx, 4
    mov [music_len], bx

    pop dx
    pop bx
    pop ax
    ret
endp

Proc open_speaker
    in al, 61h
    or al, 00000011b
    out 61h, al
    ret
endp

proc close_speaker
    in al, 61h
    and al, 11111100b
    out 61h, al
    ret
endp

proc make_sound ;gets a frequency and tell the computer to make this sound
    push bp
    mov bp, sp

    mov al, 0B6h
    out 43h, al

    mov ax, 34dch
    mov dx, 0012h ;the constant 1193180
    div [word bp + 4]

    out 42h, al ; Sending lower byte
    xchg al, ah
    out 42h, al ; Sending upper byte

    pop bp
    ret
endp

proc play_music
    mov bx, offset music_str
    add bx, [mp]
    mov al, [byte bx]
    cmp al, " "
    jne play_normal
    cmp [nt], 0
    jg dont_close_note
    call close_speaker
    dont_close_note:
    mov al, [music_break_len]
    cmp [nt], al
    jl continue_break
    mov [nt], 0
    inc [mp]
    call open_speaker
    jmp play_music
    continue_break:
    inc [nt]
    jmp play_music_ret
    play_normal:
    xor ah, ah
    sub al, 65
    mov si, ax
    add si, ax
    add si, offset music_table
    mov ax, [word si]
    mov cl, [byte bx + 1]
    sub cl, 30h
    xor ch, ch
    cmp cx, 0
    jle notmul
    mulloop:
     add ax, ax
     loop mulloop
    notmul:
    push ax
    call make_sound
    pop ax
    dont_play:
    mov al, [music_speed]
    cmp [nt], al
    jl add_nt
    mov [nt], 0
    mov ax, [mp]
    cmp ax, [music_len]
    jge make_zero
    add [mp], 2
    jmp play_music_ret

    add_nt:
    inc [nt]
    jmp play_music_ret

    make_zero:
    mov [mp], 0

    play_music_ret:
    
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

        xor bx, [Clock]
        and bx, [word cs:bx]
        mov [NextRandom], bx

        call draw_space_ship
        call draw_energy
        call draw_fire_astroids
        call update_health
        call make_harder
        call open_speaker

        check_time:
            mov dl, [Clock]
            cmp dl, [Time_Aux]
            je check_time
            mov [Time_Aux], dl
        
        cycle:
            cmp [play], 0
            je GameOver
            call play_music
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

            restart_loop:
            xor ah, ah
            int 16h
            cmp al, 72h
            je restart
            cmp al, 52h
            je restart

            cmp al, 74h
            je Exit
            cmp al, 54h
            je Exit

            jmp restart_loop
            restart:
                mov [paused], 1 ;restart all the variables
                mov [health], 5
                mov [points], 0
                mov [word direction], 0
                mov [word direction + 2], 0
                mov [x_pos], 160
                mov [y_pos], 100
                mov [shield_timer], 18
                MOV [fire_time], 0
                mov [play], 1
                call upadate_points
                call draw_UI
                jmp startgame_closer

proc quit ;a debug function
    jmp Exit
    ret
endp

Exit:
    call close_speaker
    mov ax, 4C00h
    int 21h
	END start