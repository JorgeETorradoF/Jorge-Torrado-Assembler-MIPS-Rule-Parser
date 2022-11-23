.data

.align 2

muchotexto: .asciiz "\nIngrese 1 para buscar por IP\nIngrese 2 para buscar por Usm\n" 

#Este de arriba tiene 16 espacios de 4 bytes cada uno (osea tamaño de 4x16)

.align 2

mensajeIngrese: .asciiz "\nIngrese dato a buscar: "

.align 2

mensajeNoEncontrado: .asciiz "\nError 404, dato no encontrado"

.align 2

mensajeIP: .asciiz "\nIP:                            "

.align 2

mensajeUsm: .asciiz " Usm:                           "

.align 2

mensajeFecha: .asciiz " Fecha (Epoch):                 "

.align 2

dataInput: .asciiz "/home/jorgetorrado/Desktop/ProyectoFinalMips/data.txt"

.align 2

bufferData: .space 20000  #max 100 por linea y 200 lineas max este caso no toca el x4 pq leo chars y 1 char = 1 byte

.align 2

Condiciones: .asciiz "/home/jorgetorrado/Desktop/ProyectoFinalMips/Parsing_Rules.config"

.align 2

bufferCondiciones: .space 200  #max 100 por linea y 2 lineas max este caso no toca el x4 pq leo chars y 1 char = 1 byte

.align 2

archivoOutput: .asciiz "/home/jorgetorrado/Desktop/ProyectoFinalMips/Alerts_Triggered.log"

consultaOutput: .asciiz "/home/jorgetorrado/Desktop/ProyectoFinalMips/Report.log"

.align 2

Null:  .asciiz "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0" #para comparar si está nulo

.align 2

bufferIPOut: .space 12800  #32 pq cada vez que encuentro coincidencia la meto y el string es de max 32

.align 2

bufferConsulta: .space 400

.align 2

arregloIP:  .space 320  #para leer las condiciones del archivo de 2 lineas, se asume que hay máximo 10 ips en la linea 1

.align 2

arregloUsernames:  .space 320 #para leer las condiciones del archivo de 2 lineas, se asume que hay maximo 10 usernames en la linea 2

#veo la matriz como un arreglo de 1 dimension (filas * columnas)

.align 2

tablaIPs:   .space 6400

.align 2

tablaUsm:   .space 6400

.align 2

tablaFechas: .space 6400

.align 2


#se declaran variables auxiliares para comparar y ordenar el arreglo por fechas (y tambien para ver si es una alerta)

.align 2

auxIP: .space 32

.align 2

auxUsm: .space 32

.align 2

auxFecha: .space 32

.align 2

parametroIP: .space 32

.align 2

parametroUsm: .space 32

.align 2

parametroFecha: .space 32

.text
	#Se procede a leer el archivo de data
	li 	$v0,13
	la	$a0,dataInput
	li	$a1,0
	li	$a2,0
	syscall
	##lo de arriba lo abre

move	$t0,$v0
	
	li	$v0,14
	move	$a0,$t0
	la	$a1,bufferData
	li	$a2,19999
	syscall
	
	#lo de arriba lo lee
	
	li	$v0,16
	move	$a0,$t0
	syscall
	#lo de arriba lo cierra
		
       #Se procede a leer el archivo de parsing rules
       
       	li 	$v0,13
	la	$a0,Condiciones
	li	$a1,0
	li	$a2,0
	syscall
	
        #lo de arriba lo abre
        
	li	$v0,14
	move	$a0,$t0
	la	$a1,bufferCondiciones
	li	$a2,199
	syscall
	
	#lo de arriba lo lee
	
	li	$v0,16
	move	$a0,$t0
	syscall
	
	#lo de arriba lo cierra



	#aquí empieza lo turbio
	
	
	
	
	#Extraigo IP y Usernames en 2 arreglos distintos
	
	
	
    la $t5, bufferCondiciones

    la $t7, arregloIP #guardo direccion de memoria de la primera casilla
    
    move $t8,$t7  #copia de seguridad del indice de la primera dir memoria de arregloIP
    
    li $t2,0 #contador por si las moscas
    
    addi $t5,$t5,3 #para no coger la palabra "IP:"

