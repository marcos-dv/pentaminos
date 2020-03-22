# Tetris: Pentaminos Version (MIPS, lunchable with Mars 4.5)
# Pentaminos are geometric figures composed of 5 squares, as tetraminos (tetris figures) are composed of 4 squares.

# This Pentaminos-Tetris written in MIPS allows you to simulate this harder version of the famous game.
# Updated: February 2019
# Author: Marcos Dominguez Velad


	.data

	.align	2
pantalla:
	.word	20		#Tamaño inicial pantalla
	.word	22
	.space	1024

	.align	2
campo:
	.word	14		#Tamaño inicial campo
	.word	20
	.space	1024

	.align	2
pieza_actual:
	.word	0
	.word	0
	.space	1024

	.align 2
pieza_actual_x:
	.word 0

pieza_actual_y:
	.word 0

	.align	2
imagen_auxiliar:
	.word	0
	.word	0
	.space	1024

	.align	2
pieza_efe:
	.word	3
	.word	3
	.ascii		"\0****\0\0*\0"

	.align	2
pieza_efe2: # Las figuras '2' son las simetricas
	.word	3
	.word	3
	.ascii		"**\0\0**\0*\0"

	.align	2
pieza_i:
	.word	1
	.word	5
	.ascii		"*****"

	.align	2
pieza_ele:
	.word	2
	.word	4
	.ascii		"*\0*\0*\0**"

	.align	2
pieza_ele2:
	.word	2
	.word	4
	.ascii		"\0*\0*\0***"

	.align	2
pieza_ene:
	.word	2
	.word	4
	.ascii		"\0****\0*\0"

	.align	2
pieza_ene2:
	.word	2
	.word	4
	.ascii		"*\0**\0*\0*"

	.align	2
pieza_pe:
	.word	2
	.word	3
	.ascii		"\0*****"

	.align	2
pieza_pe2:
	.word	2
	.word	3
	.ascii		"*\0****"

	.align	2
pieza_te:
	.word	3
	.word	3
	.ascii		"***\0*\0\0*\0"

	.align	2
pieza_u:
	.word	3
	.word	2
	.ascii		"*\0****"

	.align	2
pieza_uve:
	.word	3
	.word	3
	.ascii		"*\0\0*\0\0***"

	.align	2
pieza_w:
	.word	3
	.word	3
	.ascii		"*\0\0**\0\0**"

	.align	2
pieza_x:
	.word	3
	.word	3
	.ascii		"\0*\0***\0*\0"

	.align	2
pieza_y:
	.word	2
	.word	4
	.ascii		"\0***\0*\0*"

	.align	2
pieza_y2:
	.word	2
	.word	4
	.ascii		"*\0***\0*\0"

	.align	2
pieza_z:
	.word	3
	.word	3
	.ascii		"**\0\0*\0\0**"

	.align	2
pieza_z2:
	.word	3
	.word	3
	.ascii		"\0**\0*\0**\0"

	.align	2
piezas: # 18 piezas
	.word	pieza_efe
	.word	pieza_efe2
	.word	pieza_i
	.word	pieza_ele
	.word	pieza_ele2
	.word	pieza_ene
	.word	pieza_ene2
	.word	pieza_pe
	.word	pieza_pe2
	.word	pieza_te
	.word	pieza_u
	.word	pieza_uve
	.word	pieza_w
	.word	pieza_x
	.word	pieza_y
	.word	pieza_y2
	.word	pieza_z
	.word	pieza_z2

acabar_partida:
	.byte	0

	.align	2

final_partida:
	.byte	0

	.align	2

procesar_entrada.opciones:
	.byte	'x'
	.space	3
	.word	tecla_salir
	.byte	'j'
	.space	3
	.word	tecla_izquierda
	.byte	'l'
	.space	3
	.word	tecla_derecha
	.byte	'k'
	.space	3
	.word	tecla_abajo
	.byte	'i'
	.space	3
	.word	tecla_rotar

str000:
	.asciiz		"Tetris\n\n 1 - Jugar\n 2 - Configuración\n 3 - Salir\n\nElige una opción:\n"
str001:
	.asciiz		"\n¡Adiós!\n"
str002:
	.asciiz		"\nOpción incorrecta. Pulse cualquier tecla para seguir.\n"
str003:
	.asciiz		"Puntuación: "
str004:
	.asciiz 	"FIN DE PARTIDA"
str005:
	.asciiz 	"pulse la tecla X"
str006:
	.asciiz		"Configuración:\n\n 1 - Tamaño del campo\n 2 - Velocidad inicial\n 3 - Controles\n 4 - Relleno de la pieza\n 5 - Menú principal\n\nElige una opción:\n"
str007:
	.asciiz		"Cambio de velocidad:\n\n 1 - Lento\n 2 - Normal\n 3 - Moderado\n 4 - Rápido\n 5 - Instantáneo\n 6 - Volver\n\nElige una opción:\n"
str008:
	.asciiz		"Cambio de tamaño:\n\n 1 - Normal\n 2 - Grande\n 3 - Muy grande\n 4 - Pequeño\n 5 - Volver\n\nElige una opción:\n"
str009:
	.asciiz		"Cambio de controles:\n\n 1 - Rotar pieza\n 2 - Mover a la izquierda\n 3 - Mover a la derecha\n 4 - Bajar pieza\n 5 - Volver\n\nElige una opción:\n"
str010:
	.asciiz		"Cambio de relleno, introduzca un caracter:\n"
str011:
	.asciiz 	"\nPulse la nueva tecla de acción: "
punt:
	.word	0
	.word   0
cadpunt:
	.space	256
pausa:
	.word 1000
pieza_siguiente:
	.word	0
	.word	0
	.space	1024


	.text


Cambia_Tamanyo_Campo:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

ctc0:	jal	clear_screen
	la	$a0, str008
	jal	print_string		# printf ("Cambio de tamaño:\n\n 1 - Normal\n 2 - Grande\n 3 - Muy grande\n 4 - Pequeño\n 5 - Volver\n\nElige una opción:\n")
	jal	read_character
	beq	$v0, '5', ctcout
	beq	$v0, '4', ctc4
	beq	$v0, '3', ctc3
	beq	$v0, '2', ctc2
	bne	$v0, '1', ctcerr

	li	$t0, 20			#Tamaño normal
	li	$t1, 22
	sw	$t0, pantalla
	sw	$t1, pantalla +4
	sw	$t0, campo +4
	li	$t0, 14
	sw	$t0, campo

	j	ctcout

