# Dependencias previas:
1. Instalar el paquete NASM para la compilación y ejecución del código ensamblador x86
2. Instalar tkinter: "sudo apt-get install python3-tk" para mostrar las imagenes procesadas en interfaz

# Para correr el RSA:
1. Abra una terminal en la ubicación del archivo execute.sh (carpeta -> Proyecto_1)
2. Corra el siguiente comando bash en la terminal: "bash execute.sh"

# Lista de Instrucciones Utilizadas
1. *db*: Define un byte en la sección de datos.
2. *dw*: Define una palabra en la sección de datos.
3. *times*: Repite la directiva especificada un número de veces.
4. *section*: Define una sección con una determinada característica.
5. *global*: Define un símbolo global que puede ser referenciado desde fuera del archivo actual.
6. *resq*: Reserva un espacio en la sección de BSS para un número determinado de cuádruples de palabras (64 bits).
7. *resb*: Reserva un espacio en la sección de BSS para un número determinado de bytes.
8. *mov*: Mueve datos de un lugar a otro. También se utiliza para cargar registros con valores inmediatos.
9. *syscall*: Invoca al sistema operativo para que realice una operación específica.
10. *push*: Pone un valor en la pila.
11. *pop*: Saca un valor de la pila.
12. *call*: Llama a una subrutina.
13. *cmp*: Compara dos valores.
14. *je*: Salta a una etiqueta si la comparación anterior fue igual.
15. *jne*: Salta a una etiqueta si la comparación anterior no fue igual.
16. *inc*: Incrementa un valor en 1.
17. *jmp*: Salta incondicionalmente a una etiqueta.