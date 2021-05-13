vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vcom -work xil_defaultlib  -93 \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_conv_funs_pkg.vhd" \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_proc_common_pkg.vhd" \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_ipif_pkg.vhd" \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_family_support.vhd" \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_family.vhd" \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_soft_reset.vhd" \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/proc_common_v3_30_a/hdl/src/vhdl/xadc_wiz_0_pselect_f.vhd" \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/axi_lite_ipif_v1_01_a/hdl/src/vhdl/xadc_wiz_0_address_decoder.vhd" \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/axi_lite_ipif_v1_01_a/hdl/src/vhdl/xadc_wiz_0_slave_attachment.vhd" \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/interrupt_control_v2_01_a/hdl/src/vhdl/xadc_wiz_0_interrupt_control.vhd" \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/axi_lite_ipif_v1_01_a/hdl/src/vhdl/xadc_wiz_0_axi_lite_ipif.vhd" \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/xadc_wiz_0_xadc_core_drp.vhd" \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/xadc_wiz_0_axi_xadc.vhd" \

vlog -work xil_defaultlib  -incr \
"../../../../project_1.gen/sources_1/ip/xadc_wiz_0/xadc_wiz_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

