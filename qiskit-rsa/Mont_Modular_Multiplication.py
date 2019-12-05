from qiskit import ClassicalRegister, QuantumRegister
from qiskit import QuantumCircuit
from QFTAddition import add
from qiskit import execute
from qiskit import Aer
from BitwiseOperations import rshift
from QFTSubtraction import sub


def Mont_Mul(x, y, m):
    
    n = len(x)

    x_reg = QuantumRegister(n+1)
    y_reg = QuantumRegister(n+2)
    y_reg_0 = QuantumRegister(1)
    m_reg = QuantumRegister(n+2)
    a_reg = QuantumRegister(n+2)
    u_reg = QuantumRegister(n+1)
    onecubit = QuantumRegister(1)

    a_cl_reg = ClassicalRegister(n+2)
    u_cl_reg = ClassicalRegister(n+1)
    cl_reg = ClassicalRegister(n+1)
    one_cl_reg = ClassicalRegister(1)

    circ_u = QuantumCircuit(u_reg, y_reg_0, u_cl_reg)
    circ_a = QuantumCircuit(a_reg, y_reg, m_reg, a_cl_reg, onecubit, one_cl_reg)

    if y[n - 1] == '1':
        circ_u.x(y_reg_0) 

    for i in range(n):
        if y[i] == '1':
            circ_a.x(y_reg[n - i - 1])
    for i in range(n):
        if m[i] == '1':
            circ_a.x(m_reg[n - i - 1])


    for i in range(n):
        if x[n - i - 1] == '1':
            add(u_reg, y_reg_0, circ_u)
        circ_u.measure(u_reg[0], u_cl_reg[0])  
        result = execute(circ_u,backend=Aer.get_backend('qasm_simulator'), shots=2).result().get_counts(circ_u)
        measure_u = int((list(result.keys())[0]))

        if x[n - i - 1] == '1':
            add(a_reg, y_reg, circ_a)
        if measure_u == 1:
            add(a_reg, m_reg, circ_a)
        rshift(circ_a, a_reg, n + 2, onecubit)
        circ_a.measure(a_reg, a_cl_reg)
        circ_a.measure(onecubit, one_cl_reg)
        result = execute(circ_a,backend=Aer.get_backend('qasm_simulator'), shots=2).result().get_counts(circ_a)
        total = list(result.keys())[0]    
        measure_a = total[2:]

        measure_onecubit = int(total[0])
        if measure_onecubit == 1:
            circ_a.x(onecubit)    

        # loading a0 to u0
        if measure_a[n + 1] == '1':
            if measure_u == 0:
                circ_u.x(u_reg[0])
        else:
            if measure_u == 1:
                circ_u.x(u_reg[0])

    if (int(measure_a) >= int(m)):
        sub(a_reg, m_reg, circ_a)

    circ_a.measure(a_reg, a_cl_reg)
    result = execute(circ_a,backend=Aer.get_backend('qasm_simulator'), shots=2).result().get_counts(circ_a)
    total = list(result.keys())[0]    
    final_a = total[2:]
    return final_a