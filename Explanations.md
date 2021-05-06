## This file contains the explanations of the project

It is organised in 3 main parts :
1. Explain the general structure of the project
2. Explain the configuration of the project for our specific sensor


# General structure

# Configuration 

Our sensor contains a few sensors. Among them, we will only focus on the configuration register and on the temperature register. 

The configuration register will store the parameters of the sensor. We write in this register to configure our sensor. 

The temperature register is only reachable in read mode. We will read the value of the temperature in this register. 