loopExtraerIP:

lb $t0, 0($t5)

bne $t0, ',', loopExtraerIPNormal

li $t0, '\n'

sb $t0, 0($t7)

addi $t8,$t8,32  #paso a la siguiente "casilla" del array, como es string cada casilla es de 32

move $t7,$t8  

addi $t5,$t5,1

jal loopExtraerIP

loopExtraerIPNormal:

beq $t2,150,exitLoopExtraerIP #cada linea tiene maximo 10, si ya leí toda la linea me salgo

sb $t0, 0($t7)

addi $t5,$t5,1 #corro 1 casilla en el bufferCondiciones

addi $t7,$t7,1 #corro 1 posicion en el arregloIP

addi $t2,$t2,1 #aumento el contador

beq $t0,'\n',exitLoopExtraerIP

jal loopExtraerIP

exitLoopExtraerIP:

addi $t5,$t5,9 #para no coger el "Username:"

la $t7, arregloUsernames #para meter al arregloUsernames

move $t8, $t7 #copia de seguridad para manejar las caillas del arreglo de manera mas ordenada (cada 32 bytes hay nueva casilla pq es string)

li $t2, 0 #contador 0 para el nuevo bucle

loopExtraerUsernames:

lb $t0, 0($t5)

bne $t0, ',', loopExtraerUnmNormal

li $t0, '\n'

sb $t0, 0($t7)

addi $t8,$t8,32 #paso a registrar data en la siguiente "casilla" del arreglo

move $t7,$t8

addi $t5,$t5,1

jal loopExtraerUsernames

loopExtraerUnmNormal:

beq $t2,150,exitLoopExtraerUsernames

sb $t0, 0($t7)

addi $t5,$t5,1 #corro 1 casilla en el bufferCondiciones

addi $t7,$t7,1 #corro 1 posicion en el arregloUsernames

addi $t2,$t2,1 #aumento el contador en 1

beq $t0,'\n',exitLoopExtraerUsernames

jal loopExtraerUsernames
	
exitLoopExtraerUsernames:	


	
	
	#Todo lo relacionado con las tablas
	
	
		
				
    li $t2,0 #contador (por si las moscas, si llega a 6400, que es el tamaño máximo posible del bufferData se rompe el bucle)

    li $t9,0 #bandera que me indicará si lo que estoy leyendo es ip, username o fecha (basado en el patrón de los ":")	
			
    la $t5, bufferData #en t5 guardo dir inicial del bufferData
    
    la $t7, tablaIPs #en t7 guardo dir de tabla IPs
    
    move $s3, $t7 #copia de seguridad para manejar ordenadamente las "casillas" (de 32 en 32 aumentan)
    
    la $s0, tablaUsm #en s0 guardo dir de tabla usernames
    
    move $s4, $s0 #copia de seguridad para manejar ordenadamente las "casillas" (de 32 en 32 aumentan)
    
    la $s1, tablaFechas #en s1 guardo dir de tabla de fechas

    move $s5, $s1 #copia de seguridad para manejar ordenadamente las "casillas" (de 32 en 32 aumentan)
	
loopTablaLog:

    beq $t2,6400,exitLoopTablaLog #si llegué al maximo me salgo del loop
    
    
    #tip: lb $t0, 0($t5) para acceder al valor de la dir de memoria que guardo en t5
    
   
     lb $t1, 0($t5) #saco el contenido de la dir de memoria que guardé en t5 y lo almaceno en t1

    beq $t1, '\0', exitLoopTablaLog #si no hay mas que leer me salgo del loop
    
    beq $t1, ':',compruebaPatron #compruebo si hay un : actualizo la bandera del patrón de ":"
    
    beq $t1, '\n',agregaseparador #si hay salto de linea, vuelvo a ejecutar el bucle
    
switchInfo:
    
    beq $t9, 1, agregaarregloIPs
    
    beq $t9, 2, aregaarregloUsnm
    
    beq $t9, 3, agregaarregloFechas
    