ctcerr:	la	$a0, str002
	jal	print_string		# print_string("\nOpción incorrecta. Pulse cualquier tecla para seguir.\n")
	jal	read_character		# read_character()
	j	ctc0

ctc2:
	li	$t0, 26			#Tamaño grande
	sw	$t0, pantalla
	sw	$t0, pantalla +4
	li	$t0, 18
	li	$t1, 22
	sw	$t0, campo
	sw	$t1, campo +4
	j	ctcout

ctc3:
	li	$t0, 30			#Tamaño muy grande
	li	$t1, 32
	sw	$t0, pantalla
	sw	$t1, pantalla +4
	li	$t0, 24
	sw	$t0, campo
	sw	$t0, campo +4
	j	ctcout

ctc4:
	li	$t0, 20			#Tamaño pequeño
	li	$t1, 22
	sw	$t0, pantalla
	sw	$t1, pantalla +4
	li	$t0, 10
	li	$t1, 18
	sw	$t0, campo
	sw	$t1, campo +4

ctcout:	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4

	jr	$ra



Cambia_Controles:

	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

ccont0:	jal	clear_screen		# clear_screen()
	la	$a0, str009
	jal	print_string		# printf ("Cambio de controles:\n\n 1 - Rotar pieza\n 2 - Mover a la izquierda\n 3 - Mover a la derecha\n 4 - Bajar pieza\n 5 - Volver\n\nElige una opción:\n")
	jal	read_character		# char opc = read_character()
	beq	$v0, '5', ccontout	# Volver
	beq	$v0, '4', ccont4	# Abajo
	beq	$v0, '3', ccont3	# Dcha
	beq	$v0, '2', ccont2	# Izda
	bne	$v0, '1', cconterr	# if (opc != '1') mostrar error
		#Rotar pieza
	la	$a0, str011
	jal	print_string
	jal	read_character
	beq	$v0, 'x', cconterr
	sw	$v0, procesar_entrada.opciones +32
	j	ccont0
ccont4:		##Abajo
	la	$a0, str011
	jal	print_string
	jal	read_character
	beq	$v0, 'x', cconterr
	sw	$v0, procesar_entrada.opciones +24
	j	ccont0

ccont3:		##Dcha
	la	$a0, str011
	jal	print_string
	jal	read_character
	beq	$v0, 'x', cconterr
	sw	$v0, procesar_entrada.opciones +16
	j	ccont0

ccont2:		##Izda
	la	$a0, str011
	jal	print_string
	jal	read_character
	beq	$v0, 'x', cconterr
	sw	$v0, procesar_entrada.opciones +8
	j	ccont0

cconterr:
	la	$a0, str002
	jal	print_string		# print_string("\nOpción incorrecta. Pulse cualquier tecla para seguir.\n")
	jal	read_character		# read_character()
	j	ccont0

ccontout:
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4

	jr	$ra


Cambia_Velocidad:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

cvel0:	jal	clear_screen		# clear_screen()
	la	$a0, str007
	jal	print_string		# printf ("Cambio de velocidad:\n\n 1 - Lento\n 2 - Normal\n 3 - Moderado\n 4 - Rápido\n 5 - Instantáneo\n\nElige una opción:\n")
	jal	read_character		# char opc = read_character()
	beq	$v0, '5', cvel5		# Instantáneo
	beq	$v0, '4', cvel4		# Rápido
	beq	$v0, '3', cvel3		# Moderado
	beq	$v0, '2', cvel2		# Normal
	bne	$v0, '1', cvelerr	# if (opc != '1') mostrar error
	li	$t0, 1100		# Lento
	j	cvelout
cvelerr:la	$a0, str002
	jal	print_string		# print_string("\nOpción incorrecta. Pulse cualquier tecla para seguir.\n")
	jal	read_character		# read_character()
	j	cvel0
cvel5:	li	$t0, 320
	j	cvelout
cvel4:	li	$t0, 600
	j	cvelout
cvel3:	li	$t0, 850
	j	cvelout
cvel2:	li	$t0, 1000

cvelout:sw	$t0, pausa		#Modificamos "pausa" con el valor contenido en $t0

	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

Cambia_Relleno:

	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	jal	clear_screen		# clear_screen()
	la	$a0, str010
	jal	print_string
	jal	read_character		# char opc = read_character()
	move	$a0, $v0
	jal	Cambio_Piezas

	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4

	jr	$ra


