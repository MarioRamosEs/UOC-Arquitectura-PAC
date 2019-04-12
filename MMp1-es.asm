section .data              
;Cambiar Nombre y Apellido por vuestros datos.
developer db "Mario Ramos"
counter db 0

;Constantes que también están definidas en C.
DimVector equ 6		

section .text            
;Variables definidas en Ensamblador.
global developer                        

;Subrutinas de ensamblador que se llaman desde C.
global getSecretPlayP1, checkSecretP1, printTriesP1,
global checkPlayP1, printSecretP1, printMessageP1, playP1

;Variables definidas en C.
extern charac, rowScreen, colScreen
extern vSecret, vPlay, tries, state

;Funciones de C que se llaman desde ensamblador
extern clearScreen_C, gotoxyP1_C, printchP1_C, getchP1_C
extern printBoardP1_C, printMessageP1_C

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓN: Recordad que las variables y los parámetros de tipo 'char',
;;   en ensamblador se tienen que asignar a registros de tipo BYTE 
;;   (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ...
;;   y los de tipo 'int' se tienen que asignar a registros 
;;   de tipo DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ....
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Las subrutinas en ensamblador que tenéis que implementar son:
;;   getSecretPlayP1, checkSecretP1, printTriesP1,  
;;   checkPlayP1, printSecretP1  
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Situar el cursor en la fila indicada por la variable (rowScreen) y 
; en la columna indicada por la variable (colScreen) de la pantalla, 
; llamando a la función gotoxyP1_C.
;
; Variables globales utilizadas:	
; rowScreen: fila de la pantalla donde posicionamos el cursor.
; colScreen: columna de la pantalla donde posicionamos el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call gotoxyP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Mostrar un carácter guardado en la variable (charac) en la pantalla, 
; en la posición donde está el cursor, llamando a la función printchP1_C
; 
; Variables globales utilizadas:	
; charac   : carácter que queremos mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call printchP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Leer una tecla y guardar el carácter asociado a la variable (charac)
; sin mostrarlo por pantalla, llamando a la función getchP1. 
; 
; Variables globales utilizadas:	
; charac   : carácter que leemos de teclado.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call getchP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax
   
   mov rsp, rbp
   pop rbp
   ret 





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Si (state=0) leer la combinación secreta y la guradaremos
; en el vector vSecret, sino estaremos leyendo una jugada y la
; guardaremos en el vector vPlay, son vectores de de DimVector(6) posiciones.
; 
; · Primero indicar la posición del cursor en pantalla 
;   Si (state=0) (rowScreen=3), sino (rowScreen=9+(DimVector-tries)*2)
;   (colScreen=8)
; · Inicializar con espacios el vector (vSecret) si (state=0), si no
;   inicializar con espacios el vector (vPlay).
; Mientras no se pulse ENTER(10) o ESC(27) hacer lo siguiente:
; · Posicionar el cursor en pantalla llamando a la subrutina gotoxyP1, 
;   según el valor de las variables (rowScreen y colScreen).
; · Leer un carácter de teclado llamando la subrutina getchP1
;   que deja en la variable (charac) el código ASCII del carácter leído.
;    - Si se ha leído una 'j'(izquierda) o una 'k' (derecha) mover el 
;      cursor por las 6 posiciones de la combinación, actualizando 
;      el índice del vector (i +/-1) y la columna (colScreen +/-2).
;      (no se puede salir de la zona donde estamos escribiendo (6 posiciones))
;    - Si se ha leído un carácter válido ['0'-'9'] lo guardamos en el vector.
;        Si (state=0) lo guardaremos en el vector (vSecret) y pondremos un '*'
;        en (charac) para que no se vea la combinació secreta,
;        sino lo guardamos en el vector (vPlay).
;      Y mostramos el carácter (charac) en pantalla en la posición donde 
;      está el cursor llamando a la subrutina printchP1.
; · Si se ha pulsado ESC(27) poner (state=7) para indicar que tenemos 
;   que salir.
; 
; Si se pulsa ENTER(10) aceptar la combinación tal y como esté.
; NOTA: Hay que tener en cuenta que si se pulsa ENTER sin haber asignado
; valores a todas las posiciones del vector, habrá posiciones que serán
; un espacio (valor utilizado para inicialitar los vectores).
; 
; Variables globales utilizadas:	
; rowScreen: fila de la pantalla donde posicionamos el cursor.
; colScreen: columna de la pantalla donde posicionamos el cursor.
; charac   : carácter que leemos de teclado.
; vSecret  : vector donde guardamos la combinación secreta
; state    : estado del juego.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
getSecretPlayP1: ;prefix sp_
   push rbp
   mov  rbp, rsp

   ;Primera Parte - Comprobación posición
   cmp DWORD[state], 0
   je sp_state0
   sp_state3:
   mov eax, DimVector
   mov ebx, DWORD [tries]
   sub eax, ebx
   sal eax, 1	; *2
   add eax, 9	
   mov DWORD[rowScreen], eax
   jmp sp_endIfState
   sp_state0:
   mov DWORD[rowScreen], 3
   sp_endIfState:
   mov DWORD[colScreen], 8
   ;Fin Primera Parte

   ;Segunda parte - Array con espacios
   mov rax, 0 ;rax will be i
   sp_checkLoop:
   cmp rax, DimVector
   jge sp_endLoop
   sp_true:
      cmp DWORD[state], 0
      je sp_state0_3
      sp_stateNot0:
      mov BYTE [vPlay+rax], ' '
      jmp sp_endIfState
      sp_state0_3:
      mov BYTE [vSecret+rax], ' '	
      sp_endIfstate_3:
   add rax, 1
   jmp sp_checkLoop
   sp_endLoop:
   ;Fin Segunda parte

   mov rax, 0 ;rax will be i
   sp_startDoWhile:
   call gotoxyP1
   call getchP1	
   
   ;check j
   mov al, BYTE [charac]
   cmp al, 'j'
   jne sp_dontGoLeft
   cmp rax, 0
   jle sp_dontGoLeft
   sub rax, 1
   sub DWORD[colScreen], 2 ;TODO revisar
   sp_dontGoLeft:

   ;check k
   cmp al, 'k'
   jne sp_dontGoRight
   cmp rax, DimVector
   je sp_dontGoRight
   add rax, 1
   add DWORD[colScreen], 2 ;TODO revisar
   sp_dontGoRight:

   ;check charac>='0' && charac<='9'
   cmp al, '0'
   jb sp_checkDoWhile
   cmp al, '9'
   ja sp_checkDoWhile

   ;check state_2
   cmp DWORD[state], 0
   je sp_state0_2
   sp_stateNot0_2:
   mov BYTE[vPlay+rax], al ;Asignamos la tecla pulsada en la array
   jmp sp_endIfState_2
   sp_state0_2:
   mov BYTE[vSecret+rax], al ;Asignamos la tecla pulsada en la array
   mov BYTE[charac], '*'
   sp_endIfState_2:
   call printchP1

   sp_checkDoWhile:
   cmp al, 10 ;Enter
   je sp_endDoWhile
   cmp al, 27 ;Esc
   je sp_endDoWhile
   jmp sp_startDoWhile

   sp_endDoWhile:

   cmp al, 27 ;Esc
   jne sp_endFunc		
   mov DWORD[state], 7

   sp_endFunc:

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Verifica que la combinación secreta (vSecret) no tenga espacios.
; Para cada elemento del vector (vSecret) mirar que no haya un espacio.
; Si la combinación secreta es correcta, poner (state=1) para indicar 
; que la combinación secreta es correcta y que vamos a leer jugadas.
; Si la combinación secreta es incorrecta, poner (state=3) para volverla
; a pedir sin inicializarla.
; 
; Variables globales utilizadas:	
; vSecret  : vector donde guardamos la combinación secreta
; state    : estado del juego.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
checkSecretP1: ;prefix cs_
   push rbp
   mov  rbp, rsp
   ;push r8b
   
   mov rax, 0 ;rax will be [i]
   mov rcx, 0 ;rcx will be secretError

   cs_checkLoop:
	  ;mov edx, BYTE[DimVector]
      cmp rax, DimVector
      jb cs_true
      jmp cs_endLoop
   cs_true:
      mov r8b, BYTE[vSecret+rax]
      inc rax ;increment i
      cmp r8b, 48
      jne cs_checkLoop
      mov rcx, 1 ;secretError = 1
      jmp cs_checkLoop
   cs_endLoop:
   
   cmp rcx, 9
   je cs_set0
   jmp cs_set3
   cs_set0:
       mov  DWORD[state], 0
       jmp cs_endIf
   cs_set3:
       mov  DWORD[state], 3
       jmp cs_endIf
    
   cs_endIf:

   ;pop r8b
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar los intentos que quedan (tries) para acertar la combinaciónn 
; secreta. 
; Situar el cursor en la fila 23, columna 5 llamando a la subrutina gotoxyP1.
; Mostrar el carácter asociado al valor de la variable (tries) 
; llamando a la subrutina printchP1.
; Para obtener el carácter asociado a los intentos, código ASCII del número,
; hay que sumar al valor numérico de los intentos (tries) 48 (código 
; ASCII de '0'). (charac=tries+'0' o charac=tries+48).
; 
; Variables globales utilizadas:	
; rowScreen: fila de la pantalla donde posicionamos el cursor.
; colScreen: columna de la pantalla donde posicionamos el cursor.
; charac   : carácter que leemos de teclado.
; tries    : número de intentos que quedan.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
printTriesP1:
   push rbp
   mov  rbp, rsp

   mov DWORD[rowScreen], 23
   mov DWORD[colScreen], 5
   call gotoxyP1
	
   mov eax, DWORD[tries]
   add eax, 48
   mov DWORD[charac], eax
   call printchP1

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mirar si la jugada (vPlay) es igual (posición a posición) a la 
; combinación secreta (vSecret), para cada posición que sea igual
; incrementar los aciertos en el sitio (hitsX++).
; Si todas las posiciones de la combinación secreta (vSecret) y de la jugada
; (vPlay) son iguales (hitsX=6) hemos ganado (state=5).
; 
; Variable Local de C (en ensamblador utilizar un registro):
; hitsX    : aciertos en el sitio.
;
; Variables globales utilizadas:	
; vSecret  : vector donde guardamos la combinación secreta
; vPlay    : vector donde guardamos cada jugada.
; state    ; estado del juego.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
checkPlayP1: ;prefix cp_
   push rbp
   ;push r8b
   ;push r9b
   mov  rbp, rsp

   mov al, 0 ;al will be hitsx
   mov ebx, 0 ;ebx will be i

   cp_checkLoop:
      cmp ebx, DimVector 
      jge cp_endLoop 
   mov r8b, BYTE[vSecret+ebx] 
   mov r9b, BYTE[vPlay+ebx] 
   cmp r8b, r9b 
   jne cp_continueLoop
   inc al ;increment hitsx
   cp_continueLoop:
      inc ebx ;increment i
      jmp cp_checkLoop
   cp_endLoop:

   cmp al, DimVector 
   jne cp_endIf
   mov DWORD[state], 5
   cp_endIf:
   
   mov rsp, rbp
   ;pop r9b
   ;pop r8b
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar la combinación secreta en la parte superior del tablero 
; cuando finaliza el juego.
; 
; Variables globales utilizadas:	
; rowScreen: fila de la pantalla donde posicionamos el cursor.
; colScreen: columna de la pantalla donde posicionamos el cursor.
; charac   : carácter que leemos de teclado.
; vSecret  : vector donde guardamos la combinación secreta.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
printSecretP1: ;prefix ps_
   push rbp
   mov  rbp, rsp
   
   mov bx, 0 ;bx will be i
   mov DWORD[rowScreen], 3
   mov DWORD[colScreen], 8
   mov ebx, 8; ebx will be colScreen
   
    ps_checkLoop:
		cmp ecx, DimVector
		jae ps_endLoop
	ps_continueLoop:
		movzx eax, BYTE[vSecret+ecx] 
		
		mov DWORD[charac], eax
		mov DWORD[colScreen], ebx
		call gotoxyP1
		call printchP1

		add ebx, 2
		inc ecx
		jmp ps_checkLoop
	ps_endLoop:
  
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Muestra un mensaje debajo del tablero según el valor de la variable
; (state) llamando la función printMessageP1_C.
; (state)  0: Estamos entrando la combinación secreta, 
;          1: Estamos entrando la jugada.
;          3: La combinación secreta tiene espacios o números repetidos.
;          5: Se ha ganado, jugada = combinación secreta.
;          6: Se han agotado las jugadas
;          7: Se ha pulsado ESC para salir
; Se espera que se pulse una tecla para continuar. Mostrando un mensaje
; debajo del tablero para indicarlo y al pulsar una tecla lo borra.
;         
; Variables globales utilizadas:	
; Ninguna
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printMessageP1:
   push rbp
   mov  rbp, rsp
   ;guardamos el estado de los registros del procesador porque
   ;las funciones de C no mantienen el estado de los registros.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ;Llamamos a la función printMessageP1_C() des de ensamblador, 
   call printMessageP1_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Esta subrutina se da hecha. NO LA PODÉIS MODIFICAR.
; Subrutina principal del juego
; Leer la combinación secreta y verificar que sea correcta.
; A continuación se lee una jugada, compara la jugada con la
; combinación secreta para determinar si son iguales.
; repetir el proceso mientras no se acierta la combinación secreta y 
; mientras queden intentos. Si se pulsa la tecla 'ESC' durante la 
; lectura de la combinación secreta o de una jugada salir.
; 
; Pseudo código:
; El jugador tiene que disponer de 6 intentos para acertar la combinación 
; secreta y el estado inicial del juego es 0.
; Mostrar el tablero de juego llamando a la función printBoardP1_C.
; Mostrar un mensaje indicando que se tiene que entrar la combinación 
; secreta llamando a la subrutina printMessageP1;
; Mientras (state=0) leer combinación secreta o (state=3) se ha leído 
; la combinación secreta pero no es correcta:
;   - Poner el estado inicial del juego a 0 (state=0) .
;   - Leer la combinación secreta llamando la subrutina getSecretPlayP1.
;   - Si no se ha pulsado la tecla (ESC) (state!=7) llamar a la subrutina 
;     checkSecretP1 para verificar si la combinación secreta tiene 
;     espacios i mostar un mensaje llamando a la subrutina printMessageP1
;     indicando que la combinación secreta no és correcta (state=3) o
;     que ya se pueden entrar jugadas (state=1). 
; Mientras (state=1) estamos introduciendo jugadas:
;   - Mostrar los intentos que queden llamando a la subrutina printTriesP1.
;   - Leer la jugada llamando a la subrutina getSecretPlayP1.
;   - Si no se ha pulsado (ESC) (state!=7) llamar a la subrutina chekHitsP1 
;     para mirar si la jugada (vPlay) es igual (posición a posición) a la 
;     combinación secreta (vSecret), si es igual (state=5).
;     Decrementamos los intentos, y si no quedan intentos (tries=0) y 
;     no hemos acertado la combinación secreta (state=1), hemos 
;     perdido (state=6).
; Para acabar, mostrar la combinación secreta llamando a la subrutina
; printSecretP1 y un mensaje indicando cual ha sido el motivo
; llamando a la subrutina printMessageP1.
; Se acaba el juego.
; 
; Variables globales utilizadas:	
; tries    : número de intentos que quedan.
; state    : estado del juego.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
playP1:
   push rbp
   mov  rbp, rsp

   mov  DWORD[tries], 6  ;tries = 6;
   mov  DWORD[state], 0  ;state = 0;
   call printBoardP1_C   ;printBoardP1_C();
   call printMessageP1   ;printMessageP1_C();
 
   p1_while0:       ;while (state == 0 || state==3) {
   cmp DWORD[state], 0
   je  p1_while0_ok
   cmp DWORD[state], 3
   jne p1_while0_end
     p1_while0_ok:
     mov  DWORD[state], 0    ;state = 0;
	 call getSecretPlayP1    ;getSecretPlayP1_C();
	 p1_if1:                 ;if (state!=7) {
	 cmp DWORD[state], 7
	 je p1_if1_end
	   call checkSecretP1      ;checkSecretP1_C();
	   call printMessageP1     ;printMessageP1_C();
	 p1_if1_end:
	 
     jmp p1_while0
   p1_while0_end:
   
   p1_while1:       ;while (state==1) {
   cmp DWORD[state], 1
   jne p1_while1_end
	 call printTriesP1    ;printTriesP1_C();
	 call getSecretPlayP1 ;getSecretPlayP1_C();
	 p1_if2:              ;if (state!=7) {
	 cmp DWORD[state], 7
	 je p1_if2_end
	   call checkPlayP1  ;checkPlayP1_C();
	   dec DWORD[tries]  ;tries--;
	   p1_if3:           ;if (tries == 0 && state == 1) {
	   cmp DWORD[tries], 0
	   jne p1_if3_end
	   cmp DWORD[state], 1
	   jne p1_if3_end
         mov DWORD[state], 6  ;state = 6;
       p1_if3_end:
     p1_if2_end:
     jmp p1_while1
   p1_while1_end:
   call printSecretP1    ;printSecretP1_C();
   call printMessageP1   ;printMessageP1_C();
   
   p1_end:	
   mov rsp, rbp
   pop rbp
   ret
