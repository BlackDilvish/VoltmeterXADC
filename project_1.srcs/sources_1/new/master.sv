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
    output logic [3:0] wadr, output logic awvld, input awrdy,
    output [31:0] wdat, output logic wvld, input wrdy,
    input [1:0] brsp, input bvld, output logic brdy,
    output logic [3:0] radr, output logic arvld, input arrdy,
    input [31:0] rdat, input rvld, output logic rrdy,
    output [nb-1:0] mem_addr, input [7:0] data_tr, output logic [7:0] data_rec,
    output logic rd, wr
    );
    
typedef enum {readstatus, waitstatus, read, waitread, write, waitwrite, waitresp, command, clear} states_e;
states_e st, nst;


logic rec_trn, command_mode;
logic [5:0] max_data;
logic [nb-1:0] addr;

wire addr0 = (addr ==  {nb{1'b0}});
wire rfifo_valid = (st == waitstatus & rvld) ? rdat[0] : 1'b0;
wire tfifo_full = (st == waitstatus & rvld) ? rdat[3] : 1'b0;

wire incar = ((st == waitread) & rvld & rec_trn & (addr < max_data));
wire incat = ((st == waitwrite) & awrdy & ~rec_trn & (addr < max_data));
//wire deca = ((st == waitwrite) & awrdy & ~rec_trn); //wrdy


/*always @(posedge clk, posedge rst)
    if(rst)
        rec_trn <= 1'b1;
    else if(addr == deep)
        rec_trn <= 1'b0;
    else if(st == clear)
        rec_trn <= 1'b1;*/
    
always @(posedge clk, posedge rst)
    if(rst) begin
        {rec_trn, command_mode} <= 2'b11;
        max_data <= 6'b0; end
    else if (st == command) begin
        {rec_trn, command_mode} <= 2'b11;
        max_data = rdat[5:0];
        case(rdat[7:6])
            2'b10: command_mode <= (rdat[5:0] == 6'b0) ? 1'b1 : 1'b0;
            2'b11: rec_trn <= 1'b0;
        endcase end
    else if (st == waitresp & addr == max_data)
        {rec_trn, command_mode} <= 2'b11;
        
     
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
        waitread: nst = rvld ? (rdat[7] == 1 ? command : readstatus) : waitread;
        command: nst = readstatus;
        write: nst = waitwrite;
        waitwrite: nst = awrdy ? waitresp : waitwrite;
        waitresp: nst = bvld ?addr0 ?clear : readstatus : waitresp;
        clear: nst = readstatus;
     endcase
end
   
assign mem_addr = rec_trn ? addr : (addr + 1);
always @(posedge clk, posedge rst)
    if(rst)
        addr <= {nb{1'b0}};
    else if(incar | incat)
        addr <= addr + 1;
    /*else if(deca)
        addr <= addr - 1;*/
    else if (st == clear | st == command)
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
    else if (incar)
        data_rec <= rdat[7:0];
//memory write 
always @(posedge clk)   //, posedge rst)
    if(rst)
        wr <= 1'b0;
    else 
        wr <= incar;

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

endmodule
