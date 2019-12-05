from Mont_Modular_Multiplication import Mont_Mul


def Mont_Exp(x, e, m):

    L = len(m)

    # R calculation
    R = 2**L

    # R mod m or Initial A calculation:
    R_mod_m = R % int(m,2) #int('string', base)
    A = str(R_mod_m)
    A = str(bin(int(A))[2:]).zfill(L) 

    # R^2 mod m calculation
    R_square_mod_m = str(((R**2) % int(m,2)))
    T = len(e)
    R_square_mod_m = str((bin(int(R_square_mod_m))[2:])).zfill(L)
    
    # writing input x in montgomery domain called x_dash
    x_dash = Mont_Mul(x, R_square_mod_m, m)
   
    for i in range(0,T):
        if (len(A) > L):
            A = A[2:L+2]
        A = Mont_Mul(A, A, m)
        if e[i] == '1':
            A = Mont_Mul(A[2:L+2], x_dash[2:L+2], m)
            

    A = Mont_Mul(A[2:L+2], '1'.zfill(L), m)
    return A