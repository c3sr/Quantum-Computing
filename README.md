### Implementation

RSA is the most commonly used asymmetric cryptographic algorithm used in transmitting data over the web. Algorithm is explained in the below diagram.

![image](https://user-images.githubusercontent.com/54873229/70281821-e12fbe80-1770-11ea-82bd-d29b6a6eebaa.png)


Here is block diagram of RSA algorithm:

![image](https://user-images.githubusercontent.com/54873229/70281037-c8bea480-176e-11ea-8463-b31d70648327.png)


#### Implementation of RSA in FPGA

This project contains implementation of RSA crypto processor in FPGA using VHDL. The program was designed, developed, synthesized and implemented using Xilinx Vivado Design Suite on Nexys 4 FPGA board. To make an efficient RSA crypto processor, I have used Montgomery technique for modular multiplication and exponentiation, which avoid normal division operation and replaces with shift-and-add operation.

Below is the Montgomery modular multiplication algorithm implemented in this project.

![image](https://user-images.githubusercontent.com/54873229/70282370-68316680-1772-11ea-8429-4dddc83031c5.png)

Here's power estimation summary for RSA in FPGA:

![image](https://user-images.githubusercontent.com/54873229/70282626-3c62b080-1773-11ea-8754-a041d66aa12d.png)

Below is resource utilization summary for RSA in FPGA:

![image](https://user-images.githubusercontent.com/54873229/70282676-66b46e00-1773-11ea-9dbd-d5f3d64c1b7b.png)


#### Implementation of RSA in Qiskit

Qiskit is an open source SDK (Software Development Kit) created by IBM, which allows us to access real Quantum computer via cloud. Before starting to code for Quantum computers, an account needs to be created with IBM Q experience to interact with Quantum simulator. This generates a token, which provides access to IBM's Quantum computer. Programs can be written in Python in Jupyter Notebook to work with IBM's Quantum computer.

After installing Qiskit using `pip install` command, first step to start coding in the IBM's Quantum computer is to enable your account with the token provided in the IBM Q experience. This can be done by the following lines of code in Jupyter notebook.

```python
from qiskit import IBMQ
provider = IBMQ.enable_account('<your-token>')
qasm_sim = provider.get_backend('ibmq_qasm_simulator')
```

This project uses Quantum Fourier Transform (QFT) adder to perform fast addition and it serves as a base component for multiplication and exponentiation operations.

Quantum circuit of QFT adder is shown below:

![image](https://user-images.githubusercontent.com/54873229/70283235-58ffe800-1775-11ea-88e7-1fea953602f5.png)

![image](https://user-images.githubusercontent.com/54873229/70283259-64ebaa00-1775-11ea-9c77-be2e50ae34da.png)

![image](https://user-images.githubusercontent.com/54873229/70283293-77fe7a00-1775-11ea-8b53-61366c5454e9.png)

### Author

Lavanya Gnanasekaran, Graduate student, Electrical and Computer Engineering department, College of Engineering, California State Polytechnic University, Pomona.

### Supervising Professor: 

Dr. Mohamed El-Hadedy, Assistant Professor, Electrical and Computer Engineering department, College of Engineering, California State Polytechnic University, Pomona.

### Committee Members:

Dr. Halima El Naga, Department Chair, Electrical and Computer Engineering department, College of Engineering, California State Polytechnic University, Pomona.

Dr. Anas Salah Eddin, Assistant Professor, Electrical and Computer Engineering department, College of Engineering, California State Polytechnic University, Pomona.

### Project Structure:

I have implemented RSA in Qiskit and FGPA using VHDL. Qiskit is programmable through Jupyter Notebook using Python programming language. Jupyter Notebooks and re-usable Python functions are available inside `qiskit` folder. VHDL code responsible for running RSA algorithm in FPGA is available inside `vhdl` folder.

### Project Sponsors:

1. [Xilinx](https://www.xilinx.com/)
2. [IBM](https://qiskit.org/)
3. [Center for Cognitive Computing System Research](https://www.c3sr.com/)
