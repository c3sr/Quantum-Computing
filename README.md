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

#### Installing Qiskit

Python needs to be installed to program using Qiskit. IBM recommends installing Anaconda, which is a cross platform Python distribution for scientific computing. Jupyter Notebooks included with Anaconda is recommended platform to programming Qiskit.

Here are steps in installing Qiskit on Windows.

1. Install Anaconda
2. Open Anaconda Prompt
3. Create a environment with specific version of Python: `conda create -n name_of_my_env python=3`
4. Activate your environment: `activate name_of_my_env`
5. Install Qiskit: `pip install qiskit`


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

#### Building this project

This project contains source code for RSA algorithm implemented in VHDL and Qiskit. Here are steps in building this project.

1. Install Qiskit following the above steps
2. Clone this repository
3. Open `src/rsa/qiskit` folder in Jupyter, which is included with Qiskit
4. Before compiling and building the source code, an IBM Q account needs to be created and a `token` needs to be generated to access IBM's Quantum Simulators via Qiskit. See instructions [here](https://qiskit.org/documentation/install.html#access-ibm-q-systems) to generate a `token`.
5. Provide the obtained `token` into the source code to build necessary functions.

```python
from qiskit import IBMQ
provider = IBMQ.enable_account('<your-token>')
```

Re-usable Python functions are written as Python files and these functions are used in Jupyter Notebook files. You can run individual Notebook which will use necessary functions needed to produce the result.


### Team Member:

Lavanya Gnanasekaran, Graduate student, Electrical and Computer Engineering department, College of Engineering, California State Polytechnic University, Pomona.

### Supervising Professor: 
Dr. Mohamed El-Hadedy, Assistant Professor, Electrical and Computer Engineering department, College of Engineering, California State Polytechnic University, Pomona.

### Project Structure:
RSA has been implemented using Qiskit Quantum Computing tool and FPGA using VHDL. Qiskit is programmable through Jupyter Notebook using Python programming language. Jupyter Notebooks and re-usable Python functions are available inside `qiskit` folder. VHDL code responsible for running RSA algorithm in FPGA is available inside `vhdl` folder.

### Project Sponsors:

1. [Xilinx](https://www.xilinx.com/)
2. [IBM](https://qiskit.org/)
3. [Center for Cognitive Computing System Research](https://www.c3sr.com/)
