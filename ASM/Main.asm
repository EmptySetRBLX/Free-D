alloc(mainmem,2048)
alloc(stackdata, 64)
alloc(testcommand, 512)
alloc(facecommand, 512)
alloc(facecommandstorage, 64)
alloc(vertexcommand, 512)
alloc(setready, 512)
alloc(vertexcommandstorage, 64)
alloc(convertascii, 512)
alloc(convertasciistorage, 64)
alloc(convertbyte, 512)
alloc(numberoffaces, 4)
alloc(numberofvertexes, 4)
alloc(facestorage, 102400)
alloc(vertexstorage, 102400)
alloc(dounion, 512)
alloc(shouldinject, 4)
label(addvertexfalse)
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
label(setreadyfalse)
label(returnhere)
label(cleanup)
label(returnunion)
label(dounionop)

shouldinject:
db 00 00 00 00

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
	
vertexcommandstorage:

vertexcommand:
	mov [vertexcommandstorage], ebx
	mov [vertexcommandstorage+4], ecx
	
	cmp [eax], 45455246 //FREE
	jne addvertexfalse
	cmp [eax+4], 4120442d //-D A
	jne addvertexfalse
	cmp [eax+8], 56204444 //DD V
	jne addvertexfalse
	cmp [eax+c], 20545245 //ERT 
	jne addvertexfalse
	
	add eax, 10
	
	mov [vertexcommandstorage+8], eax
	
	call convertascii
	
	mov ebx, [vertexstorage]
	shl ebx, 2
	add ebx, 4
	mov [vertexstorage+ebx], eax
	shr ebx, 2
	mov [vertexstorage], ebx
	
	mov eax, [vertexcommandstorage+8]
	add eax, 8
	mov [vertexcommandstorage+8], eax
	
	call convertascii
	
	mov ebx, [vertexstorage]
	shl ebx, 2
	add ebx, 4
	mov [vertexstorage+ebx], eax
	shr ebx, 2
	mov [vertexstorage], ebx
	
	mov eax, [vertexcommandstorage+8]
	add eax, 8
	mov [vertexcommandstorage+8], eax
	
	call convertascii
	
	mov ebx, [vertexstorage]
	shl ebx, 2
	add ebx, 4
	mov [vertexstorage+ebx], eax
	shr ebx, 2
	mov [vertexstorage], ebx
	
	mov eax, [vertexcommandstorage+8]
	add eax, 8
	mov [vertexcommandstorage+8], eax
	
	call convertascii
	
	mov ebx, [vertexstorage]
	shl ebx, 2
	add ebx, 4
	mov [vertexstorage+ebx], eax
	shr ebx, 2
	mov [vertexstorage], ebx
	
	mov eax, [vertexcommandstorage+8]
	add eax, 8
	mov [vertexcommandstorage+8], eax
	
	call convertascii
	
	mov ebx, [vertexstorage]
	shl ebx, 2
	add ebx, 4
	mov [vertexstorage+ebx], eax
	shr ebx, 2
	mov [vertexstorage], ebx
	
	mov eax, [vertexcommandstorage+8]
	add eax, 8
	mov [vertexcommandstorage+8], eax
	
	call convertascii
	
	mov ebx, [vertexstorage]
	shl ebx, 2
	add ebx, 4
	mov [vertexstorage+ebx], eax
	shr ebx, 2
	mov [vertexstorage], ebx
	
	mov eax, [numberofvertexes]
	add eax, 1
	mov [numberofvertexes], eax
	
	mov eax, 1
	ret
	
	
	mov eax, 1	
	ret
	
	addvertexfalse:
		mov eax,0
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
		
setready:
	cmp [eax], 45455246 //FREE
	jne setreadyfalse
	cmp [eax+4], 5320442D //-D S
	jne setreadyfalse
	cmp [eax+8], 53205445 //ET S
	jne setreadyfalse
	cmp [eax+C], 54524154 //TART
	jne setreadyfalse
	
	mov [shouldinject], 1
	mov eax, 1
	ret
	setreadyfalse:
		mov eax, 0
		ret
	

mainmem: //EXECUTED WHEN MEMORY IS ALLOCATED TO A STRING OBJECT, CAN RUN COMMANDS FROM HERE
	pushfd
	pushad
	
	
	mov eax, esi
	call testcommand
	cmp eax, 1
	je cleanup
	
	mov eax,esi
	call facecommand
	cmp eax, 1
	je cleanup
	
	mov eax,esi
	call vertexcommand
	cmp eax,1
	je cleanup
	
	mov eax, esi
	call setready
	cmp eax,1
	je cleanup

	
	jmp cleanup

	cleanup:
		popad
		popfd
		cmp eax,[esi]
		jne RobloxStudioBeta.exe+A946
		add edx,04
		jmp returnhere
		
dounion:
	cmp [shouldinject], 00000000
	je dounionop
	mov [stackdata], eax
	mov [esp], vertexstorage+4
	mov eax, [numberofvertexes]
	mov [esp+4], eax
	mov [esp+8], facestorage+4
	mov eax, [numberoffaces]
	mov [esp+c], eax
	mov eax, [stackdata]
	
	mov [vertexstorage], 00000000
	mov [facestorage], 00000000
	mov [numberoffaces], 00000000
	mov [numberofvertexes], 00000000
	mov [shouldinject], 00000000
	jmp dounionop

	dounionop:
		call dword ptr [RobloxStudioBeta.exe+BEED20]
		jmp returnunion

"RobloxStudioBeta.exe"+1F8593:
	jmp dounion
	nop
	returnunion:

"RobloxStudioBeta.exe"+A932:
	jmp mainmem
	nop
	nop
	returnhere:

//injector 8B 55 08 56 8B 75 0C 83 E9 04 72 17 8D 9B 00 00 00 00 8B 02 

//union 6A 00 51 D1 FA 8B CA C1  E9 1F 03 CA C7 04 24 DB 