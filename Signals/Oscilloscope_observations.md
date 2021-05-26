This file contains the pictures of the signals we observed on an oscilloscope.

## Test signals
In our FPGA code, we created a low level signal and a high level signal to ensure these signals leave the chip. The 2 following pictures show that the signals (0 and 5V) are present at the output of the chip.

### Low level 
<img src="https://user-images.githubusercontent.com/81489863/119663311-89888580-be32-11eb-8742-2c3c1f86554b.png" data-canonical-src="https://user-images.githubusercontent.com/81489863/119663311-89888580-be32-11eb-8742-2c3c1f86554b.png" width="500"  />

### High level 
<img src="https://user-images.githubusercontent.com/81489863/119663480-aae97180-be32-11eb-9efa-1164bc2a7aa9.png"  width="500"  />


## Observation of SCL and SDA
We faced problems when we observed the SDA and SCL signals which are the signals connecting the sensor to the FPGA. 

We observed an SDA at 5V. This may not be a problem because if the communication is a rest, SDA shouldn't change.
<img src="https://user-images.githubusercontent.com/81489863/119663691-dcfad380-be32-11eb-9bbc-e569fd9c7e27.png"  width="500"  />


We observed a steady clock at 1V. This is obviously a problem. The clock should only be at 0 or 5V but no intermediate value should be observed. 

<img src="https://user-images.githubusercontent.com/81489863/119663745-edab4980-be32-11eb-9859-dbcfda6724a2.png"  width="500"  />

