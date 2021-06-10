`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2021 12:00:13
// Design Name: 
// Module Name: tb
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


module tb();
localparam d = 20, hp = 5, fclk = 100_000_000, br = 230400, size = 8;
localparam ratio = fclk / br - 1;
logic clk, rst, strt, strr, vauxp0, vauxn0;
wire fint, finr;
integer index;

top #(.mdeep(d)) uut (.clk(clk), .rst(rst), .rx(rx), .tx(tx), .vauxp0(vauxp0), .vauxn0(vauxn0));
//simple_reciver
simple_receiver #(.fclk(fclk), .baudrate(br), .nb(size), .deep(d)) receiver
    (.clk(clk), .rst(rst), .str(strr), .rx(tx), .fin(finr));

simple_transmitter #(.nb(size), .deep(d), .ratio(ratio)) transmitter
    (.clk(clk), .rst(rst), .str(strt), .trn(rx), .fin(fint));
//simple_transmitter

initial begin
    clk = 1'b0;
    forever #hp clk = ~clk;
end

initial begin
    rst = 1'b0;
    #1 rst = 1'b1;
    repeat (5) @(posedge clk);
    #2 rst = 1'b0;
end

initial begin
    strt = 1'b0;
    strr = 1'b0;
    @(negedge rst);
    repeat(ratio/8) @(posedge clk);
    strt = 1'b1;
    $display("Start sending at: %t ns", $time);
    @(negedge clk);
    strt = 1'b0;
    repeat(d) @(negedge fint);
    strr = 1'b1;
    repeat(2) @(negedge clk);
    strr = 1'b0;
end

initial begin
    @(negedge strt);
    repeat(d) @(negedge fint);
    $display("Received by FPGA: %h", uut.storage.mem);
    $display("Send by UART model: %h", transmitter.tr_mem);
    repeat(d) @(negedge finr);
    $display("Received by UART model: %h", receiver.rec_mem);    

    for(index = 1; index < 21; index = index + 1) begin
        $display(receiver.rec_mem[index] * 16);
    end
    
    #1000 $finish();
end

endmodule
