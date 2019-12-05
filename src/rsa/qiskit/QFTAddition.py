import math

def createInputState(qc, reg, n, pie):
    """
    Apply one Hadamard gate to the nth qubit of the quantum register               
    reg, and then apply repeated phase rotations with parameters  
    being pi divided by increasing powers of two.
    """
    qc.h(reg[n])    
    for i in range(0, n):
        qc.cu1(pie/float(2**(i+1)), reg[n-(i+1)], reg[n])
        
def evolveQFTState(qc, reg_a, reg_b, n, pie, factor):
    """  
    Evolves the state |F(ψ(reg_a))> to |F(ψ(reg_a+reg_b))> using the   
    quantum Fourier transform conditioned on the qubits of the 
    reg_b. Apply repeated phase rotations with parameters being pi 
    divided by increasing powers of two.
    """
    l = len(reg_b)
    for i in range(0, n + 1):
        if (n - i) > l - 1:
            pass
        else:
            qc.cu1(factor * pie / float(2**(i)), reg_b[n - i], reg_a[n])
            
def inverseQFT(qc, reg, n, pie):
    """
    Performs the inverse quantum Fourier transform on a register 
    reg. Apply repeated phase rotations with parameters being pi    
    divided by decreasing powers of two, and then apply a Hadamard 
    gate to the nth qubit of the register reg.
    """
    for i in range(0, n):
        qc.cu1(-1*pie/float(2**(n-i)), reg[i], reg[n])
    qc.h(reg[n])
    
def add(reg_a, reg_b, circ, factor = 1):
    """
    Add two quantum registers reg_a and reg_b, and store the result 
    in reg_a.
    """
    pie = math.pi
    n = len(reg_a)
    # Compute the Fourier transform of register a
    for i in range(0, n):
        createInputState(circ, reg_a, n - (i+1), pie)
    # Add the two numbers by evolving the Fourier transform   
    # F(ψ(reg_a))> to |F(ψ(reg_a+reg_b))>
    for i in range(0, n):
        evolveQFTState(circ, reg_a, reg_b, n - (i+1), pie, factor)
    # Compute the inverse Fourier transform of register a
    for i in range(0, n):
        inverseQFT(circ, reg_a, i, pie)