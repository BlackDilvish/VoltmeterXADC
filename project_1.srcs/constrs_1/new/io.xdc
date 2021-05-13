# ----------------------------------------------------------------------------
# Clock Source - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN Y9 [get_ports {clk}];  # "GCLK"

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN R16 [get_ports {rst}];  # "BTND"

# ----------------------------------------------------------------------------
# JB Pmod - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN V10 [get_ports {tx}];  # "JB3"
set_property PACKAGE_PIN W8 [get_ports {rx}];  # "JB4"

#set_property PACKAGE_PIN T22 [get_ports {led0}];  # "LD0"
#set_property PACKAGE_PIN T21 [get_ports {led7}];  # "LD1"

#set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];


