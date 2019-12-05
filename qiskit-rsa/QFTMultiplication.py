from QFTAddition import add
from QFTSubtraction import sub
from qiskit import ClassicalRegister, QuantumRegister
from qiskit import QuantumCircuit
from qiskit import execute
import math
import operator
from qiskit import Aer



def mul(multiplicand_in, multiplier_in): 

        
    # Take two numbers as user input in binary form
    # multiplicand_in = input("Enter the multiplicand.")
    l1 = len(multiplicand_in)
    # multiplier_in = input("Enter the multiplier.")
    l2 = len(multiplier_in)
    # Make sure multiplicand_in holds the larger number
    if l2 > l1:
        multiplier_in, multiplicand_in = multiplicand_in, multiplier_in
        l2, l1 = l1, l2

    accumulator = QuantumRegister(l1 + l2)
    multiplicand = QuantumRegister(l1)
    multiplier = QuantumRegister(l2)
    d = QuantumRegister(1)
    
    cl_accumulator = ClassicalRegister(l1 + l2)
    cl_multiplier = ClassicalRegister(l2)
    
    circ_accumulator = QuantumCircuit(accumulator, multiplicand, cl_accumulator)
    circ_multiplier = QuantumCircuit(multiplier, d, cl_multiplier)
    circ_multiplier.x(d[0])
    
    for i in range(l1):
        if multiplicand_in[i] == '1':
            circ_accumulator.x(multiplicand[l1 - i - 1])
    for i in range(l2):
        if multiplier_in[i] == '1':
            circ_multiplier.x(multiplier[l2 - i - 1])
            
    multiplier_str = '1'
    while(int(multiplier_str) != 0):
        add(accumulator, multiplicand, circ_accumulator)
        sub(multiplier, d, circ_multiplier)
        circ_multiplier.measure(multiplier, cl_multiplier)
        result = execute(circ_multiplier, backend=Aer.get_backend('qasm_simulator'), shots=2).result().get_counts(circ_multiplier)
        multiplier_str = list(result.keys())[0]
    
    circ_accumulator.measure(accumulator, cl_accumulator)
    result = execute(circ_accumulator, backend=Aer.get_backend('qasm_simulator'), shots=2).result().get_counts(circ_accumulator)
    total = list(result.keys())[0]
    return total
        
        
        
        
        
        
        
        
# ----------------- Old algorithm with one circuit ---------------------------------        
        
        
        
#     accumulator = QuantumRegister(l1 + l2)
#     multiplicand = QuantumRegister(l1)
#     multiplier = QuantumRegister(l2)
#     d = QuantumRegister(1)
#     cl = ClassicalRegister(l1 + l2)
#     circ = QuantumCircuit(accumulator, multiplicand, multiplier, 
#         d, cl, name="circ")
#     circ.x(d[0])


#     for i in range(l1):
#         if multiplicand_in[i] == '1':
#             circ.x(multiplicand[l1 - i - 1])
#     for i in range(l2):
#         if multiplier_in[i] == '1':
#             circ.x(multiplier[l2 - i - 1])

#     multiplier_str = '1'
#     while(int(multiplier_str) != 0):
#         add(accumulator, multiplicand, circ)
#         sub(multiplier, d, circ)
#         for i in range(len(multiplier)):
#             circ.measure(multiplier[i], cl[i])
#         result = execute(circ,backend=Aer.get_backend('qasm_simulator'),
#                     shots=2).result().get_counts(circ.name)
#         #print(result)
#         multiplier_str = list(result.keys())[0]
#         #print(multiplier_str)

#     circ.measure(accumulator, cl)
#     result = execute(circ, backend=Aer.get_backend('qasm_simulator'),
#                 shots=2).result().get_counts(circ.name)
#     total = list(result.keys())[0]
#     return total

# ---------------------------------------------------