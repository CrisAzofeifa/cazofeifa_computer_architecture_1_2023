#TODO HACER LA LOGICA PARA UNIR LOS ELEMENTOS DE LA INSTRUCCION
#TODO CONFIGURAR LAS OPERACIONES
#TODO VER COMO SE HACE CON LOS LABELS

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
instruccion = ''

def compiler():
    file = open("./code.txt", 'r')
    data = file.read()
    file.close()
    
    instrList = data.split('\n')

    for instr in instrList:
        lista = instr.split(' ')
        if lista[0] == 'SUM': #Suma
            parse(lista)
        elif lista[0] == 'MUL': #Multiplicacion
            parse(lista)
        elif lista[0] == 'DIV': #Division
            parse(lista)
        elif lista[0] == 'MOD':  #Modulo
            parse(lista)
        elif lista[0] == 'MOV':  #Mov asignacion
            parse(lista)
        elif lista[0] == 'EQV':  #Compare
            print('equal')
        elif lista[0] == 'GET':  #Load
            print('guardar')  
        elif lista[0] == 'STR':  #Store
            print('pedir') 
        elif lista[0] == 'SEQ':  #Branch equal
            print('b equal') 
        elif lista[0] == 'S': #Branch
            print('b') 
        else:               #Label
            print('label')

def parse(lista):
    if lista[1] in registers: #Verifica que el registro Rd este en el diccionario
        registro = registers[lista[1]]
        print(registro)

    if lista[2] in registers: #Verifica que el registro Rn este en el diccionario
        registro = registers[lista[2]]
        print(registro)

    if lista[3] in registers: #Verifica que el registro Rm este en el diccionario
        registro = registers[lista[3]]
        print(registro)
    else: #Si no es un registro, es un immediate
        numero = str(bin(int(lista[3]))[2:].zfill(10)) #se convierte el numero a binario de 10 bits
        print(numero)

compiler()