continuarLoopTablaLog:
    
    addi $t2, $t2,1 #aumento el contador general (a las 6400 se rompe por eso el beq de arriba)
    
    addi $t5,$t5,1 #corro el apuntador de bufferdata a la siguiente casilla (recuerda que esto se comporta como un arreglo char)

    jal loopTablaLog
    
agregaarregloIPs:

    beq $t1, '|', continuarLoopTablaLog
    
    beq $t1, 'u', continuarLoopTablaLog
    
    beq $t1, 'n', continuarLoopTablaLog
    
    beq $t1, 'm', continuarLoopTablaLog
    
    beq $t1, 0xffffffc2, continuarLoopTablaLog
    
    beq $t1, 0xffffffb4, continuarLoopTablaLog
    
    beq $t1, 0x00000027, continuarLoopTablaLog
    
    beq $t1, ':', continuarLoopTablaLog
    
    #los beq de aquí son para evitar que se copien los |unm:
    
    sb $t1,0($t7) #copio el char (guardado en t1) a tablaIPs que es el 0($t7)
    
    addi $t7,$t7,1 #corro 1 casilla el arreglo de IPs
    
    jal continuarLoopTablaLog

aregaarregloUsnm:

    beq $t1, '|', ignorartps
    
    jal normalUsm
    
ignorartps:
   
    addi $t2, $t2,3 #aumento el contador general (a las 6400 se rompe por eso el beq de arriba)
    
    addi $t5,$t5,3 #corro el apuntador de bufferdata a la siguiente casilla (recuerda que esto se comporta como un arreglo char)

    jal continuarLoopTablaLog
    
normalUsm:
    
    beq $t1, 0xffffffc2, continuarLoopTablaLog
    
    beq $t1, 0xffffffb4, continuarLoopTablaLog
    
    beq $t1, 0x00000027, continuarLoopTablaLog
    
    beq $t1, ':', continuarLoopTablaLog
    
    #los beq de aquí son para evitar que se copien los |tsp:

    sb $t1,0($s0) #copio el char (guardado en t1) a tablaIPs que es el 0($t7)
    
    addi $s0,$s0,1 #corro 1 casilla el arreglo de Usnm
    
    jal continuarLoopTablaLog

agregaarregloFechas:

    beq $t1, 0xffffffc2, continuarLoopTablaLog
    
    beq $t1, 0xffffffb4, continuarLoopTablaLog
    
    beq $t1, 0x00000027, continuarLoopTablaLog

    beq $t1, '|', continuarLoopTablaLog
    
    beq $t1, 'i', continuarLoopTablaLog
    
    beq $t1, 'p', continuarLoopTablaLog
    
    beq $t1, ':', continuarLoopTablaLog
    
    #los beq de aquí son para evitar que se copien los |IP:

    sb $t1,0($s1) #copio el char (guardado en t1) a tablaIPs que es el 0($t7)
    
    addi $s1,$s1,1 #corro 1 casilla el arreglo de fechas
    
    jal continuarLoopTablaLog
    
compruebaPatron:
   
    addi $t9,$t9,1
    
    jal switchInfo
    
agregaseparador:
    li $t9,0 #si hay \n se resetea el patrón de los ":" que consiste en que el 1 es ip el 2 es usnm y el 3 la fecha
    
    li $s6,'\n'
    
    sb $s6, 0($t7)
    
    sb $s6, 0($s0)
    
    sb $s6, 0($s1)
    
    addi $s3,$s3,32
    
    move $t7, $s3
    
    addi $s4,$s4,32
    
    move $s0, $s4
    
    addi $s5,$s5,32
    
    move $s1, $s5
    
    jal continuarLoopTablaLog

exitLoopTablaLog:
    
    jal ordenarFechas
    
    

    #Detección de Alertas




#ESTO DE ABAJO ES UNA FUNCIÓN, CUANDO ACABA SE DEVUELVE A LA LINEA DE ABAJO DEL JAL QUE LA INVOCÓ



    
sacarUnaIP:    
    
    li $t0, 0 #a los 8 se rompe pq voy de a 4 en el bucle con los bytes y son 32 bytes 32/4 = 8
    
    move $t1, $ra #guardo el lugar al que debo devolverme
    
