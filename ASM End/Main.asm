alloc(mainmem,2048)
alloc(stackdata, 1024)
label(returnhere)
label(cleanup)

mainmem: //this is allocated memory, you have read,write,execute access
	mov [stackdata], eax
	mov [stackdata+4], ebx
	mov [stackdata+8], ecx
	mov [stackdata+c], edx
	mov [stackdata+10], esi
	mov [stackdata+14], edi
	mov [stackdata+18], ebp
	
	pop eax
	mov [stackdata+1c], eax
	pop eax
	mov [stackdata+20], eax
	pop eax
	mov [stackdata+24], eax
	pop eax
	mov [stackdata+28], eax
	
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
		call RobloxStudioBeta.exe+9F9040
		jmp returnhere

"RobloxStudioBeta.exe"+1698:
	jmp mainmem
	returnhere:
