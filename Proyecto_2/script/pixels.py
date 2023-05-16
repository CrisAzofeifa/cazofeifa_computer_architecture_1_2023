from PIL import Image

# Abrir la imagen
imagen = Image.open("oso-polar.jpg")

# Convertir la imagen a escala de grises
imagen_gris = imagen.convert("RGB")

# Obtener los píxeles de la imagen en forma de lista
pixeles = list(imagen_gris.getdata())
rgb_pixels = []

# Convertir los valores de los píxeles a hexadecimal
for tupla in pixeles:
    r = str(hex(tupla[0]))[2:]
    g = str(hex(tupla[1]))[2:]
    b = str(hex(tupla[2]))[2:]
    rgb = r + g + b
    rgb_pixels.append(rgb)

x = 25 // 3
print(x)

f = open ('pixeles.txt','w')
for pixel in rgb_pixels:
    f.write(pixel + '\n')
f.close()