loopSacarUnaIP:

    beq $t0, 8, exitSacarUnaIP
      
    lw $t8, ($t3) #saco 4 bytes del arreglo que cargaron a este registro antes de invocar esta función hacia t8
    
    sw $t8, ($t6) #guardo los 4 bytes en el arreglo que cargaron a este registro antes de invocar esta función
    
    addi $t6, $t6, 4
    
    addi $t3, $t3, 4
        
    addi $t0, $t0, 1 #aumento contador para evitar salirme del arreglo auxIP
    
    jal loopSacarUnaIP
    
exitSacarUnaIP: 

    jr $t1
    
mandarAlBufferW:

    move $t1, $ra
    
    move $t4, $s1
    
    addi $t5, $t4, 32  #maximo espacio
    
    #OJO: PON 9 PARA ARCHIVO WRITE APPEND
    
loopMandarBufferW:

   beq $t4, $t5, exitMandarBufferW

   lw $s1, ($t4)
   
   sw $s1, ($t7)
   
   addi $t4, $t4, 4
   
   addi $t7, $t7, 4
   
   jal loopMandarBufferW
    
exitMandarBufferW:

    jr $t1   
    
compararIP:

    li $s5, 1 #booleano de si son iguales o no

    move $t1, $ra 
    
    addi $t2, $s1, 32 #maximo del arreglo

loopComIP:

    beq $s1, $t2, exitCompararIP
    
    beq $s5, 0, exitCompararIP
    
    lw $s0, ($s1)
    
    lw $t6, ($s2)
    
    bne $s0, $t6, negarIP
    
    jal continuarComIP

negarIP:

    li $s5, 0 #se niega el booleano
    
    jal exitCompararIP
    
continuarComIP:

    addi $s1, $s1, 4 #voy a los siguientes 4 bytes de un parámetro
    
    addi $s2, $s2, 4 #voy a los siguientes 4 bytes del otro parámetro

    jal loopComIP

exitCompararIP:
  
    jr $t1
    

MayorMenor:
    li $s5, 0 #booleano (1 si el primero es mayor al segundo, -1 si ocurre lo opuesto, 0 si son iguales)

    move $t1, $ra 
    
    addi $t2, $s1, 32 #maximo del arreglo
    
loopMayorMenor:

    beq $s1, $t2, exitMayorMenor
    
    lb $s0, ($s1)
    
    lb $t6, ($s2)
    
    beq $s0, '\0', banderaRomper
    
    beq $t6, '\0', banderaRomper
    
    jal exitBanderaRomper
    
banderaRomper:

    li $s5, 2
    
    jal exitMayorMenor

exitBanderaRomper:
    
    bgt $s0, $t6, mayor #estos branch son para sacar una bandera booleana acorde a las condiciones (si son iguales no hay branch pues como cargo 0 en $s5, se va a quedar esa bandera como 0 hasta que se llegue al final de las fechas o hasta que se encuentre que uno es mayor a otro
    
    blt $s0, $t6, menor
    
    jal continuarMayorMenor

mayor:

    li $s5, 1 #cargo 1 para señalar que es mayor
    
    jal exitMayorMenor
    
menor:

    li $s5, -1 #cargo -1 para señalar que es mayor
    
    jal exitMayorMenor
    
continuarMayorMenor:

    addi $s1, $s1, 1 #voy al siguiente byte de un parámetro
    
    addi $s2, $s2, 1 #voy al siguiente byte del otro parámetro

    jal loopMayorMenor

exitMayorMenor:
  
    jr $t1      
    
    
    #SI QUIERES VER EL VALOR EN MEMORIA DEBES USAR EL SW, LAS COSAS CON WORD SOLO TOMAN 4 BYTES, TE TOCA IR MOVIENDO EL APUNTADOR


    #SE ACABAN LAS FUNCIONES
    
    
    #ESTE FRAGMENTO DE CODIGO ES EXPERIMENTAL
ordenarFechas:
   li $t9, 0 #Contdor, Si llega a los 6368 bytes lo saco del loop
   
   la $t4, tablaIPs
   
   la $t5, tablaUsm
   
   la $t7, tablaFechas
  
   la $s7, 0   #Bandera Booleana, si es 0, me salgo, si es 1 repito (esto esta basado en el buble sort donde hay bandera booleana de repetir)
     
