`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2021 13:20:24
// Design Name: 
// Module Name: xadc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module xadc_tb();

// timescale is 1ps/1ps
localparam  ONE_NS      = 1000;
integer    count       = 0   ;
localparam time PER1    = 10*ONE_NS;
// Declare the input clock signals
reg         s_axi_aclk     = 0;
reg         s_axi_aclk_tb  = 0;

localparam d = 20, hp = 5, fclk = 100_000_000, br = 230400, size = 8;
localparam ratio = fclk / br - 1;
logic clk, rst;

top #(.mdeep(d)) uut (.clk(clk), .rst(rst), .rx(rx), .tx(tx));

initial begin
    clk = 1'b0;
    forever #hp clk = ~clk;
end

/*
// Input clock generation

always begin
  s_axi_aclk = #(PER1/2) ~s_axi_aclk;
end

always begin
  s_axi_aclk_tb = #10 s_axi_aclk;
end*/

/*initial begin
    rst = 1'b0;
    #1 rst = 1'b1;
    repeat (5) @(posedge clk);
    #2 rst = 1'b0;
end*/

initial
begin
  $display ("Timing checks are not valid");
  #1 rst = 1'b1;
  #(10*PER1);
  #(100*ONE_NS);
  #1 rst = 1'b0;
  #(2*PER1);
  #(10*PER1);
  $display ("Timing checks are valid");
  @(posedge uut.m_axi.eoc);
  @(negedge uut.m_axi.eoc);
  @(posedge uut.m_axi.eoc);
  @(negedge uut.m_axi.eoc);
  @(posedge uut.m_axi.eoc);
  @(negedge uut.m_axi.eoc);
  @(posedge uut.m_axi.arvld_xadc);
  @(negedge uut.m_axi.arvld_xadc);
    $display ("This TB supports CONSTANT Waveform comaprision. User should compare the analog input and digital output for SIN, TRAINGLE, SQUARE waves !!") ;
    $display ("Waiting for Analog Waveform to complete !!") ;
    #(1000480000.0);
  $display("SYSTEM_CLOCK_COUNTER : %0d\n",$time/PER1);
  $display ("Test Completed Successfully");
  $finish;
end

reg [11:0] Analog_Wave_Single_Ch;

always @ (posedge s_axi_aclk)
begin
  if (uut.m_axi.rvld_xadc)
    Analog_Wave_Single_Ch <= uut.m_axi.rdat_xadc[15:4];
end 

endmodule
