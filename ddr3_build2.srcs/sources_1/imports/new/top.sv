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
  

reg rst;

//wires for the clk_wiz object
wire M_clk_wiz_clk_out1;
wire M_clk_wiz_clk_out2;
wire M_clk_wiz_clk_out3;
reg M_clk_wiz_reset;
reg M_clk_wiz_clk_in1;

//connections to the clock wiz and it's instantiation
clk_wiz_0 clk_wiz (
.reset(M_clk_wiz_reset),
.clk_in1(M_clk_wiz_clk_in1),
.clk_out1(M_clk_wiz_clk_out1),
.clk_out2(M_clk_wiz_clk_out2),
.clk_out3(M_clk_wiz_clk_out3),
.locked(M_clk_wiz_locked)
);


wire    [13:0]  M_mig_ddr3_addr;
wire    [2:0]   M_mig_ddr3_ba;
wire            M_mig_ddr3_ras_n;
wire            M_mig_ddr3_cas_n;
wire            M_mig_ddr3_we_n;
wire            M_mig_ddr3_reset_n;
wire            M_mig_ddr3_ck_p;
wire            M_mig_ddr3_ck_n;
wire            M_mig_ddr3_cke;
wire            M_mig_ddr3_cs_n;
wire    [1:0]   M_mig_ddr3_dm;
wire            M_mig_ddr3_odt;
wire    [130:0] M_mig_mem_out;
wire            M_mig_ui_clk;
wire            M_mig_sync_rst;
reg             M_mig_sys_clk;
reg             M_mig_clk_ref;
reg     [176:0] M_mig_mem_in;
reg             M_mig_sys_rst;

mig_wrapper_1 mig (
    .ddr3_dq(ddr3_dq),
    .ddr3_dqs_n(ddr3_dqs_n),
    .ddr3_dqs_p(ddr3_dqs_p),
    .sys_clk(M_mig_sys_clk),
    .clk_ref(M_mig_clk_ref),
    .mem_in(M_mig_mem_in),
    .sys_rst(M_mig_sys_rst),
    .ddr3_addr(M_mig_ddr3_addr),
    .ddr3_ba(M_mig_ddr3_ba),
    .ddr3_ras_n(M_mig_ddr3_ras_n),
    .ddr3_cas_n(M_mig_ddr3_cas_n),
    .ddr3_we_n(M_mig_ddr3_we_n),
    .ddr3_reset_n(M_mig_ddr3_reset_n),
    .ddr3_ck_p(M_mig_ddr3_ck_p),
    .ddr3_ck_n(M_mig_ddr3_ck_n),
    .ddr3_cke(M_mig_ddr3_cke),
    .ddr3_cs_n(M_mig_ddr3_cs_n),
    .ddr3_dm(M_mig_ddr3_dm),
    .ddr3_odt(M_mig_ddr3_odt),
    .mem_out(M_mig_mem_out),
    .ui_clk(M_mig_ui_clk),
    .sync_rst(M_mig_sync_rst)
);
 

localparam  WRITE_DATA_state    =   2'd0;
localparam  READ_CMD_state      =   2'd1;
localparam  WAIT_READ_state     =   2'd2;
localparam  DELAY_state         =   2'd3;

//LRU cache connections
reg     [1:0]   M_state_d       =   WRITE_DATA_state;
reg     [23:0]  M_ctr_q         =   1'h0;
reg     [1:0]   M_state_q       =   WRITE_DATA_state;
reg     [23:0]  M_ctr_d         =   1'h0;
reg     [7:0]   M_address_q     =   1'h0;
reg     [7:0]   M_address_d     =   1'h0;
reg     [7:0]   M_led_reg_q     =   1'h0;
reg     [7:0]   M_led_reg_d     =   1'h0;
wire            M_cache_wr_ready;
wire            M_cache_rd_ready;
wire    [7:0]   M_cache_rd_data;
wire            M_cache_rd_data_valid;
wire            M_cache_flush_ready;
wire    [176:0] M_cache_mem_in;
reg     [27:0]  M_cache_wr_addr;
reg     [7:0]   M_cache_wr_data;
reg             M_cache_wr_valid;
reg     [27:0]  M_cache_rd_addr;
reg             M_cache_rd_cmd_valid;
reg             M_cache_flush;
reg     [130:0] M_cache_mem_out;


