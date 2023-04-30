.data
   matrix: .space 40000
   coloana: .space 4
   linie: .space 4
   noduri: .space 4
   nrproblema: .space 4
   nrMuchii: .space 4
   vectornrmuchii: .space 400
   index: .space 4
   index2: .space 4
   left: .space 4
   right: .space 4
   formatScanf: .asciz "%ld"
   formatPrintf: .asciz "%ld "
   formatPrintf2: .asciz "%ld"
   newLine: .asciz "\n"
   k: .space 4
   m1: .space 40000
   m2: .space 40000
   mres: .space 40000
   nodsursa: .space 4
   noddestinatie: .space 4
.text
	matrix_mult:
		pushl %ebp
		movl %esp, %ebp
		subl $12,%esp
		movl $0, -4(%ebp)
		movl $0, -8(%ebp)
		movl $0, -12(%ebp)
		
		pushl %esi
		pushl %edi
		pushl %ebx
		
		for1:
		movl -4(%ebp),%eax
		cmp %eax, 20(%ebp)
		je final
			for2:
			movl -8(%ebp),%eax
			cmp %eax, 20(%ebp)
			je for1_modif
				for3:
				movl -12(%ebp),%eax
				cmp %eax, 20(%ebp)
				je for2_modif
				
				movl -4(%ebp), %eax
				movl $0, %edx
				mull 20(%ebp)
				addl -12(%ebp), %eax
				movl 8(%ebp), %edi
				movl (%edi, %eax, 4), %ebx
				
				movl -12(%ebp), %eax
				movl $0, %edx
				mull 20(%ebp)
				addl -8(%ebp), %eax
				movl 12(%ebp), %edi
				movl (%edi, %eax, 4), %ecx
				movl %ecx, %eax
				
				mull %ebx
				movl %eax, %ebx
				
				movl -4(%ebp), %eax
				movl $0, %edx
				mull 20(%ebp)
				addl -8(%ebp), %eax
				movl 16(%ebp), %edi
				movl (%edi, %eax, 4), %ecx
				
				addl %ecx, %ebx
				movl %ebx,(%edi,%eax,4)
				
				
				movl -12(%ebp),%eax
				addl $1,%eax
				movl %eax, -12(%ebp)
				jmp for3
		for2_modif:
		movl $0, -12(%ebp)
		movl -8(%ebp),%eax
		addl $1,%eax
		movl %eax, -8(%ebp)
		jmp for2
		
		for1_modif:
		movl $0, -8(%ebp)
		movl -4(%ebp), %eax
		addl $1, %eax
		movl %eax, -4(%ebp)
		jmp for1
		
		final:
		popl %ebx
		popl %edi
		popl %esi
		addl $12,%esp
		popl %ebp
		ret