#Dado un caracter, rellena las piezas del tetris con dicho caracter.
Cambio_Piezas:

	##Pieza Efe
	sb	$a0, pieza_efe +9
	sb	$a0, pieza_efe +10
	sb	$a0, pieza_efe +11
	sb	$a0, pieza_efe +12
	sb	$a0, pieza_efe +15

	##Pieza Efe2
	sb	$a0, pieza_efe2 +8
	sb	$a0, pieza_efe2 +9
	sb	$a0, pieza_efe2 +12
	sb	$a0, pieza_efe2 +13
	sb	$a0, pieza_efe2 +15

	##Pieza i
	sb	$a0, pieza_i +8
	sb	$a0, pieza_i +9
	sb	$a0, pieza_i +10
	sb	$a0, pieza_i +11
	sb	$a0, pieza_i +12

	##Pieza ele
	sb	$a0, pieza_ele +8
	sb	$a0, pieza_ele +10
	sb	$a0, pieza_ele +12
	sb	$a0, pieza_ele +14
	sb	$a0, pieza_ele +15

	##Pieza ele2
	sb	$a0, pieza_ele2 +9
	sb	$a0, pieza_ele2 +11
	sb	$a0, pieza_ele2 +13
	sb	$a0, pieza_ele2 +14
	sb	$a0, pieza_ele2 +15

	##Pieza ene
	sb	$a0, pieza_ene +9
	sb	$a0, pieza_ene +10
	sb	$a0, pieza_ene +11
	sb	$a0, pieza_ene +12
	sb	$a0, pieza_ene +14

	##Pieza ene2
	sb	$a0, pieza_ene2 +8
	sb	$a0, pieza_ene2 +10
	sb	$a0, pieza_ene2 +11
	sb	$a0, pieza_ene2 +13
	sb	$a0, pieza_ene2 +15

	##Pieza pe
	sb	$a0, pieza_pe +9
	sb	$a0, pieza_pe +10
	sb	$a0, pieza_pe +11
	sb	$a0, pieza_pe +12
	sb	$a0, pieza_pe +13

	##Pieza pe2
	sb	$a0, pieza_pe2 +8
	sb	$a0, pieza_pe2 +10
	sb	$a0, pieza_pe2 +11
	sb	$a0, pieza_pe2 +12
	sb	$a0, pieza_pe2 +13

	##Pieza te
	sb	$a0, pieza_te +8
	sb	$a0, pieza_te +9
	sb	$a0, pieza_te +10
	sb	$a0, pieza_te +12
	sb	$a0, pieza_te +15

	##Pieza u
	sb	$a0, pieza_u +8
	sb	$a0, pieza_u +10
	sb	$a0, pieza_u +11
	sb	$a0, pieza_u +12
	sb	$a0, pieza_u +13

	##Pieza uve
	sb	$a0, pieza_uve +8
	sb	$a0, pieza_uve +11
	sb	$a0, pieza_uve +14
	sb	$a0, pieza_uve +15
	sb	$a0, pieza_uve +16

	##Pieza w
	sb	$a0, pieza_w +8
	sb	$a0, pieza_w +11
	sb	$a0, pieza_w +12
	sb	$a0, pieza_w +15
	sb	$a0, pieza_w +16

	##Pieza x
	sb	$a0, pieza_x +9
	sb	$a0, pieza_x +11
	sb	$a0, pieza_x +12
	sb	$a0, pieza_x +13
	sb	$a0, pieza_x +15

	##Pieza y
	sb	$a0, pieza_y +9
	sb	$a0, pieza_y +10
	sb	$a0, pieza_y +11
	sb	$a0, pieza_y +13
	sb	$a0, pieza_y +15

	##Pieza y2
	sb	$a0, pieza_y2 +8
	sb	$a0, pieza_y2 +10
	sb	$a0, pieza_y2 +11
	sb	$a0, pieza_y2 +12
	sb	$a0, pieza_y2 +14

	##Pieza z
	sb	$a0, pieza_z +8
	sb	$a0, pieza_z +9
	sb	$a0, pieza_z +12
	sb	$a0, pieza_z +15
	sb	$a0, pieza_z +16

	##Pieza y2
	sb	$a0, pieza_z2 +9
	sb	$a0, pieza_z2 +10
	sb	$a0, pieza_z2 +12
	sb	$a0, pieza_z2 +14
	sb	$a0, pieza_z2 +15

	jr	$ra

#integer_to_string es una funcion que recibe 2 enteros, en $a0 un numero y
#en $a1 la direccion de memoria de la cadena en la cual el procedimiento almacenará $a0
#contamos con que $a0 sea un valor valido de Puntuacion, es decir, siempre positivo, o posiblemente nulo
integer_to_string:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	move	$t0, $a0		#$t0 = n
	move	$t1, $a1		#$t1 = char * cadena
	li	$t2, 10			#Para facilitar el calculo del cociente/resto, usando "div $t0, $t1" y mflo, mfhi

	bnez	$t0 itscond
	li 	$t4, '0'		#Tratamiento para el 0
	sb	$t4, ($t1)
	addiu	$t1, $t1, 1
					#while (n > 0) do {n = n/10; cadena[i] = n%10; i++}
itscond:	blez	$t0, itsfin
	div	$t0, $t2
	mflo	$t0			#n = n/10
	mfhi	$t3			#aux = n%10
	addiu	$t3, $t3, '0'		#pasar cifra a ascii
	sb	$t3, 0($t1)		#cadena[i] = aux
	addi	$t1, $t1, 1		#i++
	j	itscond			#Retornamos a la condicion


itsfin:	sb	$zero, 0($t1)		#MarcaFin

					#Ordenacion inversa
	addiu	$t1, $t1, -1
	move	$t4, $a1
itsord:	bgeu	$t4, $t1,  itsout
	lb	$t5, ($t1)		#Intercambio con registros auxiliares
	lb	$t6, ($t4)
	sb	$t6, ($t1)
	sb	$t5, ($t4)
	addiu	$t4, $t4, 1		#avanzamos
	addiu	$t1, $t1, -1
	j	itsord


itsout:	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4

	jr	$ra

# Argumentos (imagen*, x, y, char * cadena)
imagen_dibuja_cadena:
	addiu	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	move	$s0, $a3	#s0=char * cadena
	move	$s1, $a0	#s1=imagen *
	move	$s2, $a1	#s2=x
	move	$s3, $a2	#s3=y

idccond:lb	$t0, 0($s0)	#Comprobamos MarcaFin
	beqz	$t0, idcfin
	move	$a0, $s1
	move	$a1, $s2
	move	$a2, $s3
	lb	$a3, 0($s0)
	jal	imagen_set_pixel
	addi	$s2, $s2, 1	#x++
	addi	$s0, $s0, 1	#Avanzamos cadena
	j	idccond

idcfin:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 20
	jr	$ra

#Esta función dibuja la pantalla de "final de partida"
gameover:
	addiu	$sp, $sp, -28
	sw	$ra, 24($sp)
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	la 	$s0, pantalla		#guardamos pantalla en s0
	lw 	$s1, ($s0)		#guardamos en s1 la anchura de pantalla
	lw 	$s2, 4($s0)		#guardamos en s2 la altura de pantalla
	srl 	$s4, $s2, 1
	addi 	$s4, $s4, -2		#la altura a la que escribir el techo de guiones (altura/2-2)
	addi 	$s5, $s4, 4		#altura de la base (altura/2+2)

	addi 	$s1, $s1, -1
	move 	$a0, $s0		# Nota: imagen_set_pixel (Pantalla, coord_x, coord_y, 'caracter')
	li	$a1, 0
	move 	$a2, $s4
	li 	$a3, '+'		# Dibujo de la esquina superior izquierda '+'
	jal 	imagen_set_pixel

	move 	$a0, $s0
	move 	$a1, $s1
	move 	$a2, $s4
	li 	$a3, '+'		# Coloca '+' en la esquina superior derecha
	jal 	imagen_set_pixel

	move 	$a0, $s0
	li	$a1, 0
	move 	$a2, $s5
	li 	$a3, '+'		# Coloca '+' en la esquina inferior izquierda
	jal 	imagen_set_pixel

	move 	$a0, $s0
	move 	$a1, $s1
	move 	$a2, $s5
	li 	$a3, '+'		# Coloca '+' en la esquina inferior derecha
	jal 	imagen_set_pixel
					##Dibujo de base superior e inferior con '-'
	li	$s3, 1			# Comenzamos en la coordenada x=1
