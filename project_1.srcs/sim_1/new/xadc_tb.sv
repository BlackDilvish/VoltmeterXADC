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
localparam  ONE_NS      = 1;
integer    count       = 0   ;
localparam time PER1    = 10*ONE_NS;

localparam d = 20, hp = 5, fclk = 100_000_000, br = 230400, size = 8;
localparam ratio = fclk / br - 1;
logic clk, rst, vauxp0, vauxn0;

top #(.mdeep(d)) uut (.clk(clk), .rst(rst), .rx(rx), .tx(tx), .vauxp0(vauxp0), .vauxn0(vauxn0));

initial begin
    clk = 1'b0;
    vauxp0 = 1'b0;
    vauxn0 = 1'b0;
    forever #hp clk = ~clk;
end

initial
begin
  $display ("Timing checks are not valid");
  assign rst = 1'b1;
  #(10*PER1);
  #(100*ONE_NS);
  assign rst = 1'b0;
  #(2*PER1);
  #(10*PER1);
  $display ("Timing checks are valid");
  @(posedge uut.m_axi.eoc);
  @(negedge uut.m_axi.eoc);
  @(posedge uut.m_axi.eoc);
  @(negedge uut.m_axi.eoc);
  @(posedge uut.m_axi.eoc);
  @(negedge uut.m_axi.eoc);
  @(posedge uut.m_axi.rvld_xadc);
  @(negedge uut.m_axi.rvld_xadc);
    $display ("This TB supports CONSTANT Waveform comaprision. User should compare the analog input and digital output for SIN, TRAINGLE, SQUARE waves !!") ;
    $display ("Waiting for Analog Waveform to complete !!") ;
    #(2000000.0);
  $display("SYSTEM_CLOCK_COUNTER : %0d\n",$time/PER1);
  $display ("Test Completed Successfully");
  $finish;
end

reg [11:0] Analog_Wave_Single_Ch;
integer voltage = 0;
integer ascii_voltage = 0;

always @ (posedge clk)
begin
  if (uut.m_axi.rvld_xadc) begin
    Analog_Wave_Single_Ch <= uut.m_axi.rdat_xadc[15:4];
    voltage = transcode(Analog_Wave_Single_Ch);
    ascii_voltage = (voltage>>4)<<4;
    end
end 

function integer transcode(input[11:0] code);
    integer max_voltage = 1000;
    automatic reg [11:0] mask = 12'b1000_0000_0000;
    integer i;
        begin
            transcode = 0;
            for(i = 0; i < 12; i = i + 1)
                if(code & (mask >> i))
                    transcode += max_voltage / (2 ** (i + 1));
        end    
endfunction

endmodule
