from PIL import Image
import numpy as np
def finDesencriptada():
    f = open('Desencriptada.txt', "r")
    #lee el la imagen desencriptada
    lines = f.readlines()
    f.close()
    txt = lines[0]
    x = txt.split(' ')
    
    lista = []
    #toma los pixeles resultantes
    for i in range(len(x)):
        if x[i] != '':
            lista.append(int(x[i]))
    print(len(lista))
    imagen = Image.new('L', [640,480])
    imagen.putdata(lista)
    #guarda la imagen resultante en formato png (con el fin de que tkinter sea capaz de mostrarla)
    imagen.save("resultado.png")

def finEncriptada():
    f = open('Encriptada.txt', "r")
    #lee el encriptado
    lines = f.readlines()
    f.close()
    txt = lines[0]
    x = txt.split(' ')
    
    lista = []
    #toma los pixeles encriptados
    for i in range(len(x) - 1):
        if x[i] != '':
            lista.append(int(x[i]))
    print(len(lista))
    imagen = Image.new('L', [640,960])
    imagen.putdata(lista)
    #guarda la imagen resultante en formato png (con el fin de que tkinter sea capaz de mostrarla)
    imagen.save("encriptada.png")
    
finEncriptada()
finDesencriptada()

