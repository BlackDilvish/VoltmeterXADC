
// file: xadc_wiz_0_exdes.v
// (c) Copyright 2009 - 2013 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.

//----------------------------------------------------------------------------
// XADC wizard example design
//----------------------------------------------------------------------------
// This example design instantiates the generated file containing the
// System Monitor instantiation.
//----------------------------------------------------------------------------

`timescale 1ns / 1 ps


module xadc_wiz_0_exdes
   (
    input s_axi_aclk,
    input s_axi_aresetn,
    input [11-1 : 0] s_axi_awaddr,
    input s_axi_awvalid,
    output s_axi_awready,
    input [32-1 : 0] s_axi_wdata,
    input [(32/8)-1 : 0] s_axi_wstrb,
    input s_axi_wvalid,
    output s_axi_wready,
    output [1 : 0] s_axi_bresp,
    output s_axi_bvalid,
    input s_axi_bready,
    input [11-1 : 0] s_axi_araddr,
    input s_axi_arvalid,
    output s_axi_arready,
    output [32-1 : 0] s_axi_rdata,
    output [1 : 0] s_axi_rresp,
    output s_axi_rvalid,
    input s_axi_rready,
    output ip2intc_irpt,
    output [4:0] channel_out,
    output busy_out,        
    output eoc_out,
    output eos_out,
    output ot_out, 
    output vccddro_alarm_out,
    output vccpaux_alarm_out,
    output vccpint_alarm_out,
    output vccaux_alarm_out,
    output vccint_alarm_out,
    output user_temp_alarm_out,
    output alarm_out ,                                          
    input vp_in,                                               
    input vn_in
);

   wire GND_BIT;

   reg rst_sync;
   reg rst_sync_int;
   reg rst_sync_int1;
   reg rst_sync_int2;

   assign GND_BIT = 0;

     always @(negedge s_axi_aresetn or posedge s_axi_aclk) begin
       if (!s_axi_aresetn) begin
            rst_sync <= 1'b0;
            rst_sync_int <= 1'b0;
            rst_sync_int1 <= 1'b0;
            rst_sync_int2 <= 1'b0;
       end
       else begin
            rst_sync <= 1'b1;
            rst_sync_int <= rst_sync;     
            rst_sync_int1 <= rst_sync_int; 
            rst_sync_int2 <= rst_sync_int1;
       end
    end



xadc_wiz_0
xadc_wiz_inst (
    .s_axi_aclk      (s_axi_aclk),                    
    .s_axi_aresetn   (rst_sync_int2),                    
    .s_axi_awaddr    (s_axi_awaddr),                    
    .s_axi_awvalid   (s_axi_awvalid),                    
    .s_axi_awready   (s_axi_awready),                    
    .s_axi_wdata     (s_axi_wdata),                    
    .s_axi_wstrb     (s_axi_wstrb),                    
    .s_axi_wvalid    (s_axi_wvalid),                    
    .s_axi_wready    (s_axi_wready),                    
    .s_axi_bresp     (s_axi_bresp),                    
    .s_axi_bvalid    (s_axi_bvalid),                    
    .s_axi_bready    (s_axi_bready),                    
    .s_axi_araddr    (s_axi_araddr),                    
    .s_axi_arvalid   (s_axi_arvalid),                    
    .s_axi_arready   (s_axi_arready),                    
    .s_axi_rdata     (s_axi_rdata),                    
    .s_axi_rresp     (s_axi_rresp),                    
    .s_axi_rvalid    (s_axi_rvalid),                    
    .s_axi_rready    (s_axi_rready),                    
    .ip2intc_irpt    (ip2intc_irpt),  
    .channel_out(channel_out),
    .busy_out(busy_out), 
    .eoc_out(eoc_out), 
    .eos_out(eos_out),
    .ot_out(ot_out),
 
    .vccpaux_alarm_out(vccpaux_alarm_out),
 
    .vccddro_alarm_out(vccddro_alarm_out),
 
    .vccpint_alarm_out(vccpint_alarm_out),
 
    .vccaux_alarm_out(vccaux_alarm_out),
    .vccint_alarm_out(vccint_alarm_out),
    .user_temp_alarm_out(user_temp_alarm_out),
    .alarm_out  (alarm_out),
    .vp_in (vp_in),
    .vn_in (vn_in)
      );
endmodule
