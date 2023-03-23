from tkinter import *

nombrePNG = "resultado.png"

#se crea la ventana y la resolucion de la misma 
ventana = Tk()
ventana.geometry("1920x1080")
imagenEncriptada = PhotoImage(file="encriptada.png")
bn = Label(ventana, image=imagenEncriptada).place(x=100,y=25)
#se coloca la imagen desencriptadas
imagenResult = PhotoImage(file=nombrePNG)
result = Label(ventana, image=imagenResult).place(x=1000,y=25)

ventana.mainloop()
