`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2021 11:36:45
// Design Name: 
// Module Name: simple_receiver
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


module simple_receiver #(parameter fclk = 100_000_000, baudrate = 230400, nb = 8, deep = 20) (input clk, rst, str, rx, output logic fin);

localparam ratio = calc_ratio(fclk, baudrate);
localparam bcntl = $clog2(nb);

reg [nb-1:0] rec_mem [1:deep];
logic strr, en16x, div;
logic [1:0] fedr; //[2:0]
logic [3:0] cnt16;
logic [bcntl:0] cnt8;

integer cnt, a;
logic [nb-1:0] receiver_reg;

//detect first falling edge
always @(posedge clk, posedge rst)
    if(rst)
        fedr <= 2'b0;
    else if(~str)
        fedr <= {fedr[0], rx};
always @(posedge clk, posedge rst)
    if(rst)
        strr <= 1'b0;
    else if(fedr[1] & ~fedr[0])
        strr <= 1'b1;

//clock divider by ratio
function integer calc_ratio (input integer fclk, baudrate);
integer brate_mult16_div2, reminder, ratio;
    begin
        brate_mult16_div2 = 8*baudrate;
        reminder = fclk % (16 * baudrate);
        ratio = fclk / (16 * baudrate);
        if (brate_mult16_div2 < reminder)
            calc_ratio = ratio+1;
        else
            calc_ratio = ratio;
    end
endfunction

always @(posedge clk, posedge rst)
    if(rst) begin
        cnt <= 0;
        en16x <= 1'b0;
    end else if(strr)
        if (cnt == 0) begin
            cnt <= ratio - 1;
            en16x <= 1'b1;
        end else begin
            cnt <= cnt - 1; 
            en16x <= 1'b0;
        end
 
//clock divider by ratio
always @(posedge clk, posedge rst)
    if (rst) begin
        cnt16 <= 4'b0;
        div <= 1'b0;
    end
    else if(strr & en16x)
        if(cnt16 == 4'hf) begin
            cnt16 <= 4'h0;
            div <= 1'b1;
        end else begin
            cnt16 <= cnt16 + 1'b1;
            div <= 1'b0;
        end
        
//shift register
always @(posedge div, posedge rst)
    if(rst)
        receiver_reg <= {nb{1'b0}};
    else
        receiver_reg <= {rx, receiver_reg[nb-1:1]};

//bitcounter
always @(posedge div, posedge rst)
    if(rst)
        cnt8 <= {(bcntl+1){1'b0}};
    else if (cnt8 == 9)
        cnt8 <= {(bcntl+1){1'b0}};
    else if(strr)
        cnt8 <= cnt8 + 1;
 
//transaction finish flag
always @(posedge clk, posedge rst)
    if (rst)
        fin <= 1'b0;
    else if((cnt8 == 4'h9) & strr)
        fin <= 1'b1;
    else
        fin <= 1'b0;

//memory for received data
always @(posedge clk, posedge rst)
    if (rst)
        a = deep;
    else if(div & en16x & fin)
        rec_mem[a--] = receiver_reg;
    
     
        
endmodule

