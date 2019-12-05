def decimalToBinary(n):  
  
    if(n > 1):  
        # divide with integral result  
        # (discard remainder)  
        decimalToBinary(n//2)  
  
      
    return n%2

print(decimalToBinary(5))