`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2021 12:48:41
// Design Name: 
// Module Name: memory
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


module memory #(parameter deep = 16) (
    input clk,
    input [$clog2(deep)-1:0] addr,
    input [7:0] data_in,
    output logic [7:0] data_out,
    input rd,
    input wr
    );
    
reg [7:0] mem [1:deep];

always @(posedge clk)
    if(wr)
        mem[addr] <= data_in;
    else if(rd)
        data_out <= mem[addr];
        
endmodule