loopOrdenar:

   beq $t9, 6368, exitOrdenar #Lo rompo si llego al maximo (tam-2 pq voy a coger casilla i y además casilla i+1 para comparar)
        
   move $s3, $t4 #Paso la casilla J de tablaIP  de t4 a s3
 
   addi $s3, $s3, 32 #SERÍA COMO COGER LA CASILLA J+1    de tablaIP
   
   move $s4, $t5 #Paso la casilla J de tablaUsm de t5 a s4
   
   addi $s4, $s4, 32 #SERÍA COMO COGER LA CASILLA J+1 de tablaUsm
    
   move $s6, $t7 #Paso la casilla J de tablaFechas de t5 a s4
   
   addi $s6, $s6, 32 #SERÍA COMO COGER LA CASILLA J+1 de tablaFechas
   
   move $s1, $t7 #cargo casilla J de tablaFechas
   
   move $s2, $s6 #Cargo casilla J+1 DE TablaFechas
   
   jal MayorMenor
   
   beq $s5, 1, cambiarOrden #si el J es mayor a J+1 cambio lugares, pues debo ordenar de menor a mayor
  
   beq $s5, 2, exitOrdenar
  
   jal continuarOrdenar
   
   #Procedo a cambiar lugares, este fragmento solo ocurre si el branch de arriba no se cumple, osea, si J no es menor a J+1
   
cambiarOrden:
   
   li $s7, 1  #bandera booleana la pongo positiva   
   
   move $t3, $t4
   
   la $t6, auxIP
   
   jal sacarUnaIP
   
    move $t3, $t5
   
   la $t6, auxUsm
   
   jal sacarUnaIP
   
    move $t3, $t7
   
   la $t6, auxFecha
   
   jal sacarUnaIP  
   
   #con las lineas de arriba copio las casillas J de las tablas de IP usm, y fecha en espacios de memoria auxiliares
   
   #Procedo a pasar lo de J+1 a J
   
   move $t3, $s3
   
   move $t6,$t4
   
   jal sacarUnaIP
   
   move $t3, $s4
   
   move $t6, $t5
   
   jal sacarUnaIP
   
   move $t3, $s6
   
   move $t6, $t7
   
   jal sacarUnaIP
   
   #Procedo a pasar lo de los auxiliares (TIENEN LA ANTIGUA DATA DE LA CASILLA J) a las casillas J+1
   
   la $t3, auxIP
   
   move $t6, $s3
   
   jal sacarUnaIP
   
   la $t3, auxUsm
   
   move $t6, $s4
   
   jal sacarUnaIP
   
   la $t3, auxFecha
   
   move $t6, $s6
   
   jal sacarUnaIP
   
continuarOrdenar:

  addi $t4, $t4, 32

  addi $t5, $t5, 32

  addi $t7, $t7, 32

  addi $t9, $t9, 32

  jal loopOrdenar
   
exitOrdenar:  

   beq $s7, 0, terminarOrdenar 
   
   li $t9, 0
   
   jal ordenarFechas
   
terminarOrdenar:

    la $s1, auxIP
    
    la $t7, bufferIPOut
   
       
    #AQUI ACABA EL FRAGMENTO EXPERIMENTAL

alertasIP:

    li $s7, 0 #contador del loopTabla IP, este loop recorre tablaIP por lo que su tamaño maximo es 200 (200 lineas, pues cada linea tiene 32 bytes)

    la $s3, tablaIPs

loopTablaIP:

    beq $s7, 200, exitLoopTablaIP

    move $t3, $s3 #el parametro de funcion t3 es de donde saco la data
    
    la $t6, auxIP #el parámetro de funcion t6 es en donde voy a guardar la data
    
    jal sacarUnaIP #invoco la función que lee una casilla del arreglo TablaIPs
    
    la $t9, arregloIP #Contador que me indicará si ya comparé con todas las IP sospechosas
    
    addi $t9, $t9, 320 #Saco dir memoria donde se acaba el array
    
