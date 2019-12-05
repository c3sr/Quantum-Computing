
### Team Members

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




