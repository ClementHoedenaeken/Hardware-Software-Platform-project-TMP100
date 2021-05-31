# Hardware_Software_Platform_project_TMP100
Repository containing all the explanations and codes of the project of the course of Hardware/Software Platforms. 

Hi! 👋
We are two students of the Faculty of Engineering of the university of Mons 🇧🇪 ([UMONS](https://web.umons.ac.be/en/)). We are currently (2020-2021) in the 1st year of our  *master's degree in Electrical Engineering, Specialist Focus on Electrical Energy*. 



For our course of *Hardware/Software Platforms* we have to implement the interface between a sensor and a computer through an FPGA. This repository contain a file called [*Explanations*](https://github.com/ClementHoedenaeken/Hardware-Software-Platform-project-TMP100/blob/main/Explanations.md) where we placed a lots of information explaining our work 📚. We added in this file a tutorial helping you to reproduce our prototype. 

We choosed a temperature sensor 🌡️ which will be connected to an FPGA through an **I²C** bus. The FPGA is charged to place the temperature value in 2 registers that can be read by the ARM processor on the chip. This processor is charged to read the registers and print the value of the temperature on the screen of the computer via a serial port. 

Here is the **table of content** of this repository. 
* The detailled explanations are in the [Explanations.md](https://github.com/ClementHoedenaeken/Hardware-Software-Platform-project-TMP100/blob/main/Explanations.md) file.
* The main files of the FPGA programming can be found in the [Hardware Files](https://github.com/ClementHoedenaeken/Hardware-Software-Platform-project-TMP100/tree/main/Hardware%20Files) folder. 
* The main files for programming the chip can be found in the [Software Files](https://github.com/ClementHoedenaeken/Hardware-Software-Platform-project-TMP100/tree/main/Software%20Files) folder. 
* The datasheet of the sensor and a file containing the signals we should provide to drive it can be found in [this folder](https://github.com/ClementHoedenaeken/Hardware-Software-Platform-project-TMP100/tree/main/Datasheet%20and%20signals%20of%20TMP_100).
* The signals we observed on the testbench and on the oscilloscope can be found in the [Signals folder](https://github.com/ClementHoedenaeken/Hardware-Software-Platform-project-TMP100/tree/main/Signals).
* A [video](https://github.com/ClementHoedenaeken/Hardware-Software-Platform-project-TMP100/blob/main/IMG_3223.MOV) of the project is also placed in this repository.
* The archive of the Quartus project can be downloaded [here](https://github.com/ClementHoedenaeken/Hardware-Software-Platform-project-TMP100/blob/main/soc_system.qar).


Feel free to contact us 📧 for more explanations about this project :
*  clementhoedenaeken@student.umons.ac.be  🇧🇪
*  Doha.NAJI@student.umons.ac.be 🇧🇪