CondicionesIP:

    la $t3, arregloIP #el parametro de funcion t3 es de donde saco la data
    
LoopCondicionesIP:    
   
    la $t6, parametroIP #el parámetro de funcion t6 es en donde voy a guardar la data
    
    jal sacarUnaIP #invoco la función que lee una casilla del arreglo TablaIPs

    beq $t3, $t9, exitLoopCondIP
    
    la $s1, auxIP
    
    la $s2, parametroIP
    
    jal compararIP
    
    beq $s5, 0, LoopCondicionesIP #la funcion booleana "retorna" un valor a s5, comparo y si es 0 significa que las IP no son iguales, entonces vuelvo a repetir el bucle
    
    la $s1, auxIP
    
    jal mandarAlBufferW
    
exitLoopCondIP:
    
    addi $s7, $s7, 1 #aumento en 1 el contador
    
    addi $s3, $s3, 32 #paso a la siguiente casilla
    
    jal loopTablaIP
    
exitLoopTablaIP: 

 
alertasUsm:

    li $s7, 0 #contador del loopTabla IP, este loop recorre tablaIP por lo que su tamaño maximo es 200 (200 lineas, pues cada linea tiene 32 bytes)

    la $s3, tablaUsm

loopTablaUsm:

    beq $s7, 200, exitLoopTablaUsm

    move $t3, $s3 #el parametro de funcion t3 es de donde saco la data
    
    la $t6, auxUsm #el parámetro de funcion t6 es en donde voy a guardar la data
    
    jal sacarUnaIP #invoco la función que lee una casilla del arreglo TablaIPs
    
    la $t9, arregloUsernames #Contador que me indicará si ya comparé con todas las IP sospechosas
    
    addi $t9, $t9, 320 #Saco dir memoria donde se acaba el array
    
CondicionesUsm:

    la $t3, arregloUsernames #el parametro de funcion t3 es de donde saco la data
    
LoopCondicionesUsm:    
   
    la $t6, parametroUsm #el parámetro de funcion t6 es en donde voy a guardar la data
    
    jal sacarUnaIP #invoco la función que lee una casilla del arreglo TablaIPs

    beq $t3, $t9, exitLoopCondUsm
    
    la $s1, auxUsm
    
    la $s2, parametroUsm
    
    jal compararIP
    
    beq $s5, 0, LoopCondicionesUsm #la funcion booleana "retorna" un valor a s5, comparo y si es 0 significa que las IP no son iguales, entonces vuelvo a repetir el bucle
    
    la $s1, auxUsm
    
    jal mandarAlBufferW
    
exitLoopCondUsm:
    
    addi $s7, $s7, 1 #aumento en 1 el contador
    
    addi $s3, $s3, 32 #paso a la siguiente casilla
    
    jal loopTablaUsm
    
exitLoopTablaUsm:

grabarAlArchivo:
	li 	$v0,13
	la	$a0,archivoOutput
	li	$a1,1
	li	$a2,0
	syscall
	
	move	$t0,$v0
	
	li	$v0,15
	move	$a0,$t0
	la	$a1,bufferIPOut
	li	$a2,12799
	syscall
	
	li	$v0,16
	move	$a0,$t0
	syscall	 
	
#BUSQUEDA DE REGISTRO POR IP O USM

#Se imprime el menú, que es un string almacenado en la variable en memoria llamada mucho texto

loopBuscar:

	li 		$v0,4

	la 		$a0,muchotexto
	
	syscall

#SE LEE LA OPCIÓN

	li 		$v0,5

	syscall

	move	$t0,$v0
	
#SI LA OPCION ES DIFERENTE DE 1 Y DE 2 SE VUELVE A PEDIR OPCION
	
	beq $t0, 1, buscarIP
	
	beq $t0, 2, buscarUsm
	
        jal loopBuscar
	
buscarIP:

#MENSAJE PARA QUE EL USUARIO SEPA QUE DEBE DIGITAR EL DATO A BUSCAR

     	li 		$v0,4

	la 		$a0,mensajeIngrese
	
	syscall

#SE LEE LA INPUT DEL USUARIO

       li $v0, 8
       
       la $a0, auxIP #guardo en auxIP la IP a buscar
       
       li $a1, 31
       
       syscall
       
