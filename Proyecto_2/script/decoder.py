#TODO HACER LA LOGICA PARA UNIR LOS ELEMENTOS DE LA INSTRUCCION
#TODO CONFIGURAR LAS OPERACIONES
#TODO VER COMO SE HACE CON LOS LABELS

dp = {
    'cond+op': '000',
    'register': '0',
    'immediate': '1',
    'SUM': '0000',
    'MUL': '0010',
    'DIV': '0100',
    'MOD': '0110',
    'MOV': '1000',
    'EQV': '1011'
}

mem = {
   'cond+op': '010', 
   'PUT': '00000',
   'GET': '00011',
}

control = {
    'S': '0010',
    'SEQ': '1010'
}

registers = {
    'R0': '0000',
    'R1': '0001',
    'R2': '0010',
    'R3': '0011',
    'R4': '0100',
    'R5': '0101',
    'R6': '0110',
    'R7': '0111',
    'R8': '1000',
    'R9': '1001'
}

Rd = ''
Rn = ''
Src2 = ''
binary_instr = ''
list_binary = []
etiquetas = []

def compiler():
    file = open("./RIPP_code.txt", 'r')
    data = file.read()
    file.close()
    
    instrList = data.split('\n')

    # mapear etiquetas
    contador = 0
    eliminar = []
    for instr in instrList:
        lista = ''
        lista = instr.split(' ')

        if (lista[0] == ''):
            eliminar.append(instr)
        elif(lista[0] not in dp) and (lista[0] not in mem) and (lista[0] not in control):
            # etiqueta
            etiquetas.append((lista[0], contador))
            eliminar.append(instr)
        else:
            contador += 4

    for item in eliminar:
        instrList.remove(item)

    contador = 0
    for instr in instrList:
        binary_instr = ''
        lista = instr.split(' ')

        if lista[0] in dp: 
            # data-processing instruction
            binary_instr = dp['cond+op']
            if len(lista) == 4: 
                # SUM, MUL, DIV, MOD
                if lista[3] in registers:
                    # register-register 
                    binary_instr += dp['register']
                    
                    Src2 =  '000000'+ registers[lista[3]]
                else:
                    # register-immediate
                    binary_instr += dp['immediate']

                    # se convierte el numero a binario de 10 bits
                    Src2 = str(bin(int(lista[3]))[2:].zfill(10))

                binary_instr += dp[lista[0]]
                Rd = registers[lista[1]]
                Rn = registers[lista[2]]

                binary_instr += Rd
                binary_instr += Rn
                binary_instr += Src2

            elif len(lista) == 3:
                # MOV, EQV
                if lista[0] == 'MOV':
                    if lista[2] in registers:
                        # register-register 
                        binary_instr += dp['register']
                        Rd = registers[lista[1]]
                        Rn = '0000'
                        Src2 = '000000' + registers[lista[2]]
                        
                    else:
                        # register-immediate
                        binary_instr += dp['immediate']
                        Rd = registers[lista[1]]
                        Rn = '0000'
                        Src2 = str(bin(int(lista[2]))[2:].zfill(10))

                else:
                    if lista[2] in registers:
                        # immediate
                        binary_instr += dp['register']
                        Rd = '1111'
                        Rn = registers[lista[1]]
                        Src2 = '000000' + registers[lista[2]]
                    else:
                        # immediate
                        binary_instr += dp['immediate']
                        Rd = '1111'
                        Rn = registers[lista[1]]
                        Src2 = str(bin(int(lista[2]))[2:].zfill(10))

                binary_instr += dp[lista[0]]

                binary_instr += Rd
                binary_instr += Rn
                binary_instr += Src2
        
        elif lista[0] in mem: 
            # memory instruction
            binary_instr += mem['cond+op']
            binary_instr += mem[lista[0]]
            Rd = registers[lista[1]]
            Rn = registers[lista[2]]
            Src2 = '0000000000'

            binary_instr += Rd
            binary_instr += Rn
            binary_instr += Src2

        else:
            # control instruction
            binary_instr += control[lista[0]]
            origen = contador
            destino = 0
            direccion = 0

            # encontrar direccion destino de salto
            for item in etiquetas:
                tuplalista = list(item)
                if tuplalista[0] == lista[1]:
                    destino = tuplalista[1] 
                    break
        
            diferencia = destino - origen - 8 # pc + 8
            diferencia = diferencia // 4
            if diferencia >= 0:
                direccion = str(bin(diferencia)[2:].zfill(22))
            else:
                complemento = bin(diferencia % (1<<22))
                direccion = str(complemento[2:])

            binary_instr += direccion

        # complete 32 bits
        binary_instr =  '000000' + binary_instr 
        decimal = int(binary_instr, 2)
        hexa = hex(decimal)
        
        list_binary.append(hexa[2:])
        contador += 4
    
    f = open ('machine_code.dat','w')
    for instr in list_binary:
        f.write(instr + '\n')
    f.close()

compiler()