.global main
   main:
   	pushl $nrproblema
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
      
	pushl $noduri
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	movl $0, index
	lea vectornrmuchii, %edi
   for_citire_nr_muchii:
   	movl index, %ecx
	cmp %ecx, noduri
	je formare_matrix
	
	push $nrMuchii
	push $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	movl nrMuchii, %ebx
	movl index, %ecx
	movl %ebx, (%edi,%ecx,4)
	incl index
	jmp for_citire_nr_muchii
	
   formare_matrix:
		movl $0, index2
		movl index2, %eax
		cmp %eax, noduri
		je alegere_problema
	   muchii:
		movl $0, index
	 	lea vectornrmuchii, %edi
	 	movl index2, %ecx
	 	movl (%edi,%ecx,4), %ebx
	 	movl %ebx, nrMuchii
	   pt_un_nod:
	   	movl nrMuchii, %ebx
	 	cmp index, %ebx
	 	je urmatorul_nod
	 	
	 	movl index2, %ecx
	 	movl %ecx, left
		pushl $right
		pushl $formatScanf
		call scanf
		popl %ebx
		popl %ebx

		movl left, %eax
		movl $0, %edx
		mull noduri
		addl right, %eax

		lea matrix, %edi
		movl $1, (%edi, %eax, 4)

		incl index
		jmp pt_un_nod
		
	   urmatorul_nod:
	   	incl index2
	   	movl index2, %ecx
	   	cmp noduri, %ecx
	   	je alegere_problema
	   	jmp muchii
	
   alegere_problema:
	movl nrproblema, %ecx
	cmp $2,%ecx
	je et_problema2
	
   et_problema1:
   et_afis_matr:
		movl $0, linie
	   for_linii:
		movl linie, %ecx
		cmp %ecx, noduri
		je et_exit
		movl $0, coloana
	   for_coloane:
		movl coloana, %ecx
		cmp %ecx, noduri
		je cont

		movl linie, %eax
		movl $0, %edx
		mull noduri
		addl coloana, %eax

		lea matrix, %edi
		movl (%edi, %eax, 4), %ebx
		
		pushl %ebx
		pushl $formatPrintf
		call printf
		popl %ebx
		popl %ebx
		
		pushl $0
		call fflush
		popl %ebx
		
		incl coloana
		jmp for_coloane
	   cont:
		pushl $newLine
		call printf
		popl %ebx
			
		pushl $0
		call fflush
		popl %ebx
		
		incl linie
		jmp for_linii
   et_problema2:
	pushl $k
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	movl $0, linie
	   for_linii_copiere:
		movl linie, %ecx
		cmp %ecx, noduri
		je continuare
		movl $0, coloana
	   for_coloane_copiere:
		movl coloana, %ecx
		cmp %ecx, noduri
		je cont_copiere

		movl linie, %eax
		movl $0, %edx
		mull noduri
		addl coloana, %eax

		lea matrix, %edi
		movl (%edi, %eax, 4), %ebx
		
		lea m1, %edi
		movl %ebx, (%edi, %eax, 4)
		
		lea m2, %edi
		movl %ebx, (%edi, %eax, 4)
		
		incl coloana
		jmp for_coloane_copiere
	   cont_copiere:
		incl linie
		jmp for_linii_copiere
	
	continuare:
		movl $1,index
		loop_de_k_ori:
			movl index, %ecx
			cmp %ecx, k
			je rezultat
			
			movl $0, linie
			   for_linii_copiere3:
				movl linie, %ecx
				cmp %ecx, noduri
				je here
				movl $0, coloana
			   for_coloane_copiere3:
				movl coloana, %ecx
				cmp %ecx, noduri
				je cont_copiere3

				movl linie, %eax
				movl $0, %edx
				mull noduri
				addl coloana, %eax

				lea mres, %edi
				movl $0,(%edi, %eax, 4)
				
				incl coloana
				jmp for_coloane_copiere3
			   cont_copiere3:
				incl linie
				jmp for_linii_copiere3
			here:
			
			movl noduri,%eax
			pushl %eax
			pushl $mres
			pushl $m2
			pushl $m1
			call matrix_mult
			popl %ebx
			popl %ebx
			popl %ebx
			popl %ebx
			
			movl $0, linie
			   for_linii_copiere2:
				movl linie, %ecx
				cmp %ecx, noduri
				je aici
				movl $0, coloana
			   for_coloane_copiere2:
				movl coloana, %ecx
				cmp %ecx, noduri
				je cont_copiere2

				movl linie, %eax
				movl $0, %edx
				mull noduri
				addl coloana, %eax

				lea mres, %edi
				movl (%edi, %eax, 4), %ebx
				
				lea m1, %edi
				movl %ebx, (%edi, %eax, 4)
				
				incl coloana
				jmp for_coloane_copiere2
			   cont_copiere2:
				incl linie
				jmp for_linii_copiere2
			
			aici:
			
			incl index
			jmp loop_de_k_ori
	rezultat:
	pushl $nodsursa
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	pushl $noddestinatie
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	movl nodsursa, %eax
	movl $0, %edx
	mull noduri
	addl noddestinatie, %eax
	lea mres, %edi
	movl (%edi, %eax, 4), %ebx
	
	pushl %ebx
	pushl $formatPrintf2
	call printf
	popl %ebx
	popl %ebx
		
	pushl $0
	call fflush
	popl %ebx
		
   et_exit:
	movl $1, %eax
	movl $0, %ebx
	int $0x80