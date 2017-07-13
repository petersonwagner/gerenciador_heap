.section .data
	INICIO_HEAP: 	.quad 0
	FIM_HEAP:	 	.quad 0
	LISTA_LIVRES:	.quad 0
	LISTA_OCUPADOS: .quad 0


STR_LIVRE: .string "-"
STR_OCUPADO: .string "+"
STR_METADATA: .string "###"
STR_SEPARADOR: .string "\n\n\n_____________________________\n\n\n"

#teste
	a: .quad 0
	b: .quad 0
	c: .quad 0
	d: .quad 0

	#macros para alocaMem
	.equ new_block_split,	%r10
	.equ best_fit_size,		%r11
	.equ num_bytes,			%r12
	.equ i, 				%r13
	.equ bestfit, 			%r14
	.equ bloco_anterior, 	%r15

	#macros para liberaMem
	.equ proximo_bloco,		%r11
	.equ j,					%r12
	.equ bloco,				%r14
	.equ bloco_anterior,	%r15
	

	#constantes
	.equ OCUPADO, 			1
	.equ LIVRE, 			0

.section .text
.globl iniciaAlocador
.globl finalizaAlocador
.globl liberaMem
.globl alocaMem
.globl imprime
.globl teste

	teste:
		pushq %rbp
		movq %rsp, %rbp

		call iniciaAlocador

		movq $100, %rdi
		call alocaMem
		movq %rax, a

		call imprime

		movq $200, %rdi
		call alocaMem
		movq %rax, b

		call imprime

		movq $300, %rdi
		call alocaMem
		movq %rax, c

		call imprime

		movq $400, %rdi
		call alocaMem
		movq %rax, d

		call imprime

		movq b, %rdi
		call liberaMem

		call imprime

		movq $50, %rdi
		call alocaMem
		movq %rax, b

		call imprime

		movq c, %rdi
		call liberaMem

		call imprime

		movq a, %rdi
		call liberaMem

		call imprime

		movq b, %rdi
		call liberaMem

		call imprime

		movq d, %rdi
		call liberaMem

		call imprime

		popq %rbp
		ret



	# imprime heap
	imprime: 
		pushq %rbp
		movq %rsp, %rbp

		pushq %rax
		pushq %rbx
		pushq %rcx
		pushq %rdx
		pushq %rsi
		pushq %rdi
		pushq %r8
		pushq %r9
		pushq %r10
		pushq %r11
		pushq %r12
		pushq %r13
		pushq %r14
		pushq %r15

		movq $0, %rax
		movq $STR_SEPARADOR, %rdi
		call printf

		popq %r15
		popq %r14
		popq %r13
		popq %r12
		popq %r11
		popq %r10
		popq %r9
		popq %r8
		popq %rdi
		popq %rsi
		popq %rdx
		popq %rcx
		popq %rbx
		popq %rax

		movq INICIO_HEAP, i

		loop6:
		movq FIM_HEAP, %rax
		subq $24, %rax
		cmpq i, %rax
		jle fimloop6
			

		pushq %rax
		pushq %rbx
		pushq %rcx
		pushq %rdx
		pushq %rsi
		pushq %rdi
		pushq %r8
		pushq %r9
		pushq %r10
		pushq %r11
		pushq %r12
		pushq %r13
		pushq %r14
		pushq %r15

		movq $0, %rax
		movq $STR_METADATA, %rdi
		call printf

		popq %r15
		popq %r14
		popq %r13
		popq %r12
		popq %r11
		popq %r10
		popq %r9
		popq %r8
		popq %rdi
		popq %rsi
		popq %rdx
		popq %rcx
		popq %rbx
		popq %rax

		cmpq $LIVRE, (i)
		jne else
			movq $STR_LIVRE, %rdi
			jmp fim_if6
		else:
			movq $STR_OCUPADO, %rdi
		fim_if6:

		addq $16, i



		movq $0, j
		for:
		cmpq j, (i)
		jle fim_for

			pushq %rax
			pushq %rbx
			pushq %rcx
			pushq %rdx
			pushq %rsi
			pushq %rdi
			pushq %r8
			pushq %r9
			pushq %r10
			pushq %r11
			pushq %r12
			pushq %r13
			pushq %r14
			pushq %r15

			movq $0, %rax
			call printf

			popq %r15
			popq %r14
			popq %r13
			popq %r12
			popq %r11
			popq %r10
			popq %r9
			popq %r8
			popq %rdi
			popq %rsi
			popq %rdx
			popq %rcx
			popq %rbx
			popq %rax

			addq $1, j
			jmp for
		fim_for:

		addq (i), i
		addq $8, i

		jmp loop6

	fimloop6:

	pop %rbp
	ret


	#proximo_bloco,		%r11
	#j,					%r12
	#i, 				%r13
	#bloco, 			%r14
	#bloco_anterior, 	%r15

	liberaMem:
		pushq %rbp
		movq %rsp, %rbp

		pushq %rbx
		pushq %r15
		pushq %r14
		pushq %r13
		pushq %r12
		

		movq %rdi, bloco

		movq bloco, %rax
		subq $24, %rax
		movq $LIVRE, (%rax)


		#deleta bloco da LISTA_OCUPADOS
		movq $0, bloco_anterior
		movq LISTA_OCUPADOS, i

		loop3:
			cmpq i, bloco
			je fimloop3

			cmpq $0, i
			je fimloop3
				movq i, bloco_anterior
				movq i, %rax
				subq $16, %rax
				movq (%rax), i
				jmp loop3
		fimloop3:

		#se nao for primeiro bloco da lista
		cmpq $0, bloco_anterior
		je first_block2
			movq bloco, %rax
			subq $16, %rax
			movq bloco_anterior, %rbx
			subq $16, %rbx
			movq (%rax), %rcx
			movq %rcx, (%rbx)   		#blocoanterior.next = bloco.next
			jmp fim_if_first_block2

		#se for primeiro bloco da lista
		first_block2:
			movq bloco, %rax
			subq $16, %rax
			movq (%rax), %rcx
			movq %rcx, LISTA_OCUPADOS  	#LISTA_OCUPADO = bloco.next;
		fim_if_first_block2:


		#inserir na LISTA_LIVRES
		movq bloco, %rax
		subq $16, %rax
		movq LISTA_LIVRES, %rbx
		movq %rbx, (%rax)
		movq bloco, LISTA_LIVRES


		#unir nos-livres
		movq INICIO_HEAP, i

		loop4:
		movq i, %rax
		addq $16, %rax
		addq (%rax), %rax				#rax = i+16 + *(i+16)
		addq $8, %rax					#rax = i+24 + *(i+16)
		cmpq %rax, FIM_HEAP				#while((i+24 + *(i+24)) < FIM_HEAP)
		jle fim_loop4
			movq %rax, proximo_bloco

			cmpq $LIVRE, (proximo_bloco)	#if (*i == LIVRE)
			jne else4

			cmpq $LIVRE, (i)				#if (*proximo_bloco == LIVRE)
			jne else4

			movq i, %rax
			addq $16, %rax
			movq proximo_bloco, %rbx
			addq $16, %rbx
			movq (%rbx), %rcx
			addq %rcx, (%rax)
			addq $24, (%rax)				#*(i+16) += 24 + *(proximo_bloco+16);


				
				####################################
				addq $24, proximo_bloco
				#remove proximo_bloco da LISTA_LIVRES
				movq $0, bloco_anterior
				movq LISTA_LIVRES, j
				loop5:
					cmpq j, proximo_bloco
					je fimloop5

					cmpq $0, j
					je fimloop5
						movq j, bloco_anterior
						movq j, %rax
						subq $16, %rax
						movq (%rax), j
					jmp loop5
				fimloop5:

				cmpq $0, bloco_anterior
				je first_block3
					movq proximo_bloco, %rax
					subq $16, %rax
					movq bloco_anterior, %rbx
					subq $16, %rbx
					movq (%rax), %rcx
					movq %rcx, (%rbx)   		#blocoanterior.next = proximo_bloco.next
					jmp fim_if_first_block3

				first_block3:
					movq proximo_bloco, %rax
					subq $16, %rax
					movq (%rax), %rcx
					movq %rcx, LISTA_LIVRES  	#LISTA_LIVRES = proximo_bloco.next;
				fim_if_first_block3:
				####################################

			jmp loop4				

			else4:
			movq proximo_bloco, i
			jmp loop4
		fim_loop4:

		pulatudo:


		popq %r12
		popq %r13
		popq %r14
		popq %r15
		popq %rbx


		popq %rbp
		ret


	#new_block_split,	%r10
	#best_fit_size,		%r11
	#num_bytes,			%r12
	#i, 				%r13
	#bestfit, 			%r14
	#bloco_anterior, 	%r15

	alocaMem:
		pushq %rbp
		movq %rsp, %rbp


		pushq %rbx
		pushq %r15
		pushq %r14
		pushq %r13
		pushq %r12

		#inicializacao de variaveis		
		movq %rdi, num_bytes						#parametro num_bytes

		movq LISTA_LIVRES, i 						#int *i = LISTA_LIVRES;
		movq $9223372036854775807, best_fit_size	#int best_fit_value = 9223372036854775807;
		movq $0, bestfit							#int *BESTFIT = NULL;
		movq $0, bloco_anterior 					#int *bloco_anterior = NULL;


		cmpq $0, LISTA_LIVRES						#if (LISTA_LIVRES == NULL)
			je alocar_blocao
		

		loop:
			movq i, %rax
			subq $8, %rax

			cmpq (%rax), num_bytes					#if (num_bytes > *(i-8))
				jg fimif1

			cmpq (%rax), best_fit_size				#if (best_fit_size <= *(i-8))
				jle fimif1


			movq (%rax), best_fit_size

			movq i, bestfit

			fimif1:

			movq i, %rax
			subq $16, %rax
			cmpq $0, (%rax)
				je fimloop


			movq (%rax), i
			jmp loop

		fimloop:

		cmpq $0, bestfit
			jne fim_alocar_blocao


		alocar_blocao:
			movq FIM_HEAP, %rax
			addq $24, %rax
			addq %rax, bestfit

			#TROCAR
				#104
			#POR
				#4096

			movq num_bytes, %rax
			addq $24, %rax
			movq $4096, %rbx
			movq $0, %rdx
			idiv %rbx
			addq $1, %rax
			imul $4096, %rax
			addq %rax, FIM_HEAP			# FIM_HEAP += (((num_bytes+24) div 4096)+1) * 4096;

			movq $12, %rax
			movq FIM_HEAP, %rdi
			syscall

			subq bestfit, %rax
			movq bestfit, %rbx
			subq $8, %rbx
			movq %rax, (%rbx)	    	# *(bestfit-8) = FIM_HEAP - bestfit;


			#ALTERACOES
			movq bestfit, %rax
			subq $24, %rax
			movq $OCUPADO, (%rax)			#*(BESTFIT-24) = OCUPADO;

			jmp split
		fim_alocar_blocao:

		movq bestfit, %rax
		subq $24, %rax
		movq $OCUPADO, (%rax)			#*(BESTFIT-24) = OCUPADO;	
	

		cmpq $0, LISTA_LIVRES
		je fim_if_first_block


		#remove bestfit da LISTA_LIVRES
		movq $0, bloco_anterior
		movq LISTA_LIVRES, i
		loop2:
			cmpq i, bestfit
			je fimloop2
				movq i, bloco_anterior
				movq i, %rax
				subq $16, %rax
				movq (%rax), i
			jmp loop2
		fimloop2:

		cmpq $0, bloco_anterior
		je first_block
			movq bestfit, %rax
			subq $16, %rax
			movq bloco_anterior, %rbx
			subq $16, %rbx
			movq (%rax), %rcx
			movq %rcx, (%rbx)   		#blocoanterior.next = bestfit.next
			jmp fim_if_first_block

		first_block:
			movq bestfit, %rax
			subq $16, %rax
			movq (%rax), %rcx
			movq %rcx, LISTA_LIVRES  	#LISTA_LIVRES = Bestfit.next;
		fim_if_first_block:


		split:
		movq bestfit, %rax
		subq $8, %rax
		movq num_bytes, %rbx
		addq $32, %rbx

		if_split:
		cmpq %rbx, (%rax)					# if (*(BESTFIT-8) <= num_bytes+32)
			jle fim_if_split

			movq num_bytes, %rbx
			addq bestfit, %rbx
			addq $24, %rbx
			movq %rbx, new_block_split 		# int newblock = BESTFIT + num_bytes + 24;

			movq new_block_split, %rbx
			subq $24, %rbx
			movq $LIVRE, (%rbx)				# *(newblock-24) = LIVRE;

			movq bestfit, %rcx
			subq $8, %rcx
			movq (%rcx), %rax				# rax = *(bestfit-8)
			subq num_bytes, %rax
			subq $24, %rax					# rax = *(bestfit-8) - num_bytes - 24
			movq new_block_split, %rbx
			subq $8, %rbx
			movq %rax, (%rbx)				# *(newblock-8)  = *(bestfit-8) - num_bytes - 24;


			movq bestfit, %rax
			subq $8, %rax
			movq num_bytes, (%rax)			# *(BESTFIT-8) = num_bytes;

			#coloca newblock na lista livres
			movq new_block_split, %rax
			subq $16, %rax
			movq LISTA_LIVRES, %rbx
			movq %rbx, (%rax)				#*(newblock-16) = LISTA_LIVRES;

			movq new_block_split, %rax
			movq %rax, LISTA_LIVRES
		fim_if_split:


		#insere na lista_ocupados
		movq bestfit, %rax
		subq $16, %rax
		movq LISTA_OCUPADOS, %rcx
		movq %rcx, (%rax)

		movq bestfit, LISTA_OCUPADOS

		#DEBUG
				movq INICIO_HEAP, %rbx
				movq %rbx, (%rsi)
		#DEBUG

		movq bestfit, %rax

		popq %r12
		popq %r13
		popq %r14
		popq %r15
		popq %rbx

		popq %rbp
		ret


	iniciaAlocador:
		pushq %rbp
		movq %rsp, %rbp

		movq $12, %rax
		movq $0,  %rdi
		syscall
		movq %rax, INICIO_HEAP
		movq %rax, FIM_HEAP

		popq %rbp
		ret

	finalizaAlocador:
		pushq %rbp
		movq %rsp, %rbp

		movq $12, %rax
		movq INICIO_HEAP, %rdi
		syscall

		movq INICIO_HEAP, %rax
		movq %rax, FIM_HEAP

		movq $0, LISTA_LIVRES
		movq $0, LISTA_OCUPADOS

		popq %rbp
		ret
		