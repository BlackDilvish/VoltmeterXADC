`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2021 12:09:16
// Design Name: 
// Module Name: top
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


module top #(parameter mdeep = 20 ) (
    input clk, rst, rx,
    output tx
    );
    
//uart
wire [3 : 0] s_axi_awaddr,s_axi_araddr;
wire [31 : 0] s_axi_wdata,s_axi_rdata;
wire [3 : 0] s_axi_wstrb = 4'b1111;
wire [1 : 0] s_axi_rresp, s_axi_bresp;

//adc
wire [10:0] s_axi_awaddr_adc, s_axi_araddr_adc;

axi_uartlite_slave slave (
  .s_axi_aclk(clk),        // input wire s_axi_aclk
  .s_axi_aresetn(~rst),  // input wire s_axi_aresetn
  .interrupt(),          // output wire interrupt
  .s_axi_awaddr(s_axi_awaddr),    // input wire [3 : 0] s_axi_awaddr
  .s_axi_awvalid(s_axi_awvalid),  // input wire s_axi_awvalid
  .s_axi_awready(s_axi_awready),  // output wire s_axi_awready
  
  .s_axi_wdata(s_axi_wdata),      // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb(s_axi_wstrb),      // input wire [3 : 0] s_axi_wstrb
  .s_axi_wvalid(s_axi_wvalid),    // input wire s_axi_wvalid
  .s_axi_wready(s_axi_wready),    // output wire s_axi_wready
  
  .s_axi_bresp(s_axi_bresp),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(s_axi_bvalid),    // output wire s_axi_bvalid
  .s_axi_bready(s_axi_bready),    // input wire s_axi_bready
  
  .s_axi_araddr(s_axi_araddr),    // input wire [3 : 0] s_axi_araddr
  .s_axi_arvalid(s_axi_arvalid),  // input wire s_axi_arvalid
  .s_axi_arready(s_axi_arready),  // output wire s_axi_arready
  
  .s_axi_rdata(s_axi_rdata),      // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp(s_axi_rresp),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid(s_axi_rvalid),    // output wire s_axi_rvalid
  .s_axi_rready(s_axi_rready),    // input wire s_axi_rready
  
  .rx(rx),                        // input wire rx
  .tx(tx)                        // output wire tx
);
    
logic [$clog2(mdeep)-1:0] adr;
logic [7:0] dato, dati;
    
master #(.deep(mdeep)) m_axi (
    .clk(clk), .rst(rst),
    .wadr(s_axi_awaddr), .awvld(s_axi_awvalid), .awrdy(s_axi_awready),
    .wdat(s_axi_wdata), .wvld(s_axi_wvalid), .wrdy(s_axi_wready),
    .brsp(s_axi_bresp), .bvld(s_axi_bvalid), .brdy(s_axi_bready),
    .radr(s_axi_araddr), .arvld(s_axi_arvalid), .arrdy(s_axi_arready),
    .rdat(s_axi_rdata), .rvld(s_axi_rvalid), .rrdy(s_axi_rready),
    .mem_addr(adr), .data_tr(dato), .data_rec(dati),
    .rd(rd), .wr(wr)
    );    
    
memory #(.deep(mdeep)) storage (
    .clk(clk), .addr(adr),
    .data_in(dati), .data_out(dato),
    .rd(rd), .wr(wr)
    );
/*
xadc_wiz_0 adc_axi (
  .s_axi_aclk(clk),                    // input wire s_axi_aclk
  .s_axi_aresetn(~rst),              // input wire s_axi_aresetn
  .s_axi_awaddr(s_axi_awaddr),                // input wire [10 : 0] s_axi_awaddr
  .s_axi_awvalid(s_axi_awvalid),              // input wire s_axi_awvalid
  .s_axi_awready(s_axi_awready),              // output wire s_axi_awready
  .s_axi_wdata(s_axi_wdata),                  // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb(s_axi_wstrb),                  // input wire [3 : 0] s_axi_wstrb
  .s_axi_wvalid(s_axi_wvalid),                // input wire s_axi_wvalid
  .s_axi_wready(s_axi_wready),                // output wire s_axi_wready
  .s_axi_bresp(s_axi_bresp),                  // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(s_axi_bvalid),                // output wire s_axi_bvalid
  .s_axi_bready(s_axi_bready),                // input wire s_axi_bready
  .s_axi_araddr(s_axi_araddr),                // input wire [10 : 0] s_axi_araddr
  .s_axi_arvalid(s_axi_arvalid),              // input wire s_axi_arvalid
  .s_axi_arready(s_axi_arready),              // output wire s_axi_arready
  .s_axi_rdata(s_axi_rdata),                  // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp(s_axi_rresp),                  // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid(s_axi_rvalid),                // output wire s_axi_rvalid
  .s_axi_rready(s_axi_rready),                // input wire s_axi_rready
  .ip2intc_irpt(ip2intc_irpt),                // output wire ip2intc_irpt
  .vp_in(1'b0),                              // input wire vp_in
  .vn_in(1'b0),                              // input wire vn_in
  .user_temp_alarm_out(user_temp_alarm_out),  // output wire user_temp_alarm_out
  .vccint_alarm_out(vccint_alarm_out),        // output wire vccint_alarm_out
  .vccaux_alarm_out(vccaux_alarm_out),        // output wire vccaux_alarm_out
  .vccpint_alarm_out(vccpint_alarm_out),      // output wire vccpint_alarm_out
  .vccpaux_alarm_out(vccpaux_alarm_out),      // output wire vccpaux_alarm_out
  .vccddro_alarm_out(vccddro_alarm_out),      // output wire vccddro_alarm_out
  .ot_out(ot_out),                            // output wire ot_out
  .channel_out(channel_out),                  // output wire [4 : 0] channel_out
  .eoc_out(eoc_out),                          // output wire eoc_out
  .alarm_out(alarm_out),                      // output wire alarm_out
  .eos_out(eos_out),                          // output wire eos_out
  .busy_out(busy_out)                        // output wire busy_out
);
*/
endmodule
