#define soc_cv_av

#define DEBUG

#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "soc_cv_av/socal/socal.h"
#include "soc_cv_av/socal/hps.h"
#include "soc_cv_av/socal/alt_gpio.h"
#include "hps_0.h"






#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 ) //64 MB with 32 bit adress space this is 256 MB
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )


//setting for the HPS2FPGA AXI Bridge
#define ALT_AXI_FPGASLVS_OFST (0xC0000000) // axi_master
#define HW_FPGA_AXI_SPAN (0x40000000) // Bridge span 1GB
#define HW_FPGA_AXI_MASK ( HW_FPGA_AXI_SPAN - 1 )





int main() {

	//pointer to the different address spaces

	void *virtual_base;
	void *axi_virtual_base;
	int fd;
	

	//void *h2p_lw_reg1_addr;
	//void *h2p_lw_reg2_addr;
	//void *h2p_lw_reg3_addr;
	
	float temperature;
	
	void *h2p_lw_reg_out_addr;
	void *h2p_lw_reg_out_2_addr;

	//void *h2p_lw_myBus_addr;


	//void *h2p_led_addr; //led via AXI master
	



	// map the address space for the LED registers into user space so we can interact with them.
	// we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span

	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	//lightweight HPS-to-FPGA bridge
	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	//HPS-to-FPGA bridge
	axi_virtual_base = mmap( NULL, HW_FPGA_AXI_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd,ALT_AXI_FPGASLVS_OFST );

	if( axi_virtual_base == MAP_FAILED ) {
		printf( "ERROR: axi mmap() failed...\n" );
		close( fd );
		return( 1 );
	}


//-----------------------------------------------------------
	//configure the LEDs of the Golden Reference design
	printf( "\n\n\n-----------Set the LEDs on-------------\n\n" );

	//LED connected to the HPS-to-FPGA bridge
	//h2p_led_addr=axi_virtual_base + ( ( unsigned long  )( 0x0 + PIO_LED_BASE ) & ( unsigned long)( HW_FPGA_AXI_MASK ) );

	//*(uint32_t *)h2p_led_addr = 0b10111100;

//-----------------------------------------------------------
	//Adder test: Two registers are connected to a adder and place the result in the third register
	printf( "\n\n\n-----------Read temperature from FPGA-------------\n\n" );

	//the address of the two input (reg1 and reg2) registers and the output register (reg3)
	//h2p_lw_reg1_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_REG1_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	//h2p_lw_reg2_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_REG2_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	//h2p_lw_reg3_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_REG3_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	
	h2p_lw_reg_out_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + REG_OUT_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	h2p_lw_reg_out_2_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + REG_OUT_2_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	//Change the first byte to signed????

	//write into register to test the adder
	//*(uint32_t *)h2p_lw_reg1_addr = 10;
	//*(uint32_t *)h2p_lw_reg2_addr = 5;

	//read result of the adder from register 3
	//printf( "Adder result:%d + %d = %d\n", *((uint32_t *)h2p_lw_reg1_addr), *((uint32_t *)h2p_lw_reg2_addr), *((uint32_t *)h2p_lw_reg3_addr) );
	int i;
	for (i=0;i<100;i++){
		printf("register 2 unsigned : %d",*(uint32_t *)h2p_lw_reg_out_2_addr);
		printf("\n");
		printf("register 2 signed : %d",*(int32_t *)h2p_lw_reg_out_2_addr);
		printf("\n");
		
		// Turn into signed int 8 bits	
		temperature = *((int8_t *)h2p_lw_reg_out_addr) + *((uint32_t *)h2p_lw_reg_out_2_addr)*0.00390625;
		
		//Negative values?
		//change the uint in int8
		
		
		printf("Temperature (entier): %d\n", *((int8_t *)h2p_lw_reg_out_addr));
		printf("\n");
		printf("Temperature (précis) : %.4f \n", temperature);
		printf("\n");
	}
	
	

	//Add a sleep pour attendre entre 2 lectures


	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	if( munmap( axi_virtual_base, HW_FPGA_AXI_SPAN ) != 0 ) {
		printf( "ERROR: axi munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	close( fd );

	return( 0 );
}
