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

# ----------------------------------------------------------------------------
# XADC AD Channels - Bank 35
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN E16 [get_ports {vauxn0}];  # "XADC-AD0N-R"
set_property PACKAGE_PIN F16 [get_ports {vauxp0}];  # "XADC-AD0P-R"

# ----------------------------------------------------------------------------
# User LEDs - Bank 33
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN T22 [get_ports {data_out[0]}];  # "LD0"
set_property PACKAGE_PIN T21 [get_ports {data_out[1]}];  # "LD1"
set_property PACKAGE_PIN U22 [get_ports {data_out[2]}];  # "LD2"
set_property PACKAGE_PIN U21 [get_ports {data_out[3]}];  # "LD3"
set_property PACKAGE_PIN V22 [get_ports {data_out[4]}];  # "LD4"
set_property PACKAGE_PIN W22 [get_ports {data_out[5]}];  # "LD5"
set_property PACKAGE_PIN U19 [get_ports {data_out[6]}];  # "LD6"
set_property PACKAGE_PIN U14 [get_ports {data_out[7]}];  # "LD7"

set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];


