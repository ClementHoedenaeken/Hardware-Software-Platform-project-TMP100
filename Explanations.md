## This file contains the explanations of the project

It is organised in 3 main parts :
1. Explain the general structure of the project
2. Explain the configuration of the project for our specific sensor


# General structure
Our sensor contains a many registers. Among them, we will only focus on the configuration register and on the temperature register. The address of the registers are given in the datasheet and on the following image. 

To understand the general structure of the project, let us consider the following scheme.  

<img width="710" alt="image" src="https://user-images.githubusercontent.com/82041018/117319862-fd66ec00-ae8b-11eb-97ce-d675e851e096.png">


The state machine controls the I2C block. To communicate with the I2C driver, we use two registers: DEVICE and ADDR. The DEVICE register contains the I2C address of the sensor and the ADDR register contains the different values we want to write (register address or values). 
Then, the I2C driver communicates with the sensor via the SDA and SCL ports.

We will read the different temperatures from the A register using a C code. The size of A register is 2 bytes.

With this structure, the sensor data retrieved by the I2C block is placed by the control code on the output register.



# Control state machine


<img width="758" alt="image" src="https://user-images.githubusercontent.com/82041018/117322110-01940900-ae8e-11eb-86e2-d9c6a5bb7ddf.png">



![Name of the registers](https://user-images.githubusercontent.com/81489863/117309529-c809d080-ae82-11eb-95a3-3eadd410cb91.png)

The configuration register will store the parameters of the sensor. We write in this register to configure our sensor. This figure shows the meaning of the different bits of the configuration byte.

![Configuration register](https://user-images.githubusercontent.com/81489863/117314000-aad70100-ae86-11eb-8886-ca99b38e1b78.png)

* OS/ALERT : 
* R1 and R0 : Here, we set up the resolution. For this project, we chose a 12 bits reading so assign both R0 and R1 to 1.
* F1 and F0 : We assign F0 and F1 to 0
* POL : 
* TM : 
* SD : We should place this bit at 1 to shut down the device after the current conversion (for energy savings). 

The temperature register is only reachable in read mode. We will read the value of the temperature in this register. The complexity of this project is the reading which can be done on 9,10,11 or 12 bits. Then, we need at least two bytes to store the temperature. 


# Configuration 

 

