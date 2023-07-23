[ORG 0x7C00]
    ;Esse código é carregado com 512 bytes, que é o boot, e depois para 
    ;extendermos além de 512 bytes ele utiliza o disco para escrever mais código e mais
    ;funcionalidades
    
    mov ah, 2 ; Comando para ler o disco
    mov al, 1 ; Total de setores a serem lidos
    mov ch, 0 ; Cilindro do disco
    mov cl, 2 ; A partir do setor (2), leia o total de setores a serem lidos (1)
    mov dh, 1 ; Numero da cabeça a ser lida
    mov es, [EXTENSION] ; registrador es recebe o endereço da extension
    mov bx, 0
    int 13h
    jmp EXTENSION
    times 510-($-$$) db 0
    db 0x55
    db 0xAA
;------------------
EXTENSION:
    mov ah, 0x00 ;Função (Definir modo de video, param: Modo grafico)
    mov al, 0x13 ;Parametro (Modo grafico, pagina 320px x 200px )
    int 0x10
    mov al, 0x01 ; Parametro (Cor)
    mov bh, 0x00 ; Pagina
    mov cx, 0x00 ;posição X do pixel
    mov dx, 0x00 ; posição Y do pixel
LOOP:
    mov ah, 0x0C ;Função (Gravar no video algum pixel, param: Cor)
    int 0x10 ; Função de video    
    inc cx ; Avança para proximo pixel a direita
    cmp cx, 0x0140 ; Compara pra ver se chegou no limite de pixels horizontais (X)
    jne LOOP ; Se nao chegou no limite X volta pro inicio do loop
    mov cx, 0x00; Se chegou no limite reseta a posiçao X para o inicio Left
    inc dx ; Incrementa uma linha Y
    cmp dx, 0xC8
    jne LOOP
    mov dx, 0x00;
    inc al
    cmp al, 0xFF ; Verifica se chegou na ultima cor 
    je RESETCOR
    jmp LOOP
RESETCOR:
    mov al,0x00
    jmp LOOP