go1:	bge  	$s3, $s1, go2		# Salimos si s3 = s1, si llega al borde
	move 	$a0, $s0
	move 	$a1, $s3
	move 	$a2, $s4
	li 	$a3, '-'
	jal 	imagen_set_pixel	# Dibuja el techo

	move 	$a0, $s0
	move 	$a1, $s3
	move 	$a2, $s5
	li 	$a3, '-'
	jal 	imagen_set_pixel	# Dibuja el suelo

	addi 	$s3, $s3, 1		# Avanzamos en el ancho
	j	go1

					#Colocamos los laterales
go2:	addi	$s4, $s4, 1		#Avanzamos la altura de s4
	bge 	$s4, $s5 gofin		#Salimos si s4 = s5, cuando la altura de s4 llega a s5
	move 	$a0, $s0
	move	$a1, $s1
	move 	$a2, $s4
	li 	$a3, '|'
	jal 	imagen_set_pixel	# Colocamos las '|' del lado derecho
	move 	$a0, $s0
	li 	$a1, 0
	move 	$a2, $s4
	li 	$a3, '|'
	jal 	imagen_set_pixel	# Colocamos '|' del lado izquierdo
	j	go2
					#Recuadro terminado, imprimir cadenas

gofin:	addi 	$s5, $s5, -3
	move 	$a0, $s0
	srl	$s3, $s1, 1		#s3 = Ancho/2
	addi	$a1, $s3, -7		#Ya que "Fin de partida" tiene 14 caracteres, así se centra
	move	$a2, $s5
	la 	$a3, str004		#"Fin de partida"
	jal	imagen_dibuja_cadena

	addi	$s5, $s5, 1 		#Imprimimos la puntuación una línea más abajo
	move	$a0, $s0
	addi	$a1, $s3, -7		#"Puntuación: " alineado con Fin de partida
	move	$a2, $s5
	la	$a3, str003
	jal	imagen_dibuja_cadena

	lw	$a0, punt
	la	$a1, cadpunt
	jal	integer_to_string

	move	$a0, $s0
	addi	$a1, $s3, 6		# A continuación de "Puntuación: "
	move	$a2, $s5
	la	$a3, cadpunt
	jal	imagen_dibuja_cadena

	addi	$s5, $s5, 1		#Imprimimos "pulse una tecla" una línea más abajo
	move	$a0, $s0
	addi	$a1, $s3, -7		#Alineado
	move	$a2, $s5
	la 	$a3, str005
	jal	imagen_dibuja_cadena

	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$ra, 24($sp)
	addiu	$sp, $sp, 28
	jr	$ra


# Argumentos (int y), donde y es la fila a recorrer. La recorre hasta que tope con pixel vacío (return false, else return true)
# for (int x=0; (imagen_get_pixel (campo, x, y) != 0) || (x<campo->ancho); x++);
# if (x==campo->ancho) return 1; else return 0;
lineacompletada:
	addiu	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	move	$s0, $a0	#y
	li	$s1, 0		#x=0
	lw	$s2, campo  	#s2 = campo->ancho

rl0:	bge	$s1, $s2, rl1	#while {x < campo->ancho)

	la	$a0, campo
	move	$a1, $s1
	move	$a2, $s0
	jal	imagen_get_pixel

	beqz	$v0 rlfin	#Encontramos hueco (Pixel vacío), y devolvemos False

	addiu	$s1, $s1, 1	#x++
	j	rl0

rl1:	li	$v0, 1		#Sólo se alcanza si toda la línea no contiene píxel vacío, devolvemos True

rlfin:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$ra, 12($sp)
	addiu	$sp, $sp, 16
	jr	$ra

# Argumentos (int y), donde y es la fila a eliminar. La funcion debe bajar los pixeles de filas superiores una posicion
# for (int x = 0; x < campo->ancho; x++) {while (y>1) {imagen_set_pixel(campo, x, y, imagen_get_pixel (campo, x, y-1)); y--;}
eliminalinea:
	addiu	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	li	$s0, 0		#x=0
	lw	$s1, campo	#campo->ancho
	move	$s3, $a0	#s3=y

el1:	bge	$s0, $s1 elfin		#Condición de salida
	move	$s2, $s3		#Recuperamos el valor de y
	# while (y>1) do {
el2:	ble	$s2, 1, el3
	la	$a0, campo
	move	$a1, $s0
	addi	$a2, $s2, -1
	jal	imagen_get_pixel

	la	$a0, campo
	move	$a1, $s0
	move	$a2, $s2
	move	$a3, $v0
	jal	imagen_set_pixel	# imagen_set_pixel(campo, x, y, imagen_get_pixel (campo, x, y-1))

	addi	$s2, $s2, -1		# y--
	j	el2
	#}
el3:	addi	$s0, $s0, 1		#x++
	j	el1

elfin:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 20
	jr	$ra

# Comprueba si hay lineas completadas en las cercanías de pieza_actual y las trata, de arriba hacia abajo
# for (int y = pieza_actual_y ; pieza_actual_y+pieza_actual->alto > y ; y++)
# if(lineacompletada(y)){Puntuacion = Puntuacion + 10; eliminalinea(y)}

compruebalineas:

	addiu	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	lw	$s0, pieza_actual_y	#int y = pieza_actual_y
	lw	$s1, pieza_actual+4	#pieza_actual->alto
	add	$s1, $s0, $s1		#s1 = pieza_actual->alto + pieza_actual_y

cl0:	bge	$s0, $s1, cl2		#Condición de salida del bucle
	move	$a0, $s0
	jal	lineacompletada
	beqz	$v0, cl1		#if(lineacompletada(y)){Puntuacion = Puntuacion + 10; eliminalinea(y)}

	lw	$t1, punt		# Aumento de puntuación (y puntuación módulo 50, punt+4)
	addi	$t1, $t1, 10
	sw	$t1, punt

	lw	$t1, punt+4
	addi 	$t1, $t1, 10
	sw	$t1, punt+4

	move	$a0, $s0
	jal	eliminalinea

cl1:	addi	$s0, $s0, 1		#y++
	j	cl0

cl2:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$ra, 8($sp)
	addiu	$sp, $sp, 12
	jr	$ra

aumentarvelocidad:
	addiu 	$sp, $sp, -4
	sw	$ra, 0($sp)

	lw 	$t1, punt+4
	blt	$t1,  50, noaum
	addi 	$t1, $t1, -50
	sw	$t1, punt+4
	lw	$t2, pausa
	div 	$t3, $t2, 10
	sub	$t2, $t2, $t3
	sw	$t2, pausa
noaum:
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

imagen_pixel_addr:			# ($a0, $a1, $a2) = (imagen, x, y)
					# pixel_addr = &data + y*ancho + x
	lw	$t1, 0($a0)		# $a0 = dirección de la imagen
					# $t1 �? ancho
	mul	$t1, $t1, $a2		# $a2 * ancho
	addu	$t1, $t1, $a1		# $a2 * ancho + $a1
	addiu	$a0, $a0, 8		# $a0 �? dirección del array data
	addu	$v0, $a0, $t1		# $v0 = $a0 + $a2 * ancho + $a1
	jr	$ra

imagen_get_pixel:			# ($a0, $a1, $a2) = (img, x, y)
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)		# guardamos $ra porque haremos un jal
	jal	imagen_pixel_addr	# (img, x, y) ya en ($a0, $a1, $a2)
	lbu	$v0, 0($v0)		# lee el pixel a devolver
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

imagen_set_pixel:
	addiu	$sp, $sp, -8
	sw 	$s0, 4($sp)
	sw	$ra, 0($sp)

	move	$s0, $a3
	jal 	imagen_pixel_addr
	sb 	$s0, 0($v0)

	lw 	$ra, 0($sp)
	lw	$s0, 4($sp)
	addiu	$sp, $sp, 8
	jr	$ra

imagen_clean:
	addiu	$sp, $sp, -28
	sw	$ra, 24($sp)
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	lw	$s0, 0($a0) 	#ancho
	lw	$s1, 4($a0)	#alto
	move	$s4, $a0	#apuntador a imagen
	move	$s5, $a1	#fondo

	move 	$s2, $0		#y = 0
ic3:	bge	$s2, $s1, icfin
	move 	$s3, $0		#x = 0

ic1:	bge	$s3, $s0, ic2
	move	$a0, $s4
	move	$a1, $s3
	move	$a2, $s2
	move	$a3, $s5
	jal	imagen_set_pixel
	addi	$s3, $s3, 1
	j	ic1

ic2: 	addi	$s2, $s2, 1
	j 	ic3

icfin:

	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$ra, 24($sp)
	addiu	$sp, $sp, 28
	jr	$ra


imagen_init:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	sw 	$a1, 0($a0)
	sw	$a2, 4($a0)
	move	$a1, $a3
	jal	imagen_clean

	lw 	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

imagen_copy:
	addiu	$sp, $sp, -28
	sw	$ra, 24($sp)
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	move	$s2, $a0	#*dst movemos apuntador de dst a s2
	move 	$s3, $a1	#*src movemos apuntador a src a s3
	lw 	$s0, 0($s3)	#accedemos a la anchura de src
	sw	$s0, 0($s2)	#dst->ancho = src->ancho
	lw 	$s1, 4($s3)	#accedemos a la altura de src
	sw	$s1, 4($s2)	#dst->alto = src->alto
	#bucle for
	move 	$s4 $0		#y = 0
icop3:	bge	$s4, $s1, icopfin
	move 	$s5, $0		#x = 0

icop1:	bge	$s5, $s0, icop2

	move	$a0, $s3
	move	$a1, $s5
	move	$a2, $s4
	jal	imagen_get_pixel

	move	$a0, $s2
	move	$a1, $s5
	move	$a2, $s4
	move	$a3, $v0
	jal	imagen_set_pixel

	addi	$s5, $s5, 1
	j	icop1

icop2: 	addi	$s4, $s4, 1
	j 	icop3

icopfin:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$ra, 24($sp)
	addiu	$sp, $sp, 28
	jr	$ra



imagen_print:				# $a0 = img
	addiu	$sp, $sp, -24
	sw	$ra, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	move	$s0, $a0
	lw	$s3, 4($s0)		# img->alto
	lw	$s4, 0($s0)		# img->ancho
	#  for (int y = 0; y < img->alto; ++y)
	li	$s1, 0			# y = 0
B6_2:	bgeu	$s1, $s3, B6_5		# acaba si y ≥ img->alto
	#    for (int x = 0; x < img->ancho; ++x)
	li	$s2, 0			# x = 0
B6_3:	bgeu	$s2, $s4, B6_4		# acaba si x ≥ img->ancho
	move	$a0, $s0		# Pixel p = imagen_get_pixel(img, x, y)
	move	$a1, $s2
	move	$a2, $s1
	jal	imagen_get_pixel
	move	$a0, $v0		# print_character(p)
	jal	print_character
	addiu	$s2, $s2, 1		# ++x
	j	B6_3
	#    } // for x
B6_4:	li	$a0, 10			# print_character('\n')
	jal	print_character
	addiu	$s1, $s1, 1		# ++y
	j	B6_2
	#  } // for y
B6_5:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$ra, 20($sp)
	addiu	$sp, $sp, 24
	jr	$ra


imagen_dibuja_imagen:
	addiu	$sp, $sp, -36
	sw	$ra, 32($sp)
	sw	$s7, 28($sp)
	sw	$s6, 24($sp)
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	move	$s3, $a3
	lw	$s6, 4($s1)	#alto
	lw	$s7, 0($s1)	#ancho

	move 	$s4, $0		#y = 0
idi3:	bge	$s4, $s6, idifin
	move 	$s5, $0		#x = 0

idi1:	bge	$s5, $s7, idi2

	move	$a0, $s1
	move	$a1, $s5
	move	$a2, $s4
	jal	imagen_get_pixel
	move	$t0, $v0
	beqz	$t0, idif

	move	$a0, $s0
	add	$a1, $s2, $s5
	add	$a2, $s3, $s4
	move	$a3, $t0
	jal	imagen_set_pixel

idif:	addi	$s5, $s5, 1
	j	idi1

idi2: 	addi	$s4, $s4, 1
	j 	idi3

idifin:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$s6, 24($sp)
	lw	$s7, 28($sp)
	lw	$ra, 32($sp)
	addiu	$sp, $sp, 36
	jr	$ra