lru_cache_2 cache (
.clk(M_mig_ui_clk),
.rst(rst),
.wr_addr(M_cache_wr_addr),
.wr_data(M_cache_wr_data),
.wr_valid(M_cache_wr_valid),
.rd_addr(M_cache_rd_addr),
.rd_cmd_valid(M_cache_rd_cmd_valid),
.flush(M_cache_flush),
.mem_out(M_cache_mem_out),
.wr_ready(M_cache_wr_ready),
.rd_ready(M_cache_rd_ready),
.rd_data(M_cache_rd_data),
.rd_data_valid(M_cache_rd_data_valid),
.flush_ready(M_cache_flush_ready),
.mem_in(M_cache_mem_in)
);

always @* begin
M_state_d = M_state_q;
M_ctr_d = M_ctr_q;
M_address_d = M_address_q;
M_led_reg_d = M_led_reg_q;

io_led = 24'h000000;
io_seg = 8'hff;
io_sel = 4'hf;
M_clk_wiz_clk_in1 = clk;
M_clk_wiz_reset = !rst_n;
ddr3_addr = M_mig_ddr3_addr;
ddr3_ba = M_mig_ddr3_ba;
ddr3_ras_n = M_mig_ddr3_ras_n;
ddr3_cas_n = M_mig_ddr3_cas_n;
ddr3_we_n = M_mig_ddr3_we_n;
ddr3_reset_n = M_mig_ddr3_reset_n;
ddr3_ck_p = M_mig_ddr3_ck_p;
ddr3_ck_n = M_mig_ddr3_ck_n;
ddr3_cke = M_mig_ddr3_cke;
ddr3_cs_n = M_mig_ddr3_cs_n;
ddr3_dm = M_mig_ddr3_dm;
ddr3_odt = M_mig_ddr3_odt;
M_mig_sys_clk = M_clk_wiz_clk_out1;
M_mig_clk_ref = M_clk_wiz_clk_out2;
M_mig_sys_rst = !M_clk_wiz_locked;
rst = M_mig_sync_rst;
led = M_led_reg_q;
usb_tx = usb_rx;
M_mig_mem_in = M_cache_mem_in;
M_cache_mem_out = M_mig_mem_out;
M_cache_flush = 1'h0;
M_cache_wr_addr = M_address_q;
M_cache_wr_data = M_address_q;
M_cache_wr_valid = 1'h0;
M_cache_rd_addr = M_address_q;
M_cache_rd_cmd_valid = 1'h0;

case (M_state_q)
    WRITE_DATA_state: begin
    if (M_cache_wr_ready) begin
        M_cache_wr_valid = 1'h1;
        M_address_d = M_address_q + 1'h1;
        if (M_address_q == 8'hff) begin
        M_state_d = READ_CMD_state;
        M_address_d = 1'h0;
        end
    end
    end
    READ_CMD_state: begin
    if (M_cache_rd_ready) begin
        M_cache_rd_cmd_valid = 1'h1;
        M_state_d = WAIT_READ_state;
    end
    end
    WAIT_READ_state: begin
    if (M_cache_rd_data_valid) begin
        M_led_reg_d = M_cache_rd_data;
        M_state_d = DELAY_state;
        M_address_d = M_address_q + 1'h1;
    end
    end
    DELAY_state: begin
    M_ctr_d = M_ctr_q + 1'h1;
    if ((&M_ctr_q)) begin
        M_state_d = READ_CMD_state;
    end
    end
endcase
end

always @(posedge M_mig_ui_clk) begin
if (rst == 1'b1) begin
    M_ctr_q <= 1'h0;
    M_address_q <= 1'h0;
    M_led_reg_q <= 1'h0;
    M_state_q <= 1'h0;
end else begin
    M_ctr_q <= M_ctr_d;
    M_address_q <= M_address_d;
    M_led_reg_q <= M_led_reg_d;
    M_state_q <= M_state_d;
end
end
  
endmodule
