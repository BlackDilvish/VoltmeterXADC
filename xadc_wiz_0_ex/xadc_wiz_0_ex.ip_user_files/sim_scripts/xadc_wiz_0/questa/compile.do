vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vcom -work xil_defaultlib  -93 \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_conv_funs_pkg.vhd" \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_proc_common_pkg.vhd" \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_ipif_pkg.vhd" \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_family_support.vhd" \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_family.vhd" \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_soft_reset.vhd" \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_pselect_f.vhd" \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/axi_lite_ipif_v1_01_a/hdl/src/vhdl/xadc_wiz_0_address_decoder.vhd" \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/axi_lite_ipif_v1_01_a/hdl/src/vhdl/xadc_wiz_0_slave_attachment.vhd" \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/interrupt_control_v2_01_a/hdl/src/vhdl/xadc_wiz_0_interrupt_control.vhd" \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/axi_lite_ipif_v1_01_a/hdl/src/vhdl/xadc_wiz_0_axi_lite_ipif.vhd" \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/xadc_wiz_0_xadc_core_drp.vhd" \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/xadc_wiz_0_axi_xadc.vhd" \

vlog -work xil_defaultlib  \
"../../../../xadc_wiz_0_ex.gen/sources_1/ip/xadc_wiz_0/xadc_wiz_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

