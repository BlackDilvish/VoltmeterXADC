
// file: xadc_wiz_0_tb.v
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
// XADC Monitor wizard demonstration testbench
//----------------------------------------------------------------------------
// This demonstration testbench instantiates the example design for the 
// XADC wizard. Input clock is generated in this testbench.
//----------------------------------------------------------------------------
// Bipolar signals are applied with Vn = 0

`timescale 1ps/1ps
`define wait_eoc @(negedge EOC_TB)
`define wait_eoc_p @(posedge EOC_TB)
`define wait_eos @(posedge EOS_TB)
`define wait_rvalid @(posedge s_axi_rvalid)
`define wait_rvalid_n @(negedge s_axi_rvalid)
`define wait_done @(posedge BUSY_TB)
`define wait_busy @(negedge BUSY_TB)
module xadc_wiz_0_tb ();

  // timescale is 1ps/1ps
  localparam  ONE_NS      = 1000;
   integer    count       = 0   ;
  localparam time PER1    = 10*ONE_NS;
  // Declare the input clock signals
  reg         s_axi_aclk     = 0;
  reg         s_axi_aclk_tb  = 0;

reg s_axi_aresetn;
reg [10:0] s_axi_awaddr;
reg [31:0] s_axi_wdata;
reg [3:0] s_axi_wstrb;
reg s_axi_wvalid;
reg s_axi_awvalid;
reg s_axi_bready = 1'b1;
reg [10:0] s_axi_araddr;
reg s_axi_arvalid;
reg s_axi_rready = 1'b1;
wire s_axi_awready;
wire s_axi_wready;
wire [1:0] s_axi_bresp;
wire s_axi_bvalid;
wire s_axi_arready;
wire [31:0] s_axi_rdata;
wire [1:0] s_axi_rresp;
wire s_axi_rvalid;
wire ip2intc_irpt;
  wire ALARM_OUT_TB;
  wire VCCAUX_ALARM_TB;
  wire VCCINT_ALARM_TB;
  wire VCCPAUX_ALARM_TB;
  wire VCCPINT_ALARM_TB;
  wire VCCDDRO_ALARM_TB;
  wire USER_TEMP_ALARM_TB;
  wire BUSY_TB;
  wire [4:0] CHANNEL_TB;
  wire OT_TB;
  wire EOC_TB;
  wire EOS_TB;

// Input clock generation

always begin
  s_axi_aclk = #(PER1/2) ~s_axi_aclk;
end

always begin
  s_axi_aclk_tb = #10 s_axi_aclk;
end




always @(posedge s_axi_aclk or negedge s_axi_aresetn)
begin
  if (!s_axi_aresetn) begin
   s_axi_awaddr = 11'b00000000000; //{5'b00, CHANNEL_TB};
   s_axi_araddr = 11'b00000000000; //{5'b00, CHANNEL_TB};
   s_axi_wdata = 32'h00000000;
   s_axi_wstrb = 4'h0;
   s_axi_arvalid = 1'b0; 
   s_axi_awvalid = 1'b0;
   s_axi_wvalid = 1'b0;
  end
  else begin
   s_axi_awaddr = {4'b0100, CHANNEL_TB, 2'b00};
   s_axi_araddr = {4'b0100, CHANNEL_TB, 2'b00};
   s_axi_wdata = 32'h0000b5ed;
   s_axi_wstrb = 4'hF;
   s_axi_awvalid = 1'b0; 
   s_axi_wvalid = 1'b0;
   if (EOC_TB == 1'b1)  
     s_axi_arvalid <= 1'b1;
   else if (s_axi_arready == 1'b1) 
     s_axi_arvalid <= 1'b0;
  end
end
initial
begin
  $display ("Timing checks are not valid");
  assign s_axi_aresetn = 1'b0;
  #(10*PER1);
  #(100*ONE_NS);
  assign s_axi_aresetn = 1'b1;
  #(2*PER1);
  #(10*PER1);
  $display ("Timing checks are valid");
   `wait_eoc_p;
   `wait_eoc;
   `wait_eoc_p;
   `wait_eoc;
   `wait_eoc_p;
   `wait_eoc;
   `wait_rvalid; 
   `wait_rvalid_n; 
    $display ("This TB supports CONSTANT Waveform comaprision. User should compare the analog input and digital output for SIN, TRAINGLE, SQUARE waves !!") ;
    $display ("Waiting for Analog Waveform to complete !!") ;
    #(1000480000.0);
  $display("SYSTEM_CLOCK_COUNTER : %0d\n",$time/PER1);
  $display ("Test Completed Successfully");
  $finish;
end


// Start of the testbench





reg IF_RD_CNT = 1'b0;




reg [11:0] Analog_Wave_Single_Ch;

always @ (posedge s_axi_aclk)
begin
  if (s_axi_rvalid)
    Analog_Wave_Single_Ch <= s_axi_rdata[15:4];
end   

  // Instantiation of the example design
  //---------------------------------------------------------
  xadc_wiz_0_exdes dut (
     .s_axi_aclk      (s_axi_aclk_tb),                    
     .s_axi_aresetn   (s_axi_aresetn),                    
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
     .vccaux_alarm_out(VCCAUX_ALARM_TB),
     .vccint_alarm_out(VCCINT_ALARM_TB),
     .vccpaux_alarm_out(VCCPAUX_ALARM_TB),
     .vccpint_alarm_out(VCCPINT_ALARM_TB),
     .vccddro_alarm_out(VCCDDRO_ALARM_TB),
     .user_temp_alarm_out(USER_TEMP_ALARM_TB),
     .busy_out(BUSY_TB),
     .channel_out(CHANNEL_TB[4:0]),
     .eoc_out(EOC_TB),
     .eos_out(EOS_TB),
     .ot_out(OT_TB),
     .alarm_out(ALARM_OUT_TB),
     .vp_in(1'b0),
     .vn_in(1'b0)

         );

endmodule



