instrucciones = {
    'SUM': '000000',
    'MUL': '000001',
    'DIV': '000010',
    'MOV': '000011',
    'MOV': '001011',
    'EQV': '001100',
    'SAL': '010000',
    'SEQ': '011001',
    'STR': '100000',
    'GET': '100001',
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

def compiler():
    file = open("./code.txt", 'r')
    instrList = file.readlines()
    
    for instr in instrList:
        print(instr)


compiler()