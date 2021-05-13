`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2021 12:14:13
// Design Name: 
// Module Name: simple_transmitter
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


module simple_transmitter #(parameter nb = 8, deep = 20, ratio = 1) (
    input clk, rst, str,
    output trn,
    output fin
    );
    
typedef enum {idle, start, data, stop} state_e;
state_e st, nst;
    
logic [nb-1:0] val;
localparam bcntlen = $clog2(nb);
logic [bcntlen:0] bitcnt;
integer inx, cnt;
reg [nb-1:0] tr_mem [1:deep];
initial $readmemh("tr_init.mem", tr_mem);

always @(posedge clk, posedge rst)
    if (rst) begin
        val = 8'b0;
        inx = 0;
    end
    else if (str | fin) begin
        inx++;
        val = tr_mem[inx];
        if (inx == deep) inx++;
    end
     
wire new_bit = (cnt == ratio);
assign fin = new_bit & (st ==stop);
always @(posedge clk, posedge rst)
    if (rst)
        cnt <= ratio;
    else if (st != idle)
        if(cnt == 0)    
            cnt <= ratio;
        else
            cnt <= cnt - 1'b1;

logic oper;  
always @(posedge clk, posedge rst)
    if (rst)
        oper <= 1'b0;
    else if(str)
        oper <= 1'b1;
    else if(fin & (inx == deep + 2))
        oper <= 1'b0;
             
always @(posedge clk, posedge rst)
    if (rst)
        st <= idle;
    else
        st <= nst;
    
always_comb begin
    nst = idle;
    case(st)
        idle: nst = oper ? start : idle;
        start: nst = new_bit ? data : start;
        data: nst = (bitcnt == 9) ? stop : data;
        stop: nst = new_bit ? idle : stop;
    endcase
end
            
logic [nb+1:0] trans_reg;
assign trn = (st == data) ? trans_reg[0] : 1'b1;
always @(posedge clk, posedge rst)
    if (rst)
        trans_reg <= {(nb+2){1'b1}};
    else if ((st == idle) & (bitcnt == 0))   
        trans_reg <= {1'b1, val, 1'b0};
    else if ((st == data) & new_bit)   
        trans_reg <= {1'b1, trans_reg[nb+1:1]}; 
    else if (fin)
        trans_reg <= {(nb+2){1'b1}};
            
always @(posedge clk, posedge rst)
    if (rst)
        bitcnt <= {(bcntlen + 1) {1'b0}};
    else if(oper & (bitcnt == 9))
        bitcnt <= {(bcntlen + 1) {1'b0}};
    else if(oper & new_bit & (st == data))
        bitcnt <= bitcnt + 1'b1;
   
endmodule