imagen_dibuja_imagen_rotada:
	addiu	$sp, $sp, -36
	sw	$ra, 32($sp)
	sw	$s7, 28($sp)
	sw	$s6, 24($sp)
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	move	$s0, $a0	#apuntador a dst
	move	$s1, $a1	#apuntador a src
	move	$s2, $a2	#dst_x
	move	$s3, $a3	#dst_y
	lw	$s6, 4($s1)	#alto
	lw	$s7, 0($s1)	#ancho

	move 	$s4, $0		#y = 0
idir3:	bge	$s4, $s6, idirfin
	move 	$s5, $0		#x = 0

idir1:	bge	$s5, $s7, idir2

	move	$a0, $s1
	move	$a1, $s5
	move	$a2, $s4
	jal	imagen_get_pixel
	move	$t0, $v0
	beqz	$t0, idirf

	move	$a0, $s0
	add	$a1, $s2, $s6
	add	$a1, $a1, -1
	sub	$a1, $a1, $s4

	add	$a2, $s3, $s5
	move	$a3, $t0
	jal	imagen_set_pixel

idirf:	addi	$s5, $s5, 1
	j	idir1

idir2: 	addi	$s4, $s4, 1
	j 	idir3

idirfin:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$s6, 24($sp)
	lw	$s7, 28($sp)
	lw	$ra, 32($sp)
	addiu	$sp, $sp, 36
	jr	$ra
pieza_aleatoria:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	li	$a0, 0
	li	$a1, 18 # Numero de piezas
	jal	random_int_range	# $v0 = random_int_range(0, 18)
	sll	$t1, $v0, 2
	la	$v0, piezas
	addu	$t1, $v0, $t1		# $t1 = piezas + $v0*4
	lw	$v0, 0($t1)		# $v0 = piezas[$v0]
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

actualizar_pantalla:
	addiu	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	la	$s0, pantalla
	la	$s2, campo
	move	$a0, $s0
	li	$a1, ' '
	jal	imagen_clean		# imagen_clean(pantalla, ' ')

	lb	$t1, final_partida
	beqz	$t1, apant0		#Si final_partida=0, imprimimos normal

apant2:	jal	gameover		# Se dibuja el mensaje de finalización
	j	apant1

apant0:
	lb	$t1, acabar_partida
	bnez	$t1, apant2		#Para evitar una impresión del campo
					##Marcador
	move	$a0, $s0
	move	$a1, $0			#x=0
	move	$a2, $0			#y=0
	la	$a3, str003
	jal	imagen_dibuja_cadena

	lw	$a0, punt
	la	$a1, cadpunt
	jal	integer_to_string

	move	$a0, $s0
	li	$a1, 13			#x=13
	move	$a2, $0			#y=0
	la	$a3, cadpunt
	jal	imagen_dibuja_cadena
					##FinMarcador

					##Pieza siguiente
	la	$a0, pantalla
	la	$a1, pieza_siguiente
	lw	$a2, campo		# coord x
	addi	$a2, $a2, 2
	li	$a3, 10			# coord y
	jal	imagen_dibuja_imagen	# imagen_dibuja_imagen(pantalla, pieza_actual, coord x, coord y)
					##Fin pieza siguiente

	# for (int y = 0; y < campo->alto; ++y) {
	lw	$t1, 4($s2)		# campo->alto
	beqz	$t1, B10_3		# sale del bucle si campo->alto == 0
	li	$s1, 2			# y = 2 (bajamos las barras laterales)
B10_2:	addiu	$s1, $s1, 1		# ++y
	move	$a0, $s0
	li	$a1, 0
	move	$a2, $s1
	li	$a3, '|'
	jal	imagen_set_pixel	# imagen_set_pixel(pantalla, 0, y, '|')
	lw	$t1, 0($s2)		# campo->ancho
	move	$a0, $s0
	addiu	$a1, $t1, 1		# campo->ancho + 1
	move	$a2, $s1
	li	$a3, '|'
	jal	imagen_set_pixel	# imagen_set_pixel(pantalla, campo->ancho + 1, y, '|')
	lw	$t1, 4($s2)		# campo->alto
	bltu	$s1, $t1, B10_2		# sigue si y < campo->alto
	# } // for y
	# for (int x = 0; x < campo->ancho + 2; ++x) {
B10_3:	li	$s1, 0			# x = 0
B10_5:	lw	$t1, 4($s2)		# campo->alto
	move	$a0, $s0
	move	$a1, $s1
	addiu	$a2, $t1, 1		# campo->alto + 1
	li	$a3, '-'
	jal	imagen_set_pixel	# imagen_set_pixel(pantalla, x, campo->alto + 1, '-')
	addiu	$s1, $s1, 1		# ++x
	lw	$t1, 0($s2)		# campo->ancho
	addiu	$t1, $t1, 2		# campo->ancho + 2
	bltu	$s1, $t1, B10_5		# sigue si x < campo->ancho + 2
	# } // for x
B10_6:	la	$s0, pantalla
	move	$a0, $s0
	move	$a1, $s2
	li	$a2, 1
	li	$a3, 1
	jal	imagen_dibuja_imagen	# imagen_dibuja_imagen(pantalla, campo, 1, 1)
	lw	$t1, pieza_actual_y
	lw	$v0, pieza_actual_x
	move	$a0, $s0
	la	$a1, pieza_actual
	addiu	$a2, $v0, 1		# pieza_actual_x + 1
	addiu	$a3, $t1, 1		# pieza_actual_y + 1
	jal	imagen_dibuja_imagen	# imagen_dibuja_imagen(pantalla, pieza_actual, pieza_actual_x + 1, pieza_actual_y + 1)
apant1:	jal	clear_screen		# clear_screen()
	move	$a0, $s0
	jal	imagen_print		# imagen_print(pantalla)

	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$ra, 12($sp)
	addiu	$sp, $sp, 16
	jr	$ra

nueva_pieza_actual:

	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	la	$a0, pieza_actual
	la	$a1, pieza_siguiente
	jal	imagen_copy

	jal	pieza_aleatoria
	la	$a0, pieza_siguiente
	move	$a1, $v0
	jal	imagen_copy

	lw	$a0, campo		#La mitad del campo
	srl	$a0, $a0, 1
	addi	$a0, $a0, 1
	li	$a1, 2			#Bajamos la altura de la nueva pieza, junto con las barras laterales
	jal	intentar_movimiento

	beqz	$v0, npafin0		#Si no se puede colocar la pieza, no la colocamos, $v0 = 0
	lw	$t0, punt		#Puntuacion++
	addi	$t0, $t0, 1
	sw	$t0, punt

	lw	$t0, punt+4		#Puntuacion(mod 50)++
	addi	$t0, $t0, 1
	sw	$t0, punt+4

	j	npafin1