#SE PROCEDE A COMPARAR 

      la $t3, tablaIPs
      
      la $t5, tablaUsm
      
      la $s3, tablaFechas
     
      addi $t9, $t3, 6400 #maximo posible
      
loopBuscarPorIP:

      beq $t3, $t9, exitLoopBuscar
      
      la $t6, parametroIP
      
      jal sacarUnaIP
      
      la $s1, auxIP
      
      la $s2, parametroIP
      
      jal compararIP
      
      la $t7, bufferConsulta
      
      move $t2, $t5
      
      move $t6, $s3
      
      beq $s5, 1, imprimirIP
      
      jal exitImprimirIP
      
imprimirIP:
     
     la $s1, mensajeIP
     
     jal mandarAlBufferW
     
     la $s1, auxIP
     
     jal mandarAlBufferW
     
     la $s1, mensajeUsm
     
     jal mandarAlBufferW
     
     move $s1, $t2
     
     jal mandarAlBufferW
     
     la $s1, mensajeFecha
     
     jal mandarAlBufferW
     
     move $s1, $t6
     
     jal mandarAlBufferW
     
     	li 	$v0,13
	la	$a0,consultaOutput
	li	$a1,1
	li	$a2,0
	syscall
	
	move	$t0,$v0
	
	li	$v0,15
	move	$a0,$t0
	la	$a1,bufferConsulta
	li	$a2,399
	syscall
	
	li	$v0,16
	move	$a0,$t0
	syscall	 
     
     jal terminar
     
exitImprimirIP:

      
      move $t5, $t2
      
      move $s3, $t6

      addi $t5, $t5, 32
      
      addi $s3,$s3, 32

      jal loopBuscarPorIP

buscarUsm:


#MENSAJE PARA QUE EL USUARIO SEPA QUE DEBE DIGITAR EL DATO A BUSCAR

     	li 		$v0,4

	la 		$a0,mensajeIngrese
	
	syscall

#SE LEE LA INPUT DEL USUARIO

       li $v0, 8
       
       la $a0, auxUsm #guardo en auxIP la IP a buscar
       
       li $a1, 31
       
       syscall
       
#SE PROCEDE A COMPARAR 

      la $t5, tablaIPs
      
      la $t3, tablaUsm
      
      la $s3, tablaFechas
     
      addi $t9, $t3, 6400 #maximo posible
      
loopBuscarPorUsm:

      beq $t3, $t9, exitLoopBuscar
      
      la $t6, parametroUsm
      
      jal sacarUnaIP
      
      la $s1, auxUsm
      
      la $s2, parametroUsm
      
      jal compararIP
      
      la $t7, bufferConsulta
      
      move $t2, $t5
      
      move $t6, $s3
      
      beq $s5, 1, imprimirUsm
      
      jal exitImprimirUsm
      
imprimirUsm:
     
     la $s1, mensajeIP
     
     jal mandarAlBufferW
     
     move $s1, $t2
     
     jal mandarAlBufferW
     
     la $s1, mensajeUsm
     
     jal mandarAlBufferW
     
     la $s1, auxUsm
     
     jal mandarAlBufferW
     
     la $s1, mensajeFecha
     
     jal mandarAlBufferW
     
     move $s1, $t6
     
     jal mandarAlBufferW
     
     	li 	$v0,13
	la	$a0,consultaOutput
	li	$a1,1
	li	$a2,0
	syscall
	
	move	$t0,$v0
	
	li	$v0,15
	move	$a0,$t0
	la	$a1,bufferConsulta
	li	$a2,399
	syscall
	
	li	$v0,16
	move	$a0,$t0
	syscall	 
     
     jal terminar
     
exitImprimirUsm:

      
      move $t5, $t2
      
      move $s3, $t6

      addi $t5, $t5, 32
      
      addi $s3,$s3, 32

      jal loopBuscarPorUsm
	
exitLoopBuscar:

     	li 		$v0,4

	la 		$a0,mensajeNoEncontrado
	
	syscall

#TERMINACIÓN DEL PROGRAMA
terminar:

        li $v0, 10

        syscall




















