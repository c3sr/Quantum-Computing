def Mod_Inv(x,y):

    x = int(x, 2)
    y = int(y, 2)

    while((x%2 == 0) and (y%2 == 0)):
        x = int(x/2);
        y = int(y/2);
        g = 2*g


    u = x
    v = y
    A = 1
    B = 0
    C = 0
    D = 1


    def uv_func(u,v,A,B,C,D):
        
        while(u%2 == 0):
            u = int(u/2)
            if(A%2 == 0 and B%2 == 0):
                A = int(A/2)
                B = int(B/2)
            else:
                A = int((A+y) /2)
                B = int((B-x) /2)

        while(v%2 == 0):
            v = int(v/2)
            if(C%2 == 0 and D%2 == 0):
                C = int(C/2)
                D = int(D/2)
            else:
                C = int((C+y) /2)
                D = int((D-x) /2)
        if(u >= v):
            u = u-v
            A = A-C
            B = B-D
        else:
            v = v-u
            C = C-A
            D = D-B

        if(u == 0):
            a = C
            final_D = D
            return final_D
        else:
            return uv_func(u,v,A,B,C,D)



    out = uv_func(u,v,A,B,C,D)
    if(out < 0):
        out = out + x  
    out = str(bin(out)[2:])
    return out