npafin0:li	$t1, 1
	sw	$t1, final_partida	#final_partida=1, sólo si !intentar_movimiento

npafin1:lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

probar_pieza:				# ($a0, $a1, $a2) = (pieza, x, y)
	addiu	$sp, $sp, -32
	sw	$ra, 28($sp)
	sw	$s7, 24($sp)
	sw	$s6, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	move	$s0, $a2		# y
	move	$s1, $a1		# x
	move	$s2, $a0		# pieza
	li	$v0, 0
	bltz	$s1, B12_13		# if (x < 0) return false
	lw	$t1, 0($s2)		# pieza->ancho
	addu	$t1, $s1, $t1		# x + pieza->ancho
	la	$s4, campo
	lw	$v1, 0($s4)		# campo->ancho
	bltu	$v1, $t1, B12_13	# if (x + pieza->ancho > campo->ancho) return false
	bltz	$s0, B12_13		# if (y < 0) return false
	lw	$t1, 4($s2)		# pieza->alto
	addu	$t1, $s0, $t1		# y + pieza->alto
	lw	$v1, 4($s4)		# campo->alto
	bltu	$v1, $t1, B12_13	# if (campo->alto < y + pieza->alto) return false
	# for (int i = 0; i < pieza->ancho; ++i) {
	lw	$t1, 0($s2)		# pieza->ancho
	beqz	$t1, B12_12
	li	$s3, 0			# i = 0
	#   for (int j = 0; j < pieza->alto; ++j) {
	lw	$s7, 4($s2)		# pieza->alto
B12_6:	beqz	$s7, B12_11
	li	$s6, 0			# j = 0
B12_8:	move	$a0, $s2
	move	$a1, $s3
	move	$a2, $s6
	jal	imagen_get_pixel	# imagen_get_pixel(pieza, i, j)
	beqz	$v0, B12_10		# if (imagen_get_pixel(pieza, i, j) == PIXEL_VACIO) sigue
	move	$a0, $s4
	addu	$a1, $s1, $s3		# x + i
	addu	$a2, $s0, $s6		# y + j
	jal	imagen_get_pixel
	move	$t1, $v0		# imagen_get_pixel(campo, x + i, y + j)
	li	$v0, 0
	bnez	$t1, B12_13		# if (imagen_get_pixel(campo, x + i, y + j) != PIXEL_VACIO) return false
B12_10:	addiu	$s6, $s6, 1		# ++j
	bltu	$s6, $s7, B12_8		# sigue si j < pieza->alto
	#   } // for j
B12_11:	lw	$t1, 0($s2)		# pieza->ancho
	addiu	$s3, $s3, 1		# ++i
	bltu	$s3, $t1, B12_6 	# sigue si i < pieza->ancho
	# } // for i
B12_12:	li	$v0, 1			# return true
B12_13:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s6, 20($sp)
	lw	$s7, 24($sp)
	lw	$ra, 28($sp)
	addiu	$sp, $sp, 32
	jr	$ra

intentar_movimiento:

	addiu	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	move	$s0, $a0
	move	$s1, $a1

	move	$a2, $s1
	move	$a1, $s0
	la	$a0, pieza_actual
	jal	probar_pieza

	beqz	$v0, imfin
	la	$t0, pieza_actual_x
	sw	$s0, 0($t0)
	la	$t0, pieza_actual_y
	sw	$s1, 0($t0)

imfin:	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$ra, 8($sp)
	addiu	$sp, $sp, 12
	jr	$ra

bajar_pieza_actual:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

	lw	$a0, pieza_actual_x
	lw	$a1, pieza_actual_y
	addi	$a1, $a1, 1
	jal	intentar_movimiento

	bnez	$v0, bpafin
	la	$a0, campo
	la	$a1, pieza_actual
	lw	$a2, pieza_actual_x
	lw	$a3, pieza_actual_y
	jal	imagen_dibuja_imagen

	jal	compruebalineas

	jal	nueva_pieza_actual

	jal	aumentarvelocidad
bpafin:	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra


intentar_rotar_pieza_actual:

	addiu	$sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$s0, 0($sp)

	la	$s0, imagen_auxiliar
	move	$a0, $s0
	lw	$a1, pieza_actual+4
	lw	$a2, pieza_actual
	li	$a3, 0
	jal	imagen_init

	move	$a0, $s0
	la	$a1, pieza_actual
	li	$a2, 0
	li	$a3, 0
	jal	imagen_dibuja_imagen_rotada

	move	$a0, $s0
	lw	$a1, pieza_actual_x
	lw	$a2, pieza_actual_y
	jal	probar_pieza

	beqz	$v0, irpafin
	la	$a0, pieza_actual
	move	$a1, $s0
	jal	imagen_copy

irpafin:
	lw	$s0, 0($sp)
	lw	$ra, 4($sp)
	addiu	$sp, $sp, 8
	jr	$ra

tecla_salir:
	li	$v0, 1
	sb	$v0, acabar_partida	# acabar_partida = true
	sb	$0, final_partida	# final_partida = false
	jr	$ra

tecla_izquierda:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	lw	$a1, pieza_actual_y
	lw	$t1, pieza_actual_x
	addiu	$a0, $t1, -1
	jal	intentar_movimiento	# intentar_movimiento(pieza_actual_x - 1, pieza_actual_y)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

tecla_derecha:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	lw	$a1, pieza_actual_y
	lw	$t1, pieza_actual_x
	addiu	$a0, $t1, 1
	jal	intentar_movimiento	# intentar_movimiento(pieza_actual_x + 1, pieza_actual_y)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

tecla_abajo:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	jal	bajar_pieza_actual	# bajar_pieza_actual()
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

tecla_rotar:
	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)
	jal	intentar_rotar_pieza_actual	# intentar_rotar_pieza_actual()
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

procesar_entrada:
	addiu	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s4, 12($sp)
	sw	$s3, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	jal	keyio_poll_key
	move	$s0, $v0		# int c = keyio_poll_key()
	# for (int i = 0; i < sizeof(opciones) / sizeof(opciones[0]); ++i) {
	li	$s1, 0			# i = 0, $s1 = i * sizeof(opciones[0]) // = i * 8
	la	$s3, procesar_entrada.opciones
	li	$s4, 40			# sizeof(opciones) // == 5 * sizeof(opciones[0]) == 5 * 8
