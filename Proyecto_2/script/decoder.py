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


def compiler():
    file = open("./code.txt", 'r')
    data = file.read()
    file.close()
    
    instrList = data.split('\n')

    for instr in instrList:
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
                if lista[2] in registers:
                    # register-register 
                    binary_instr += dp['register']
                    Rn = '0000'
                    Src2 = '000000' + registers[lista[2]]
                    
                else:
                    # register-immediate
                    binary_instr += dp['immediate']
                    Rn = '0000'
                    Src2 = str(bin(int(lista[2]))[2:].zfill(10))

                binary_instr += dp[lista[0]]
                Rd = registers[lista[1]]

                binary_instr += Rd
                binary_instr += Rn
                binary_instr += Src2

        # complete 32 bits
        binary_instr =  '000000' + binary_instr 
        decimal = int(binary_instr, 2)
        hexa = hex(decimal)
        
        list_binary.append(hexa[2:])
    
    f = open ('machine_code.dat','w')
    for instr in list_binary:
        f.write(instr + '\n')
    f.close()
    print(list_binary)

compiler()