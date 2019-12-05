
# right shift operation - It will perform a/2
# onequbit is a single qubit register with 0 initialized
# n is no of bits in a
def rshift(circ, a, n, onequbit):
    # Iterate through pairs and do swaps.
    for i in range(n-1):
        circ.swap(a[i],a[i+1])
    circ.swap(a[n-1], onequbit[0])