B21_1:	addu	$t1, $s3, $s1		# procesar_entrada.opciones + i*8
	lb	$t2, 0($t1)		# opciones[i].tecla
	bne	$t2, $s0, B21_3		# if (opciones[i].tecla != c) siguiente iteración
	lw	$t2, 4($t1)		# opciones[i].accion
	jalr	$t2			# opciones[i].accion()
	jal	actualizar_pantalla	# actualizar_pantalla()
B21_3:	addiu	$s1, $s1, 8		# ++i, $s1 += 8
	bne	$s1, $s4, B21_1		# sigue si i*8 < sizeof(opciones)
	# } // for i
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s3, 8($sp)
	lw	$s4, 12($sp)
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 20
	jr	$ra

jugar_partida:
	addiu	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	la	$a0, pantalla		#Cargamos las dimensiones de la pantalla y el campo, para inicializarlos con blancos y pixel vacio
	lw	$a1, pantalla
	lw	$a2, pantalla +4
	li	$a3, 32
	jal	imagen_init		# imagen_init(pantalla, 20, 22, ' ')
	la	$a0, campo
	lw	$a1, campo
	lw	$a2, campo +4
	li	$a3, 0
	jal	imagen_init		# imagen_init(campo, 14, 20, PIXEL_VACIO)

	jal	pieza_aleatoria		# Inicializamos la pieza siguiente
	la	$a0, pieza_siguiente
	move	$a1, $v0
	jal	imagen_copy

	jal	nueva_pieza_actual	# nueva_pieza_actual()

	sb	$zero, acabar_partida	# acabar_partida = false
	jal	get_time		# get_time()
	move	$s0, $v0		# Hora antes = get_time()
	jal	actualizar_pantalla	# actualizar_pantalla()
	j	B22_2
	# while (!acabar_partida) {
B22_2:	lbu	$t1, acabar_partida
	bnez	$t1, B22_5		# if (acabar_partida != 0) sale del bucle
	jal	procesar_entrada	# procesar_entrada()
	jal	get_time		# get_time()
	move	$s1, $v0		# Hora ahora = get_time()
	subu	$t1, $s1, $s0		# int transcurrido = ahora - antes
	lw	$t5, pausa
	addi	$t5, $t5, 1		# pausa+1
	bltu	$t1, $t5, B22_2	# if (transcurrido < pausa + 1) siguiente iteración
B22_1:	jal	bajar_pieza_actual	# bajar_pieza_actual()
	jal	actualizar_pantalla	# actualizar_pantalla()
	move	$s0, $s1		# antes = ahora
        j	B22_2			# siguiente iteración
       	# }

B22_5:	sb 	$zero, punt		# Puntuacion = 0
	sb	$zero, punt+4		# Puntuacion (mod 50) = 0
	li	$t0, 1000		# pausa = 1000
	sw	$t0, pausa

	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$ra, 8($sp)
	addiu	$sp, $sp, 12
	jr	$ra


#
configuracion:

	addiu	$sp, $sp, -4
	sw	$ra, 0($sp)

conf0:	jal	clear_screen		# clear_screen()
	la	$a0, str006
	jal	print_string		# printf ("Configuración:\n\n 1 - Tamaño del campo\n 2 - Velocidad inicial\n 3 - Controles\n 4 - Relleno de la pieza\n 5 - Menú principal\n\nElige una opción:\n")
	jal	read_character		# char opc = read_character()
	beq	$v0, '5', conf5		# Jugar
	beq	$v0, '4', conf4		# Relleno de pieza
	beq	$v0, '3', conf3		# Controles
	beq	$v0, '2', conf2		# Velocidad inicial
	bne	$v0, '1', conferr	# if (opc != '1') mostrar error
	jal	Cambia_Tamanyo_Campo	#Tamaño campo
	j	conf0

conf2:	jal	Cambia_Velocidad
	j	conf0
conf3:	jal	Cambia_Controles
	j	conf0
conf4:	jal	Cambia_Relleno
	j	conf0
conferr:la	$a0, str002
	jal	print_string		# print_string("\nOpción incorrecta. Pulse cualquier tecla para seguir.\n")
	jal	read_character		# read_character()
	j	conf0

conf5:	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4

	jr	$ra


	.globl	main
main:					# ($a0, $a1) = (argc, argv)


	addiu	$sp, $sp, -4

	sw	$ra, 0($sp)
B23_2:	jal	clear_screen		# clear_screen()
	la	$a0, str000
	jal	print_string		# print_string("Tetris\n\n 1 - Jugar\n 3 - Salir\n\nElige una opción:\n")
	jal	read_character		# char opc = read_character()
	beq	$v0, '3', B23_1		# if (opc == '3') salir
	beq	$v0, '2', B23_6		# else if (opc == '2') configuracion
	bne	$v0, '1', B23_5		# if (opc != '1') mostrar error
	jal	jugar_partida		# jugar_partida()
	j	B23_2

B23_6:	jal	configuracion		#configuracion ()
	j	B23_2

B23_1:	la	$a0, str001
	jal	print_string		# print_string("\n¡Adiós!\n")
	li	$a0, 0
	jal	mips_exit		# mips_exit(0)
	j	B23_2
B23_5:	la	$a0, str002
	jal	print_string		# print_string("\nOpción incorrecta. Pulse cualquier tecla para seguir.\n")
	jal	read_character		# read_character()
	j	B23_2
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 4
	jr	$ra

#
# Funciones de la librería del sistema
#

print_character:
	li	$v0, 11
	syscall
	jr	$ra

print_string:
	li	$v0, 4
	syscall
	jr	$ra

get_time:
	li	$v0, 30
	syscall
	move	$v0, $a0
	move	$v1, $a1
	jr	$ra

read_character:
	li	$v0, 12
	syscall
	jr	$ra

clear_screen:
	li	$v0, 39
	syscall
	jr	$ra

mips_exit:
	li	$v0, 17
	syscall
	jr	$ra

random_int_range:
	li	$v0, 42
	syscall
	move	$v0, $a0
	jr	$ra

keyio_poll_key:
	li	$v0, 0
	lb	$t0, 0xffff0000
	andi	$t0, $t0, 1
	beqz	$t0, keyio_poll_key_return
	lb	$v0, 0xffff0004
keyio_poll_key_return:
	jr	$ra



