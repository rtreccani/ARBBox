/*
   This file was generated automatically by Alchitry Labs version 1.2.5.
   Do not edit this file directly. Instead edit the original Lucid source.
   This is a temporary file and any changes made to it will be destroyed.
*/

module top (        
    input                clk,
    input                rst_n,
    output reg  [7:0]    led,
    input                usb_rx,
    output reg           usb_tx,
    inout       [15:0]   ddr3_dq,
    inout       [1:0]    ddr3_dqs_n,
    inout       [1:0]    ddr3_dqs_p,
    output reg  [13:0]   ddr3_addr,
    output reg  [2:0]    ddr3_ba,
    output reg           ddr3_ras_n,
    output reg           ddr3_cas_n,
    output reg           ddr3_we_n,
    output reg           ddr3_reset_n,
    output reg           ddr3_ck_p,
    output reg           ddr3_ck_n,
    output reg           ddr3_cke,
    output reg           ddr3_cs_n,
    output reg  [1:0]    ddr3_dm,
    output reg           ddr3_odt,
    output reg  [23:0]   io_led,
    output reg  [7:0]    io_seg,
    output reg  [3:0]    io_sel,
    input       [4:0]    io_button,
    input       [23:0]   io_dip
);

io_IF io();
assign io.sys_led = led;
assign io.led = io_led;
assign io.seg = io_seg;
assign io.sel = io_sel;
assign io.button = io_button;
assign io.dip = io_dip;


//wires for the clk_wiz object
wire clk100;
wire clk200;
reg clk_lock;

//connections to the clock wiz and it's instantiation
clk_wiz_0 clk_wiz (
.reset(~rst_n),
.clk_in1(clk),
.clk_out1(clk100),
.clk_out2(clk200),
.locked(clk_lock)
);

wire    [130:0] lru_native_out;
reg     [176:0] lru_native_in;

mig_wrapper_1 mig (
    .ddr3_dq(ddr3_dq),
    .ddr3_dqs_n(ddr3_dqs_n),
    .ddr3_dqs_p(ddr3_dqs_p),
    .sys_clk(clk100),
    .clk_ref(clk200),
    .mem_in(lru_native_in),
    .sys_rst(!clk_lock),
    .ddr3_addr(ddr3_addr),
    .ddr3_ba(ddr3_ba),
    .ddr3_ras_n(ddr3_ras_n),
    .ddr3_cas_n(ddr3_cas_n),
    .ddr3_we_n(ddr3_we_n),
    .ddr3_reset_n(ddr3_reset_n),
    .ddr3_ck_p(ddr3_ck_p),
    .ddr3_ck_n(ddr3_ck_n),
    .ddr3_cke(ddr3_cke),
    .ddr3_cs_n(ddr3_cs_n),
    .ddr3_dm(ddr3_dm),
    .ddr3_odt(ddr3_odt),
    .mem_out(lru_native_out),
    .ui_clk(ui_clk),
    .sync_rst(ui_rst)
);

usb_IF usb();
serialRx #(.CLK_PER_BIT(81)) sr(
	.clk(ui_clk),
	.rst(ui_rst),
	.rx(usb_rx),
	.data(usb.dataIn),
	.new_data(usb.newDataIn)
);
serialTx #(.CLK_PER_BIT(81)) st(
	.clk(ui_clk),
	.rst(ui_rst),
	.tx(usb_tx),
	.data(usb.dataOut),
	.new_data(usb.newDataOut),
	.block('b0)
);
ddr3_IF ddr();
userland u(
	.ddr(ddr),
	.io(io),
	.clk(ui_clk),
	.rst(ui_rst),
	.usb(usb)
);
lru_cache_2 cache (
    .clk(ui_clk),
    .rst(ui_rst),
    .wr_addr(ddr.wr_addr),
    .wr_data(ddr.wr_data),
    .wr_valid(ddr.wr_valid),
    .rd_addr(ddr.rd_addr),
    .rd_cmd_valid(ddr.rd_cmd_valid),
    .flush(ddr.flush),
    .wr_ready(ddr.wr_ready),
    .rd_ready(ddr.rd_ready),
    .rd_data(ddr.rd_data),
    .rd_data_valid(ddr.rd_data_valid),
    .flush_ready(ddr.flush_ready),
    .mem_out(lru_native_out),
    .mem_in(lru_native_in)
);

  
endmodule
