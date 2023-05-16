## Generated SDC file "sdr_test.sdc"

## Copyright (C) 1991-2011 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 11.1 Build 259 01/25/2012 Service Pack 2 SJ Full Version"

## DATE    "Tue Sep 10 17:22:46 2013"

##
## DEVICE  "EP4CE6E22C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {SYSCLK} -period 20.000 -waveform { 0.000 0.500 } [get_ports {SYSCLK}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]} -source [get_pins {I_PLL|I_PLL_CTL|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -master_clock {SYSCLK} [get_pins {I_PLL|I_PLL_CTL|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]} -source [get_pins {I_PLL|I_PLL_CTL|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -master_clock {SYSCLK} [get_pins {I_PLL|I_PLL_CTL|altpll_component|auto_generated|pll1|clk[1]}] 
create_generated_clock -name {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[2]} -source [get_pins {I_PLL|I_PLL_CTL|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -phase 340.0 -master_clock {SYSCLK} [get_pins {I_PLL|I_PLL_CTL|altpll_component|auto_generated|pll1|clk[2]}] 
create_generated_clock -name {SDRAM_CLK} -source [get_nets {I_PLL|I_PLL_CTL|altpll_component|auto_generated|wire_pll1_clk[2]}] -master_clock {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[2]} [get_ports {SDRAM_CLK}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {SYSCLK}] -rise_to [get_clocks {SYSCLK}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SYSCLK}] -fall_to [get_clocks {SYSCLK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SYSCLK}] -rise_to [get_clocks {SYSCLK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SYSCLK}] -fall_to [get_clocks {SYSCLK}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}] -rise_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}] -fall_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}] -rise_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}] -fall_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}] -rise_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}] -fall_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}] -rise_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}] -fall_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}] -rise_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}] -fall_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}] -rise_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}] -fall_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}] -rise_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}] -fall_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}] -rise_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}] -fall_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  

set_clock_uncertainty -rise_from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}] -rise_to [get_clocks {SDRAM_CLK}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SDRAM_CLK}] -rise_to [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}]  0.020  






#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[0]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[0]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[1]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[1]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[2]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[2]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[3]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[3]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[4]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[4]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[5]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[5]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[6]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[6]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[7]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[7]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[8]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[8]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[9]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[9]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[10]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[10]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[11]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[11]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[12]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[12]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[13]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[13]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[14]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[14]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  6.500 [get_ports {SDRAM_DATA[15]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  4.200 [get_ports {SDRAM_DATA[15]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_ADDR[0]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_ADDR[0]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_ADDR[1]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_ADDR[1]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_ADDR[2]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_ADDR[2]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_ADDR[3]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_ADDR[3]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_ADDR[4]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_ADDR[4]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_ADDR[5]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_ADDR[5]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_ADDR[6]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_ADDR[6]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_ADDR[7]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_ADDR[7]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_ADDR[8]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_ADDR[8]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_ADDR[9]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_ADDR[9]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_ADDR[10]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_ADDR[10]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_ADDR[11]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_ADDR[11]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_BA[0]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_BA[0]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_BA[1]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_BA[1]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_CAS}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_CAS}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_CKE}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_CKE}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_CS}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_CS}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[0]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[0]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[1]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[1]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[2]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[2]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[3]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[3]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[4]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[4]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[5]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[5]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[6]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[6]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[7]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[7]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[8]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[8]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[9]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[9]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[10]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[10]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[11]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[11]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[12]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[12]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[13]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[13]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[14]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[14]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_DATA[15]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_DATA[15]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_LDQM}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_LDQM}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_RAS}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_RAS}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_UDQM}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_UDQM}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  2.600 [get_ports {SDRAM_WE}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  -1.100 [get_ports {SDRAM_WE}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_f09:dffpipe8|dffe9a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_e09:dffpipe5|dffe6a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_b09:dffpipe16|dffe17a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_a09:dffpipe12|dffe13a*}]
set_false_path -from [get_ports {SDRAM_CKE RST_N}] 


#**************************************************************
# Set Multicycle Path
#**************************************************************

set_multicycle_path -setup -end -from  [get_clocks {SDRAM_CLK}]  -to  [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[1]}] 2

#**************************************************************
# Set Maximum Delay
#**************************************************************

set_max_delay -from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[2]}] -to [get_ports {SDRAM_CLK}] 3.000


#**************************************************************
# Set Minimum Delay
#**************************************************************

set_min_delay -from [get_clocks {PLL:I_PLL|I_PLL_CTL:I_PLL_CTL|altpll:altpll_component|I_PLL_CTL_altpll:auto_generated|wire_pll1_clk[2]}] -to [get_ports {SDRAM_CLK}] 0.000


#**************************************************************
# Set Input Transition
#**************************************************************

