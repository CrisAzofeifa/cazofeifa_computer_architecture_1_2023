import math as m
import numpy as np

m = 300
n = 300
Lx = 75
Ly = 75
pi = 3
A = np.zeros((m,n))

def rippling():
    for k in range(5, 201, 5):
        Ax = k;
        Ay = k;
        B = np.zeros((m,n))
        for x in range(0, m-1):
            for y in range(0, n-1):
                xsin = taylor(2 * pi * y / Lx)
                xaux = round(x + Ax * xsin)
                yaux = round(y + Ay * taylor(2 * pi * x / Ly))

                xnew = xaux % m;
                ynew = yaux % n;

                if (xnew == xaux and ynew == yaux):
                    B[xnew + 1][ynew + 1] = A[x][y]

def taylor(x):
    término_actual = x
    resultado = x
    signo = -1
    for i in range(3, 100, 2):
        término_actual = término_actual * x *  x / (i * (i - 1))
        resultado = resultado + signo * término_actual 
        signo = -signo
    return resultado

res = taylor(2)
print(res)