includelib		kernel32.lib
includelib		user32.lib
includelib		bcrypt.lib
includelib		advapi32.lib

extern		GetStdHandle:PROC
extern		WriteConsoleA:PROC
extern		ReadConsoleA:PROC
extern		CreateFileA:PROC
extern		ReadFile:PROC
extern		GetLastError:PROC
extern		SetLastError:PROC
extern		CloseHandle:PROC
extern		SetFilePointer:PROC
extern		BCryptOpenAlgorithmProvider:PROC
extern		BCryptCreateHash:PROC
extern		BCryptHashData:PROC
extern		BCryptFinishHash:PROC
extern		BCryptDestroyHash:PROC
extern		BCryptCloseAlgorithmProvider:PROC




.CODE
MAIN	PROC
	
	mov		rax,  QWORD PTR[rsp]
	mov		QWORD PTR[rsp + 10h], rax
	sub		rsp, 16
	mov		QWORD PTR[rsp], 222
	mov		QWORD PTR[rsp], 000
	add		rsp, 16
	add		rsp, 8

	
	sub		rsp, 900h

	mov		QWORD PTR[rsp], 1222
	mov		QWORD PTR[rsp], 0000
	
	mov		rcx, 0
	call	SetLastError
	
	
	;100-150h for handles(hOut, hIn, hFile, hAlg, hHash),160-170h hex table,170h 'Error:0x', buffers
	;================================================================================================
	pxor	xmm0, xmm0
	pxor	xmm1, xmm1
	pxor	xmm2, xmm2
	pxor	xmm3, xmm3
	pxor	xmm4, xmm4
	
	movdqa	XMMWORD PTR[rsp + 100h], xmm0
	movdqa	XMMWORD PTR[rsp + 110h], xmm1
	movdqa	XMMWORD PTR[rsp + 120h], xmm2
	movdqa	XMMWORD PTR[rsp + 130h], xmm3
	movdqa	XMMWORD PTR[rsp + 140h], xmm4
	movdqa	XMMWORD PTR[rsp + 150h], xmm0
	
	movdqa	XMMWORD PTR[rsp + 190h], xmm1
	movdqa	XMMWORD PTR[rsp + 1a0h], xmm2
	movdqa	XMMWORD PTR[rsp + 1b0h], xmm3
	movdqa	XMMWORD PTR[rsp + 1c0h], xmm4
	movdqa	XMMWORD PTR[rsp + 1d0h], xmm0
	movdqa	XMMWORD PTR[rsp + 1e0h], xmm1
	movdqa	XMMWORD PTR[rsp + 1f0h], xmm2
	movdqa	XMMWORD PTR[rsp + 200h], xmm3
	movdqa	XMMWORD PTR[rsp + 210h], xmm4
	
	movdqa	XMMWORD PTR[rsp + 700h], xmm0
	movdqa	XMMWORD PTR[rsp + 710h], xmm1
	movdqa	XMMWORD PTR[rsp + 720h], xmm2
	movdqa	XMMWORD PTR[rsp + 730h], xmm3

	
	mov		rcx, -11
	call	GetStdHandle
	mov		QWORD PTR[rsp + 100h], rax
	
	mov		rcx, -10
	call	GetStdHandle
	mov		QWORD PTR[rsp + 108h], rax
	
	mov		r11, 'x0:rorrE'
	mov		QWORD PTR[rsp + 730h], r11
	
	
	;mov, print 'Enter path to the file: ', DWORD @[rsp + 18ch] for &read, 
	;================================================================================================
	
	mov		r13, 'ap retnE'
	mov		QWORD PTR[rsp + 178h], r13
	mov		r14, 'if ot ht'
	mov		QWORD PTR[rsp + 180h], r14
	mov		DWORD PTR[rsp + 188h], ' :el'
	
	
	
	mov		rcx, [rsp + 100h]
	lea		rdx, [rsp + 178h]
	mov		r8,  24h
	mov		r9,  0
	mov		QWORD PTR[rsp + 32], 0
	call	WriteConsoleA
	
	
	
	;get input (80h), store @[rsp + 190h] parse user input, &read @ [rsp + 18ch], error @[rsp + 220h]
	;================================================================================================
	
	mov		rcx, [rsp + 108h]
	lea		rdx, [rsp + 190h]
	mov		r8,  80h
	lea		r9,  [rsp + 18ch]
	mov		QWORD PTR[rsp + 32], 0
	call	ReadConsoleA
	
	mov		eax, DWORD PTR[rsp + 18ch]
	test	eax, eax
	jz		RCAF
	jmp		parseUI
		
		RCAF:
			mov		r15, 'noCdaeR'
			mov		r11, 'h Aelos'
			mov		r9,  'liaF as'
			mov		rdi, 000000000a2e6465h
			xor		rdx, rdx
			xor		r13, r13
			jmp	errorLoop
		
		parseUI:
			add		rsp, rax
			add		rsp, 190h
			xor		r13, r13
				findCtrlChar:
					cmp		BYTE PTR[rsp], 32
					jg		replaceCtrlChar
					sub		rsp, 1
					add		r13, 1
					jmp		findCtrlChar
					
						replaceCtrlChar:
							mov		BYTE PTR[rsp + 1], 0
							add		rsp, r13
							sub		rsp, rax
							sub		rsp, 190h
							
	;================================================================================================
	
	;check if file exists, error strings, mov handle [rsp + 110h]
	;================================================================================================
	
	lea		rcx, [rsp + 190h]
	mov		rdx, 80000000h
	mov		r8,  1
	mov		r9,  0
	mov		DWORD PTR[rsp + 32], 3
	mov		DWORD PTR[rsp + 36], 128
	mov		DWORD PTR[rsp + 40], 0
	call	CreateFileA
	
	cmp		rax, 0ffffffffffffffffh
	je		CFF
	mov		QWORD PTR[rsp + 110h], rax
	jmp		read64
		CFF:
			
			mov		r15, 'iFetaerC'
			mov		r11, 'eliaF el'
			mov		r9,  00000000000a64h
			xor		rdi, rdi
			xor		rdx, rdx
			xor		r13, r13
			jmp		errorLoop
	
	;read first 64 bytes of file, ensure MZ is first word, &read @ [rsp + 18ch]
	;================================================================================================
		read64:
			mov rcx, [rsp + 110h] 
			lea rdx, [rsp + 190h] 
			mov r8,  64 
			lea r9,  [rsp + 18ch] 
			mov QWORD PTR[rsp + 32], 0 
			call ReadFile 
			
			test	rax, rax
			jnz		checkMZ
			jmp		RFF
			
				RFF:	
					mov		r15, 'deaReliF'
					mov		r11, 'deliaF'
					mov		rdx, 0affffffffffffffh
					or		r11, rdx 
					xor		r9,  r9
					xor		rdi, rdi
					xor		rdx, rdx
					jmp		errorLoop
				
				checkMZ:
					cmp		WORD PTR[rsp + 190h], 'ZM'
					jne		noMZ
					jmp		cDOS
					
						
						noMZ:
							mov		r15, ' si eliF'
							mov		r11, 'cexe ton'
							mov		r9,  'elbatu'
							mov		rdx, 0affffffffffffffh
							or		r9,  rdx
							xor		rdi, rdi
							xor		rdx, rdx
							jmp		pexit
				
	
	;mov strings onto stack, convert hex, merge into one array			
	;================================================================================================
		cDOS:
			
			lea		rdx, [rsp + 1e0h] ;name
				
				pxor	xmm0, xmm0
				mov		r13, 20h
				clearLoop:
					movdqa		XMMWORD PTR[rdx], xmm0
					add		rdx, 10h
					sub		r13, 1
					test	r13, r13
					jnz		clearLoop
					
					
			sub		rdx, 200h
			
			
			mov		DWORD PTR[rdx       ], ': ZM'
			mov		DWORD PTR[rdx + 0ch ], ':PLB'
			mov		DWORD PTR[rdx + 18h ], ':FIP'
			mov		DWORD PTR[rdx + 24h ], ':CLR'
			mov		DWORD PTR[rdx + 30h ], ':RDH'
			mov		DWORD PTR[rdx + 3ch ], ':NIM'
			mov		DWORD PTR[rdx + 48h ], ':XAM'
			mov		DWORD PTR[rdx + 54h ], ':SSI'
			mov		DWORD PTR[rdx + 60h ], ':PSI'
			mov		DWORD PTR[rdx + 6ch ], ':KHC'
			mov		DWORD PTR[rdx + 78h ], ':PII'
			mov		DWORD PTR[rdx + 84h ], ':SCI'
			mov		DWORD PTR[rdx + 90h ], ':TRA'
			mov		DWORD PTR[rdx + 9ch ], ':RVO'
			mov		DWORD PTR[rdx + 0a8h], ':SER'
			mov		DWORD PTR[rdx + 0b4h], ':SER'
			mov		DWORD PTR[rdx + 0c0h], ':SER'
			mov		DWORD PTR[rdx + 0cch], ':SER'
			mov		DWORD PTR[rdx + 0d8h], ':DIO'
			mov		DWORD PTR[rdx + 0e4h], ':NIO'
			mov		DWORD PTR[rdx + 0f0h], ':SER'
			mov		DWORD PTR[rdx + 0fch], ':SER'
			mov		DWORD PTR[rdx + 108h], ':SER'
			mov		DWORD PTR[rdx + 114h], ':SER'
			mov		DWORD PTR[rdx + 120h], ':SER'
			mov		DWORD PTR[rdx + 12ch], ':SER'
			mov		DWORD PTR[rdx + 138h], ':SER'
			mov		DWORD PTR[rdx + 144h], ':SER'
			mov		DWORD PTR[rdx + 150h], ':SER'
			mov		DWORD PTR[rdx + 15ch], ':SER'
			mov		DWORD PTR[rdx + 168h], ':FFO'
			
			add		rdx, 4
			lea		rcx, [rsp + 190h]
			
			mov		rdi, 0f0f0f0f0f0f0f0fh ;low nibble
			movq	xmm7, rdi
			mov		rsi, 0f0f0f0f0f0f0f0f0h ;high nibble
			movq	xmm8, rsi
			mov		r11, 3030303030303030h ;ascii 0
			movq	xmm9, r11
			mov		r12, 0909090909090909h ;9
			movq	xmm10, r12
			mov		r14, 0f8f8f8f8f8f8f8f8h
			movq	xmm11, r14
			
			mov		r11, 8
			mov		r13, rdx
			add		r13, 18h
				
				hDOS:
					
					movq	xmm0, QWORD PTR[rcx]
					movq	xmm1, xmm7
					movq	xmm2, xmm8
					
					pand	xmm1, xmm0
					pand	xmm2, xmm0
					
					psrlw	xmm2, 4
					
					movq	xmm3, xmm1
					movq	xmm4, xmm2
					
					pcmpgtb	xmm3, xmm10
					pcmpgtb	xmm4, xmm10
					
					psubusb	xmm3, xmm11
					psubusb	xmm4, xmm11
					
					paddb	xmm1, xmm3
					paddb	xmm2, xmm4
					
					paddb	xmm1, xmm9
					paddb	xmm2, xmm9
					
					punpcklbw	xmm1, xmm2
					
					movq	rax, xmm1
					
					movhlps	xmm1, xmm1
					movq	r14, xmm1
					
					mov		rdi, 0ffffffff00000000h
					mov		rsi, 0ffffffff00000000h
					
					and		rdi, rax
					bswap	rdi
					and		rsi, r14
					bswap	rsi
					
					
					shl		rdi, 32
					bswap	eax
					shl		rsi, 32
					bswap	r14d
					
					mov		r12, 00000000ffffffffh
					and		rax, r12
					and		r14, r12
					or		rax, rdi
					or		r14, rsi
					
					mov		DWORD PTR[rdx], eax
					mov		 BYTE PTR[rdx + 4], 10
					add		rdx, 0ch
					shr		rax, 32
					
					mov		DWORD PTR[r13], r14d
					mov		 BYTE PTR[r13 + 4], 10
					add		r13, 0ch
					shr		r14, 32
					
					mov		DWORD PTR[rdx], eax
					mov		 BYTE PTR[rdx + 4], 10
					add		rdx, 24h
					
					mov		DWORD PTR[r13], r14d
					mov		 BYTE PTR[r13 + 4], 10
					add		r13, 24h
					

					
					add		rcx, 8
					sub		r11, 1
					test	r11, r11
					jnz		hDOS
					
			

					
					
		
				
				
				
						
						
	;print DOS header				
	;================================================================================================
	
	mov		eax, DWORD PTR[rsp + 1cch]
			bswap	eax
		
		mov		r14, 0f0f0f0fh ;low nibble
		mov		r15, 0f0f00f0fh ;high nibble
		mov		r8,  30303030h ;'0'
		mov		r11, 09090909h ;9
		mov		r12, 0f8f8f8f8h
		
			
			movd		xmm0, eax
			movd		xmm1, r14
			movd		xmm2, r15
			
			pand		xmm1, xmm0
			pand		xmm2, xmm0
			
			psrlw		xmm2, 4
			
			movd		xmm3, r11
			
			movdqa		xmm7, xmm1
			movdqa		xmm8, xmm2
			
			pcmpgtb		xmm7, xmm3
			pcmpgtb		xmm8, xmm3
			
			movd		xmm5, r12
			
			psubusb		xmm7, xmm5
			psubusb		xmm8, xmm5
			
			paddb		xmm1, xmm7
			paddb		xmm2, xmm8
			
			movd		xmm6, r8
			
			paddb		xmm1, xmm6
			paddb		xmm2, xmm6
			
			punpcklbw	xmm2, xmm1
			
			movq		QWORD PTR[rsp + 34ch], xmm2
	
	
	
					
	
	mov		rcx, [rsp + 100h]
	lea		rdx, [rsp + 1e0h]
	mov		r8,  175h
	mov		r9,  0
	mov		QWORD PTR[rsp + 32], 0
	call	WriteConsoleA
	
	
	;================================================================================================
	
	;set up hashing, hAlg @ [rsp + 118h], hHash @ [rsp + 120h], clear 326 bytes @ [rsp + 260h], hash
	;================================================================================================
	
	mov		r12, 0032004100480053h
	mov		eax, 00360035h
	
	mov		QWORD PTR[rsp + 1e0h], r12
	mov		DWORD PTR[rsp + 1e8h], eax
	mov		 WORD PTR[rsp + 1ech], 0
	;Microsoft Primitive Provider
	;mov		r13, 0050005f0053004dh 
	;mov		r14, 0049004d00490052h
	;mov		r15, 0045005600490054h
	;mov		rdx, 004f00520050005fh
	;mov		rsi, 0045004400490056h
	;mov		rdi, 0000000000000052h
	
	mov		r13, 007200630069004dh
	mov		r14, 0066006f0073006fh
	mov		r15, 0072005000200074h
	mov		rdx, 00740069006d0069h
	mov		rsi, 0020006500760069h
	mov		rdi, 0076006f00720050h
	mov		rax, 0072006500640069h
	xor		r11, r11
	
	mov		QWORD PTR[rsp + 1f0h], r13
	mov		QWORD PTR[rsp + 1f8h], r14
	mov		QWORD PTR[rsp + 200h], r15
	mov		QWORD PTR[rsp + 208h], rdx
	mov		QWORD PTR[rsp + 210h], rsi
	mov		QWORD PTR[rsp + 218h], rdi
	mov		QWORD PTR[rsp + 220h], rax
	mov		DWORD PTR[rsp + 228h], r11d
	
	lea		rcx, [rsp + 118h]
	lea		rdx, [rsp + 1e0h]
	lea		r8,  [rsp + 1f0h]
	mov		r9,  20h
	call	BCryptOpenAlgorithmProvider
	
	test	eax, eax
	
	jnz		BCOAPF
	jmp		BCCH
		
		BCOAPF:
			
			mov		r15, 4f7470797243420ah
			mov		r11, 'roglAnep'
			mov		r9,  'vorPmhti'
			mov		rdi, 'iaf redi'
			mov		rdx, 0000a6465636ch
			xor		r13, r13
			
			jmp		NTSTATUSErrorLoop
	
	BCCH:
		
		pxor	xmm0, xmm0
		lea		r12, [rsp + 260h]
		mov		r13, 14h
			clearBuf:
				movdqa	XMMWORD PTR[r12], xmm0
				
				add		r12, 10h
				sub		r13, 1
				test	r13, r13
				jnz		clearBuf
		
		mov		QWORD PTR[r12], 0
		
		mov		rcx, [rsp + 118h]
		lea		rdx, [rsp + 120h]
		lea		r8,  [rsp + 260h]
		mov		r9,  146h
		mov		QWORD PTR[rsp + 32], 0
		mov		QWORD PTR[rsp + 40], 0
		mov		QWORD PTR[rsp + 48], 20h
		call	BCryptCreateHash
		
		test	rax, rax
		jnz		BCCHF
		jmp		BCHD	
			BCCHF:	
				
				mov		r15, 437470797243420ah
				mov		r11, 'saHetaer'
				mov		r9,  'deliaf h'
				mov		rdi, 0000000ah
				xor		rdx, rdx
				xor		r13, r13
				jmp		NTSTATUSErrorLoop
	
	
		BCHD:
			
			mov		rcx, [rsp + 120h]
			lea		rdx, [rsp + 190h]
			mov		r8,  40h
			mov		r9,  0
			call	BCryptHashData
			
			test	eax, eax
			jnz		BCHDF
			jmp		BCFH
				BCHDF:
					mov		r15, 487470797243420ah
					mov		r11, ' ataDhsa'
					mov		r9,  0a64656c696166h
					xor		rdi, rdi
					xor		rdx, rdx
					xor		r13, r13
					
					jmp		NTSTATUSErrorLoop
			
		BCFH:
			
			mov		rcx, [rsp + 120h]
			lea		rdx, [rsp + 190h]
			mov		r8,  32
			mov		r9,  0
			call	BCryptFinishHash
				
			test	eax, eax
			jnz		BCFHF
			jmp		cDOSHASH
				BCFHF:
					
					mov		r15, 467470797243420ah
					mov		r11, 'asHhsini'
					mov		r9,  0a64656c69616620h
					xor		rdi, rdi
					xor		rdx, rdx
					xor		r13, r13
					
					jmp		NTSTATUSErrorLoop
			
		;hash DOS header
		;================================================================================================
		cDOSHASH:
			lea		rcx, [rsp + 190h]
			lea		rdx, [rsp + 1b0h]
			lea		r15, [rsp + 1b8h]
			mov		r8,  4
			
			mov		rsi, 0f0f0f0f0f0f0f0fh
			movq	xmm6, rsi
			mov		rdi, 0f0f0f0f0f0f0f0f0h
			movq	xmm7, rdi
			mov		r11, 3030303030303030h
			movq	xmm8, r11
			mov		r12, 0909090909090909h
			movq	xmm9, r12
			mov		r13, 0f8f8f8f8f8f8f8f8h
			movq	xmm10, r13
							
				hHASH:
					
					movq	xmm0, QWORD PTR[rcx]
					movq	xmm1, xmm6
					movq	xmm2, xmm7
					
					pand	xmm1, xmm0
					pand	xmm2, xmm0
					
					psrlw	xmm2, 4
					
					movq	xmm3, xmm1
					movq	xmm4, xmm2
					
					pcmpgtb	xmm3, xmm9
					pcmpgtb	xmm4, xmm9
					
					psubusb	xmm3, xmm10
					psubusb	xmm4, xmm10
					
					paddb	xmm1, xmm8
					paddb	xmm2, xmm8
					
					paddb	xmm1, xmm3
					paddb	xmm2, xmm4
					
					punpcklbw	xmm1, xmm2
					
					movq	rax, xmm1
					
					movhlps	xmm1, xmm1
					
					movq	r13, xmm1
					
					mov		rsi, 0ffffffff00000000h
					mov		rdi, 0ffffffff00000000h
					
					and		rsi, rax
					and		rdi, r13
					
					bswap	rsi
					shl		rsi, 32
					bswap	rdi
					shl		rdi, 32
					
					bswap	eax
					bswap	r13d
					
					mov		r12, 00000000ffffffffh
					and		rax, r12
					and		r13, r12
					
					or		rax, rsi
					or		r13, rdi
					
					mov		QWORD PTR[rdx], rax
					mov		QWORD PTR[r15], r13
					
					add		rdx, 10h
					add		r15, 10h
					
					sub		r8, 1
					test	r8, r8
					jnz		hHash
					jmp		putS
					
					
					putS:
						mov		r9, 'saH SOD '
						mov		r10, 000000203a68h
						
						mov		QWORD PTR[rsp + 1a0h], r9
						mov		QWORD PTR[rsp + 1a8h], r10
						mov		 BYTE PTR[rsp + 1a0h], 10
						mov		 BYTE PTR[rsp + 1f0h], 10
						
						mov		rcx, [rsp + 100h]
						lea		rdx, [rsp + 1a0h]
						mov		r8,  51h
						mov		r9,  0
						mov		QWORD PTR[rsp + 32], 0
						call	WriteConsoleA
						
						jmp		pnexit
						
					
					
			
	
	
	errorLoop:
		;r15, r11, r9, rdi, rdx, r13, 730, 738 error, 740 hex
		mov		QWORD PTR[rsp + 700h], r15
		mov		QWORD PTR[rsp + 708h], r11
		mov		QWORD PTR[rsp + 710h], r9
		mov		QWORD PTR[rsp + 718h], rdi
		mov		QWORD PTR[rsp + 720h], rdx
		mov		QWORD PTR[rsp + 728h], r13
		
		call	GetLastError
		
		
		bswap	eax
		
		mov		r14, 0f0f0f0fh ;low nibble
		mov		r15, 0f0f0f0f0h ;high nibble
		mov		r8,  30303030h ;'0'
		mov		r11, 09090909h ;9
		mov		r12, 0f8f8f8f8h
		
			
			movd		xmm0, eax
			movd		xmm1, r14
			movd		xmm2, r15
			
			pand		xmm1, xmm0
			pand		xmm2, xmm0
			
			psrlw		xmm2, 4
			
			movd		xmm3, r11
			
			movdqa		xmm7, xmm1
			movdqa		xmm8, xmm2
			
			pcmpgtb		xmm7, xmm3
			pcmpgtb		xmm8, xmm3
			
			movd		xmm5, r12
			
			psubusb		xmm7, xmm5
			psubusb		xmm8, xmm5
			
			paddb		xmm1, xmm7
			paddb		xmm2, xmm8
			
			movd		xmm6, r8
			
			paddb		xmm1, xmm6
			paddb		xmm2, xmm6
			
			punpcklbw	xmm2, xmm1
			
			movq		QWORD PTR[rsp + 740h], xmm2
			
				
			
				
				
				
				mov		rcx, [rsp + 100h]
				lea		rdx, [rsp + 700h]
				mov		r8,  60h
				mov		r9,  0
				mov		QWORD PTR[rsp + 32], 0
				call	WriteConsoleA
				
				jmp		pexit
		
		
	
			NTSTATUSErrorLoop:
					;r15, r11, r9, rdi, rdx, r13, 730, 738 error, 740 hex
					mov		QWORD PTR[rsp + 700h], r15
					mov		QWORD PTR[rsp + 708h], r11
					mov		QWORD PTR[rsp + 710h], r9
					mov		QWORD PTR[rsp + 718h], rdi
					mov		QWORD PTR[rsp + 720h], rdx
					mov		QWORD PTR[rsp + 728h], r13
					
						bswap	eax
					
					mov		r14, 0f0f0f0fh ;low nibble
					mov		r15, 0f0f0f0f0h ;high nibble
					mov		r8,  30303030h ;'0'
					mov		r11, 09090909h ;9
					mov		r12, 0f8f8f8f8h
					
						
						movd		xmm0, eax
						movd		xmm1, r14
						movd		xmm2, r15
						
						pand		xmm1, xmm0
						pand		xmm2, xmm0
						
						psrlw		xmm2, 4
						
						movd		xmm3, r11
						
						movdqa		xmm7, xmm1
						movdqa		xmm8, xmm2
						
						pcmpgtb		xmm7, xmm3
						pcmpgtb		xmm8, xmm3
						
						movd		xmm5, r12
						
						psubusb		xmm7, xmm5
						psubusb		xmm8, xmm5
						
						paddb		xmm1, xmm7
						paddb		xmm2, xmm8
						
						movd		xmm6, r8
						
						paddb		xmm1, xmm6
						paddb		xmm2, xmm6
						
						punpcklbw	xmm2, xmm1
						
						movq		QWORD PTR[rsp + 740h], xmm2
						
							
						
							
							
							
							mov		rcx, [rsp + 100h]
							lea		rdx, [rsp + 700h]
							mov		r8,  60h
							mov		r9,  0
							mov		QWORD PTR[rsp + 32], 0
							call	WriteConsoleA
							
							jmp		pnexit
				
	
		
		pnexit:
			
			mov		rcx, [rsp + 118h]
			call	BCryptCloseAlgorithmProvider
			
			mov		rcx, [rsp + 120h]
			call	BCryptDestroyHash
			
		pexit:
		mov		rcx, QWORD PTR[rsp + 110h]
		call	CloseHandle
		jmp		exit
	
	exit:
	add		rsp, 900h
	sub		rsp, 8
	mov		rax, QWORD PTR[rsp + 10h]
	mov		QWORD PTR[rsp], rax
ret
	
MAIN	ENDP
END
