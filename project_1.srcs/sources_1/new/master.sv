`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2021 12:33:26
// Design Name: 
// Module Name: master
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


module master #(parameter deep = 16, nb = $clog2(deep))(
    input clk, rst,
    output logic [10:0] wadr_xadc, output logic [3:0] wadr, output logic awvld, input awrdy,
    output [31:0] wdat, output logic wvld, input wrdy,
    input [1:0] brsp, input bvld, output logic brdy,
    output logic [10:0] radr_xadc, output logic [3:0] radr, output logic arvld, input arrdy,
    input [31:0] rdat, input rvld, output logic rrdy,
    output logic [nb-1:0] addr, input [7:0] data_tr, output logic [7:0] data_rec,
    output logic rd, wr,
    input [31:0] rdat_xadc,
    input bvld_xadc,
    input rvld_xadc,
    input awrdy_xadc,
    input arrdy_xadc,
    input [1:0] brsp_xadc,
    input wrdy_xadc,
    input [4:0] channel_out,
    input eoc,
    output logic [31:0] wdat_xadc,
    output logic [3:0] wstrb_xadc,
    output logic awvld_xadc,
    output logic wvld_xadc,
    output logic arvld_xadc,
    output reg [7:0] data_out
    );

typedef enum {readstatus, waitstatus, read, waitread, write, waitwrite, waitresp, clear} states_e;
states_e st, nst;

wire addr0 = (addr ==  {nb{1'b0}});
wire rfifo_valid = (st == waitstatus & rvld) ? rdat[0] : 1'b0;
wire tfifo_full = (st == waitstatus & rvld) ? rdat[3] : 1'b0;
logic rec_trn;
wire inca = ((st == waitread) & rvld & rec_trn);
wire deca = ((st == waitwrite) & awrdy & ~rec_trn); //wrdy

always @(posedge clk, posedge rst)
    if(rst)
        rec_trn <= 1'b1;
    else if(addr == deep)
        rec_trn <= 1'b0;
    else if(st == clear)
        rec_trn <= 1'b1;
        
always @(posedge clk, posedge rst)
begin
  if (rst) begin
   wadr_xadc <= 11'b00000000000; //{5'b00, CHANNEL_TB};
   radr_xadc <= 11'b00000000000; //{5'b00, CHANNEL_TB};
   wdat_xadc <= 32'h00000000;
   wstrb_xadc <= 4'h0;
   arvld_xadc <= 1'b0; 
   awvld_xadc <= 1'b0;
   wvld_xadc <= 1'b0;
  end
  else begin
   wadr_xadc <= {4'b0100, channel_out, 2'b00};
   radr_xadc <= {4'b0100, channel_out, 2'b00};
   wdat_xadc <= 32'h0000b5ed;
   wstrb_xadc <= 4'hF;
   awvld_xadc <= 1'b0; 
   wvld_xadc <= 1'b0;
   if (eoc == 1'b1)  
     arvld_xadc <= 1'b1;
   else if (arrdy_xadc == 1'b1) 
     arvld_xadc <= 1'b0;
  end
end
    
always @(posedge clk, posedge rst)
    if (rst)
        data_out <= {8{1'b0}};
    else if (rvld_xadc)
        data_out <= rdat_xadc[15:8];
        
    
always @(posedge clk, posedge rst)
    if(rst)
        st <= readstatus;
    else //if(addr == deep)
        st <= nst;

always_comb begin
    nst = readstatus;
    case(st)
        readstatus: nst = waitstatus;
        waitstatus: if(rec_trn)
                        nst = rfifo_valid ? (rvld ? read : waitstatus) : readstatus;
                    else
                        nst = tfifo_full ? readstatus : (rvld ? write : waitstatus);
        read: nst = waitread;
        waitread: nst = rvld ? readstatus : waitread;
        write: nst = waitwrite;
        waitwrite: nst = awrdy ? waitresp : waitwrite;
        waitresp: nst = bvld ?addr0 ?clear : readstatus : waitresp;
        clear: nst = readstatus;
     endcase
end
   
    
always @(posedge clk, posedge rst)
    if(rst)
        addr <= {nb{1'b0}};
    else if(inca)
        addr <= addr + 1;
    else if(deca)
        addr <= addr - 1;
    else if (st == clear)
        addr <= {nb{1'b0}};

//Receiver control
//-------------------------------------------------------
//channel AR
always @(posedge clk, posedge rst)
    if(rst)  
        radr <= 4'b0;
    else if (st == readstatus)
        radr <= 4'h8;
    else if (st == read)
        radr <= 4'h0;   
always @(posedge clk, posedge rst)
    if(rst)         
        arvld <= 1'b0;
    else if(st == read | st == readstatus)
        arvld <= 1'b1;
    else if(arrdy)
        arvld <= 1'b0;
        
//channel R
always @(posedge clk, posedge rst)
    if(rst)        
        rrdy <= 1'b0;
    else if((st == waitstatus | st == waitread) & rvld)
        rrdy <= 1'b1;  
    else //if(st == read | st == readstatus)
        rrdy <= 1'b0;  
always @(posedge clk, posedge rst)
    if(rst)
        data_rec <= 8'b0;
    else if (inca)
        data_rec <= (transcode(rdat_xadc[15:4]));//rdat[7:0];
//memory write 
always @(posedge clk)   //, posedge rst)
    if(rst)
        wr <= 1'b0;
    else 
        wr <= inca;

//Transmitter control       
//-------------------------------------------------------
//channel AW
always @(posedge clk, posedge rst)
    if(rst)  
        wadr <= 4'b0;
    else if (st == write | st == waitwrite)
        wadr <= 4'h4;
    else
        wadr <= 4'b0;
always @(posedge clk, posedge rst)
    if(rst)         
        awvld <= 1'b0;
    else begin
        if(st == waitwrite)
            awvld <= 1'b1;
        if(awrdy)
            awvld <= 1'b0; 
        end        

//channel W
always @(posedge clk, posedge rst)
    if(rst)         
        wvld <= 1'b0;
    else begin
        if(st == waitwrite)
            wvld <= 1'b1;
        if(awrdy)
            wvld <= 1'b0; 
        end
assign wdat = (st == waitwrite)?{24'b0, data_tr}:32'b0;

//channel B
always @(posedge clk, posedge rst)
    if(rst)        
        brdy <= 1'b0;
    else begin
        if (st == write)
            brdy <= 1'b1;  
        if (bvld)
            brdy <= 1'b0;
        end
//memory read        
always @(posedge clk)   //, posedge rst)
    if(rst)
        rd <= 1'b0;
    else 
        rd <= (st == write); 

function integer map_between_ranges(integer start_range_input, end_range_input,
start_range_output, end_range_output, value);
    map_between_ranges = start_range_input + 1000 * (end_range_output - start_range_output) / 
    (end_range_input - start_range_input) * (value - start_range_input) / 1000;
endfunction

function integer transcode(input[11:0] code);
    integer max_voltage = 3300;
    automatic reg [11:0] mask = 12'b1000_0000_0000;
    integer i;
    //integer unmapped;
        begin
            transcode = 0;
            for(i = 0; i < 12; i = i + 1)
                if(code & (mask >> i))
                    transcode += max_voltage / (2 ** (i + 1));  
           //transcode /= 10;
           $display("Before = %d", transcode);
           transcode = transcode >> 4;
           $display("After = %d", transcode);         
           //unmapped = transcode;       
           //transcode = map_between_ranges(0, 3300, 0, 255, transcode);
           //$display("Mapped = %d", transcode);
        end    
endfunction    

endmodule

