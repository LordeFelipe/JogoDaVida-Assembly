.data
matbyte1: .byte 	0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0
			0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1

matbyte2: .byte 	0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
color: .word 0xFF0000
not_color: .word 0x0
display: .word 0x3000
.text

main:
	la	s4,matbyte1	#s4 = endereço da primeira matriz de bytes
	la	s5,matbyte2	#s5 = endereço da segunda matriz de bytes
	lw	s6,display	#a3 = endereço do display
	lw	s2,color	#s2 = cor 
	lw	s1,not_color	#s1 = zero
	
#	li	a7,5		#Leitura da linha
#	ecall			
#	mv	t0,a0		
#	li	a7,5		#Leitura da coluna
#	ecall			
#	mv	t1,a0		
	
#	mv 	a2,s4		#a2 = copia do endereço da matriz de bytes
#	mv	a0,t0		#a0 = copia da linha
#	mv	a1,t1		#a1 = copia da coluna	
#	call	write	

#	li	a0,16
#	li	a1,16
#	mv	a2,s4
#	call	readm
	
	mv	a0,s4		#a0 = copia do endereço da matriz de bytes
	call 	plot_m

loop:	
	call	next_gen
	mv	a0,s4
	mv	a1,s5
	call	update_m
	mv	a0,s4
	call 	plot_m
	li	a7,32
	li	a0,500
	ecall
	j	loop
	
	li	a7,10
	ecall
	
#---------------Marca com zeros e uns a matriz---------------#
#a0 = copia da linha
#a1 = copia da coluna
#a2 = copia do endereço da matriz de bytes
write:				#Percorre coluna
	addi	a1,a1,-1	
	beqz	a1,write2
	addi	a2,a2,1		#Avança ponteiro da matriz
	j 	write

write2:				#Pecorre linha
	addi	a0,a0,-1
	beqz	a0,write_end
	li	a1,17
	j	write
	
write_end:
	li	t1,1		#Fazer um xor 
	sb	t1,0(a2)
	ret

#---------------Le o valor de um pixel---------------#
#a0 = copia da linha
#a1 = copia da coluna
#a2 = copia do endereço da matriz de bytes
#a3 = retorno do pixel
readm:
	li	t1,0
	li	t2,17
	bge	a0,t2,readm_error
	bge	a1,t2,readm_error
	ble	a0,t1,readm_error
	ble	a1,t1,readm_error
	j	readm1

readm_error:
	li	a3,0
	ret

readm1:
	addi	a1,a1,-1	
	beqz	a1,readm2
	addi	a2,a2,1		#Avança ponteiro da matriz
	j 	readm1

readm2:				#Pecorre linha
	addi	a0,a0,-1
	beqz	a0,readm_end
	li	a1,17
	j	readm1
	
readm_end:
	lb	a3,0(a2)	#Guarda o valor do pixel
	ret
	

#---------------Plota a matriz no bitmap-----------------#	
#a0 = copia do endereço da matriz de bytes
plot_m:
	li	a5,1		#a5 = contador de linhas				
	li	a6,1		#a6 = contador de colunas
	li	s9,17
	mv	a4,s6		#copia do display
plot_m1:
	beq	a6,s9,plot_m2
	addi	a4,a4,4		#anda o display
	lb	t0,0(a0)	#verifica o valor do pixel
	addi	a0,a0,1		#anda a matriz de bytes
	sw	s1,-4(a4)	#Descolorindo o pixel
	addi	a6,a6,1 
	beqz	t0,plot_m1
	sw	s2,-4(a4)	#Colorindo o pixel 
	j	plot_m1	
plot_m2:
	beq	a5,s9,plot_end
	li	a6,1
	addi	a5,a5,1
	j	plot_m1

plot_end:
	ret
	
#---------------Cria a próxima geração na matriz2-----------------#	
#a7 = contador de vizinhos
next_gen:
	li	a5,1		#a5 = contador de linhas				
	li	a6,1		#a6 = contador de colunas
	mv	a4,s4		#a4 = copia da matriz de bytes1
	mv	s8,s5		#s8 = copia da matriz de bytes2
	
next_gen2:				#Percorre coluna
	beq	a6,s9,next_gen3	#a6==17

	addi	sp,sp,-4
	sw	ra, 0(sp)		
	call 	live_or_die
	lw 	ra,0(sp)
	addi	sp,sp,4
	
	sb	a7,0(s8)	#a7 retorna se morreu ou não
	
	addi	a4,a4,1		#Avança ponteiro da matriz de bytes1
	addi	s8,s8,1		#Avança ponteiro da matriz de bytes2
	addi	a6,a6,1
	j 	next_gen2

next_gen3:			#Pecorre linha
	beq	a5,s9,next_gen_end	#a5==17
	addi	a5,a5,1
	li	a6,1
	j	next_gen2
	
next_gen_end:
	ret
#---------------Determina e a7 quem vive ou morre-----------------#	
#a5 = contador de linhas				
#a6 = contador de colunas
#a4 = copia da matriz de bytes1
#a3 = copia da matriz de bytes2
live_or_die:
	mv	a2,s4
	li	a7,0	#a7 = numero vivos
	
	addi	sp,sp,-4
	sw	ra, 0(sp)		
vizinho1:
	mv	a2,s4
	addi	a0,a5,-1
	addi	a1,a6,-1
	call 	readm
	beqz	a3,vizinho2
	addi	a7,a7,1

vizinho2:
	mv	a2,s4
	addi	a0,a5,-1
	addi	a1,a6,0
	call 	readm
	beqz	a3,vizinho3
	addi	a7,a7,1
vizinho3:
	mv	a2,s4
	addi	a0,a5,-1
	addi	a1,a6,1
	call 	readm
	beqz	a3,vizinho4
	addi	a7,a7,1
vizinho4:
	mv	a2,s4
	addi	a0,a5,0
	addi	a1,a6,-1
	call 	readm
	beqz	a3,vizinho5
	addi	a7,a7,1
vizinho5:
	mv	a2,s4
	addi	a0,a5,0
	addi	a1,a6,1
	call 	readm
	beqz	a3,vizinho6
	addi	a7,a7,1
vizinho6:
	mv	a2,s4
	addi	a0,a5,1
	addi	a1,a6,-1
	call 	readm
	beqz	a3,vizinho7
	addi	a7,a7,1
vizinho7:
	mv	a2,s4
	addi	a0,a5,1
	addi	a1,a6,0
	call 	readm
	beqz	a3,vizinho8
	addi	a7,a7,1
vizinho8:
	mv	a2,s4
	addi	a0,a5,1
	addi	a1,a6,1
	call 	readm
	beqz	a3,vizinho_end
	addi	a7,a7,1
	
vizinho_end:
	lw 	ra,0(sp)	
	addi	sp,sp,4
	li	t0,2
	li	t1,3
	beq	t0,a7,live
	beq	t1,a7,live
	li	a7,0
	ret
live:
	li	a7,1
	ret

#---------------Copia a matriz 2 para a 1-----------------#	
#a0 = copia do endereço da matriz de bytes1
#a1 = copia do endereço da matriz de bytes2
update_m:
	li	a5,1		#a5 = contador de linhas				
	li	a6,1		#a6 = contador de colunas
	li	s9,17
update_m1:
	beq	a6,s9,update_m2
	lb	t0,0(a1)
	sb	t0,0(a0)	
	addi	a0,a0,1		#anda a matriz de bytes
	addi	a1,a1,1
	addi	a6,a6,1 
	j	update_m1	
update_m2:
	beq	a5,s9,update_end
	li	a6,1
	addi	a5,a5,1
	j	update_m1

update_end:
	ret
