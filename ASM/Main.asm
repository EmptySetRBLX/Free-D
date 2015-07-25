alloc(mainmem,2048)
alloc(stackdata, 64)
alloc(testcommand, 512)
alloc(facecommand, 512)
alloc(facecommandstorage, 64)
alloc(convertascii, 512)
alloc(convertasciistorage, 64)
alloc(convertbyte, 512)
alloc(numberoffaces, 4)
alloc(numberofvertexes, 4)
alloc(facestorage, 102400)
alloc(vertexstorage, 102400)
label(convert0)
label(convert1)
label(convert2)
label(convert3)
label(convert4)
label(convert5)
label(convert6)
label(convert7)
label(convert8)
label(convert9)
label(converta)
label(convertb)
label(convertc)
label(convertd)
label(converte)
label(convertf)
label(addfacefalse)
label(testcommandfalse)
label(returnhere)
label(cleanup)

numberoffaces:
db 00 00 00 00

numberofvertexes:
db 00 00 00 00

facestorage:
db 00 00 00 00

vertexstorage:
db 00 00 00 00

convertbyte: //Holy crap this function is awful. Dont blame me, was written at 3am.
	cmp eax, 30
	je convert0
	cmp eax, 31
	je convert1
	cmp eax, 32
	je convert2
	cmp eax, 33
	je convert3
	cmp eax, 34
	je convert4
	cmp eax, 35
	je convert5
	cmp eax, 36
	je convert6
	cmp eax, 37
	je convert7
	cmp eax, 38
	je convert8
	cmp eax, 39
	je convert9
	cmp eax, 41
	je converta
	cmp eax, 42
	je convertb
	cmp eax, 43
	je convertc
	cmp eax, 44
	je convertd
	cmp eax, 45
	je converte
	cmp eax, 46
	je convertf

	convert0:
		mov eax, 0
		ret
	convert1:
		mov eax, 1
		ret
	convert2:
		mov eax, 2
		ret
	convert3:
		mov eax, 3
		ret
	convert4:
		mov eax, 4
		ret	
	convert5:
		mov eax, 5
		ret		
	convert6:
		mov eax, 6
		ret	
	convert7:
		mov eax, 7
		ret
	convert8:
		mov eax, 8
		ret
	convert9:
		mov eax, 9
		ret
	converta:
		mov eax, a
		ret
	convertb:
		mov eax, b
		ret
	convertc:
		mov eax, c
		ret
	convertd:
		mov eax, d
		ret	
	converte:
		mov eax, e
		ret	
	convertf:
		mov eax, f
		ret	

convertasciistorage:

convertascii:
	mov [convertasciistorage], eax
	mov [convertasciistorage+4], ebx
	mov [convertasciistorage+8], ecx
	mov ecx, 00000000
	mov ebx, eax
	mov eax, [ebx-3]
	shr eax, 18
	call convertbyte
	shl eax, 1c
	mov ecx, eax
	
	mov eax, [ebx-2]
	shr eax, 18
	call convertbyte
	shl eax, 18
	add ecx, eax
	
	mov eax, [ebx-1]
	shr eax, 18
	call convertbyte
	shl eax, 14
	add ecx, eax
	
	mov eax, [ebx]
	shr eax, 18
	call convertbyte
	shl eax, 10
	add ecx, eax
	
	mov eax, [ebx+1]
	shr eax, 18
	call convertbyte
	shl eax, c
	add ecx, eax
	
	mov eax, [ebx+2]
	shr eax, 18
	call convertbyte
	shl eax, 8
	add ecx, eax
	
	mov eax, [ebx+3]
	shr eax, 18
	call convertbyte
	shl eax, 4
	add ecx, eax
	
	mov eax, [ebx+4]
	shr eax, 18
	call convertbyte
	add ecx, eax
	
	mov eax, ecx
	
	mov ebx, [convertasciistorage+4]
	mov ecx, [convertasciistorage+8]
	ret
	
facecommandstorage:

facecommand:
	mov [facecommandstorage], ebx
	mov [facecommandstorage+4], ecx
	cmp [eax], 45455246 //FREE
	jne addfacefalse
	cmp [eax+4], 4120442d //-D A
	jne addfacefalse
	cmp [eax+8], 46204444 //DD F
	jne addfacefalse
	cmp [eax+c], 20454341 //ACE 
	jne addfacefalse
	
	add eax, 10
	
	mov [facecommandstorage+8], eax
	
	call convertascii
	
	mov ebx, [facestorage]
	shl ebx, 2
	add ebx, 4
	mov [facestorage+ebx], eax
	shr ebx, 2
	mov [facestorage], ebx
	
	mov eax, [facecommandstorage+8]
	add eax, 8
	mov [facecommandstorage+8], eax
	
	call convertascii
	
	mov ebx, [facestorage]
	shl ebx, 2
	add ebx, 4
	mov [facestorage+ebx], eax
	shr ebx, 2
	mov [facestorage], ebx
	
	mov eax, [facecommandstorage+8]
	add eax, 8
	mov [facecommandstorage+8], eax
	
	call convertascii
	
	mov ebx, [facestorage]
	shl ebx, 2
	add ebx, 4
	mov [facestorage+ebx], eax
	shr ebx, 2
	mov [facestorage], ebx
	
	mov ebx, [convertasciistorage+4]
	mov ecx, [convertasciistorage+8]
	
	mov eax, [numberoffaces]
	add eax, 1
	mov [numberoffaces], eax
	
	mov eax, 1
	ret

	addfacefalse:
		mov eax,0
		ret

testcommand:
	cmp [eax], 45455246 //FREE
	jne testcommandfalse
	cmp [eax+4], 5420442d //-D T
	jne testcommandfalse
	cmp [eax+8], 20545345 //EST 
	jne testcommandfalse 
	cmp [eax+c], 4d4d4f43 //COMM
	jne testcommandfalse
	cmp [eax+10], 414e4420 //AND 
	
	mov [eax], 57205449 //IT W
	mov [eax+4], 454b524f //ORKE
	mov [eax+8], 41592044 //D YA
	mov [eax+c], 41414141 //AAAA
	mov [eax+10], 59414141 //AAAY
	
	mov eax,1
	
	ret
	
	testcommandfalse:
		mov eax, 0
		ret

mainmem: //EXECUTED WHEN MEMORY IS ALLOCATED TO A STRING OBJECT, CAN RUN COMMANDS FROM HERE
	mov [stackdata], eax
	mov [stackdata+4], ebx
	mov [stackdata+8], ecx
	mov [stackdata+c], edx
	mov [stackdata+10], esi
	mov [stackdata+14], edi
	mov [stackdata+18], ebp
	
	pop eax
	mov [stackdata+1c], eax //LENGTH POINTER
	pop eax
	mov [stackdata+20], eax
	pop eax
	mov [stackdata+24], eax
	pop eax
	mov [stackdata+28], eax
	
	mov eax, esi
	call testcommand
	
	mov eax,esi
	call facecommand

	
	jmp cleanup

	cleanup:
		mov eax, [stackdata+28]
		push eax
		mov eax, [stackdata+24]
		push eax
		mov eax, [stackdata+20]
		push eax
		mov eax, [stackdata+1c]
		push eax
		
		mov ebp, [stackdata+18]
		mov edi, [stackdata+14]
		mov esi, [stackdata+10]
		mov edx, [stackdata+c]
		mov ecx, [stackdata+8]
		mov ebx, [stackdata+4]
		mov eax, [stackdata]
		
		cmp eax,[esi]
		jne RobloxStudioBeta.exe+A756
		add edx,04
		jmp returnhere

"RobloxStudioBeta.exe"+A742:
	jmp mainmem
	nop
	nop
	returnhere:

8B 55 08 56 8B 75 0C 83 E9 04 72 17 8D 9B 00 00 00 00 8B 02