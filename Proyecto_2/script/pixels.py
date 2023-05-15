from PIL import Image

# Abrir la imagen
imagen = Image.open("oso-polar.jpg")

# Convertir la imagen a escala de grises
imagen_gris = imagen.convert("L")

# Obtener los píxeles de la imagen en forma de lista
pixeles = list(imagen_gris.getdata())

# Convertir los valores de los píxeles a hexadecimal
pixeles_hex = [hex(pixel) for pixel in pixeles]

f = open ('pixeles.txt','w')
for pixel in pixeles_hex:
    f.write(pixel[2:] + '\n')
f.close()