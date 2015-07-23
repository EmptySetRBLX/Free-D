alloc(mainmem,2048)
alloc(stackdata, 64)
alloc(testcommand, 512)
alloc(facecommand, 512)
label(addfacefalse)
label(testcommandfalse)
label(returnhere)
label(cleanup)

facecommand:
	cmp [eax], 45455246 //FREE
	jne addfacefalse
	cmp [eax+4], 4120442d //-D A
	jne addfacefalse
	cmp [eax+8], 46204444 //DD F
	jne addfacefalse
	cmp [eax+c], 20454341 //ACE 
	jne addfacefalse

	mov eax,1
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