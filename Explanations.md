

## This file contains the explanations of the project

It is organised in 3 main parts :
1. Explain the general structure of the project
2. Explain the configuration of the project for our specific sensor
3. Explain how to implement this project in practice (*Tutorial*)

# General structure

To understand the general structure of the project, let us consider the following scheme.  

<img width="710" alt="image" src="https://user-images.githubusercontent.com/82041018/117319862-fd66ec00-ae8b-11eb-97ce-d675e851e096.png">

The state machine controls the I2C block. To communicate with the I2C driver, we use two registers: DEVICE and ADDR. The DEVICE register contains the I2C address of the sensor and the ADDR register contains the different values we want to write (register address or values). 
Then, the I2C driver communicates with the sensor via the SDA and SCL ports.

We will read the different temperatures from the A register using an ARM processor programmed in C(see the code in the file *main.c*). The size of A register is 2 bytes. The first byte contains the integer part of the temperature and the second one contains the decimal part of the temperature. This decimal part is written on 1 to 4 bytes depending on the precision of our measure (see [Configuration part](https://github.com/ClementHoedenaeken/Hardware-Software-Platform-project-TMP100/blob/main/Explanations.md#configuration)).

With this structure, the data, measured by the sensor, is retrieved by the I2C block and placed by the control code on the output registers.

## I²C driver
This part of the project was not made by ourself. This part is charged to communicate with the sensor. It's state machine is the following.

<img width="400" alt="image" src="https://user-images.githubusercontent.com/81489863/117325002-9ef03c80-ae90-11eb-94b8-64418adf2483.png">

What we implemented by ourself though is the state machine controlling this I²C driver. We drove it to follow the sequence described on the next image. 

![image](https://user-images.githubusercontent.com/81489863/119115007-fb259580-ba26-11eb-95d8-b2148a3f5ade.png)


## Control state machine
The aim of this state machine is to control the driver to make it do the following sequence.
* Ask to write in the slave
* Ask access to the configuration register (in writing mode)
* Write in the configuration register
* Ask to write in the slave
* Ask access to the temperature register 
* Ask to read in the slave
* Read the first byte of temperature
* Read the second byte of temperature

The reading part is then repeated in an infinite loop to keep providing values of temperature in the registers. 

This is done with the following state machine. 
![image](https://user-images.githubusercontent.com/81489863/119117790-e26aaf00-ba29-11eb-9015-fc0d80e8d5e6.png)
This is the representation of the state machine built in the file [*bloc.vhd*](https://github.com/ClementHoedenaeken/Hardware-Software-Platform-project-TMP100/blob/23dac9de8565a8c68c71bdf7c4a758f6fdebe366/bloc.vhd)

We checked that this state machine is correct with a testbench and by comparing it to the datasheet of the sensor. 

## Temperature sensor
We used the TMP-100 temperature sensor. It has an I²C interface. It is able to measure temperatures ranging from -55°C to +125°C with an accuracy of 3°C. It even has an accuracy of 2°C within the range [-25°C ; +85°C].

Our sensor contains many registers. Among them, we will only focus on the configuration register and on the temperature register. The address of the registers are given in the datasheet and on the following image. 

![Name of the registers](https://user-images.githubusercontent.com/81489863/117309529-c809d080-ae82-11eb-95a3-3eadd410cb91.png)

The configuration register (01) will store the parameters of the sensor. We write in this register to configure our sensor (see [Configuration part](https://github.com/ClementHoedenaeken/Hardware-Software-Platform-project-TMP100/blob/main/Explanations.md#configuration)). 

The temperature register (00) is only reachable in read mode. We will read the value of the temperature in this register. The complexity of this project is the reading which can be done on 9,10,11 or 12 bits. Then, we need at least two bytes to store the temperature. However, we could only focus on the first byte which contains the integer part of the temperature and not consider the second byte which is used to store the decimal part. That means that, in 12 bits reading, we reach a resolution of 0.0625°C (4 bits used to store the decimal part).




# Configuration 

 This figure shows the meaning of the different bits of the configuration byte.

![Configuration register](https://user-images.githubusercontent.com/81489863/117314000-aad70100-ae86-11eb-8886-ca99b38e1b78.png)

* OS/ALERT : In comparator mode, a 1 indicates that the temperature passed the value of the limits of the sensor.
* R1 and R0 : Here, we set up the resolution. For this project, we chose a 12 bits reading so assign both R0 and R1 to 1.
* F1 and F0 : We assign F0 and F1 to 0. The sensor will then raise an error after 1 measurement outside the temperature range.
* POL : If 0, the alert pin will be active LOW. 
* TM : We set this bit to 0 because we want to work in comparator mode (and not interrupt mode). 
* SD : We should place this bit at 1 to shut down the device after the current conversion (for energy savings for example). For this project, we chose to continuously read the temperature so we place this bit at 0. 

In the end, the value that we place in our configuration register is  : 01100000.

# How to upload the code

First, we must create a first block file.
Then, we go to the ghrd file which is the header file.In the ghrd file, we create the same connections as in the block.
Then, we open the Platform Designer to establish the connections to compile the code.
After compiling the code, we create the .h file that serves as a link between the C code and the Quartus project. The .h file is used to generate the .sh file (provided :-)).  The C code will be written with the .h file.
We can now communicate with the card using the PuTTY program.
Finally, we connect the sensor to the DE0 board and we can finally upload the code to the board.


