/*
   This file was generated automatically by Alchitry Labs version 1.2.5.
   Do not edit this file directly. Instead edit the original Lucid source.
   This is a temporary file and any changes made to it will be destroyed.
*/

module mig_wrapper_1 (
    inout [15:0] ddr3_dq,
    inout [1:0] ddr3_dqs_n,
    inout [1:0] ddr3_dqs_p,
    output reg [13:0] ddr3_addr,
    output reg [2:0] ddr3_ba,
    output reg ddr3_ras_n,
    output reg ddr3_cas_n,
    output reg ddr3_we_n,
    output reg ddr3_reset_n,
    output reg ddr3_ck_p,
    output reg ddr3_ck_n,
    output reg ddr3_cke,
    output reg ddr3_cs_n,
    output reg [1:0] ddr3_dm,
    output reg ddr3_odt,
    input sys_clk,
    input clk_ref,
    input [176:0] mem_in,
    output reg [130:0] mem_out,
    output reg ui_clk,
    output reg sync_rst,
    input sys_rst
  );
  
  
  
  wire [14-1:0] M_mig_ddr3_addr;
  wire [3-1:0] M_mig_ddr3_ba;
  wire [1-1:0] M_mig_ddr3_ras_n;
  wire [1-1:0] M_mig_ddr3_cas_n;
  wire [1-1:0] M_mig_ddr3_we_n;
  wire [1-1:0] M_mig_ddr3_reset_n;
  wire [1-1:0] M_mig_ddr3_ck_p;
  wire [1-1:0] M_mig_ddr3_ck_n;
  wire [1-1:0] M_mig_ddr3_cke;
  wire [1-1:0] M_mig_ddr3_cs_n;
  wire [2-1:0] M_mig_ddr3_dm;
  wire [1-1:0] M_mig_ddr3_odt;
  wire [128-1:0] M_mig_app_rd_data;
  wire [1-1:0] M_mig_app_rd_data_end;
  wire [1-1:0] M_mig_app_rd_data_valid;
  wire [1-1:0] M_mig_app_rdy;
  wire [1-1:0] M_mig_app_wdf_rdy;
  wire [1-1:0] M_mig_app_sr_active;
  wire [1-1:0] M_mig_app_ref_ack;
  wire [1-1:0] M_mig_app_zq_ack;
  wire [1-1:0] M_mig_ui_clk;
  wire [1-1:0] M_mig_ui_clk_sync_rst;
  wire [1-1:0] M_mig_init_calib_complete;
  wire [12-1:0] M_mig_device_temp;
  reg [1-1:0] M_mig_sys_clk_i;
  reg [1-1:0] M_mig_clk_ref_i;
  reg [28-1:0] M_mig_app_addr;
  reg [3-1:0] M_mig_app_cmd;
  reg [1-1:0] M_mig_app_en;
  reg [128-1:0] M_mig_app_wdf_data;
  reg [1-1:0] M_mig_app_wdf_end;
  reg [16-1:0] M_mig_app_wdf_mask;
  reg [1-1:0] M_mig_app_wdf_wren;
  reg [1-1:0] M_mig_app_sr_req;
  reg [1-1:0] M_mig_app_ref_req;
  reg [1-1:0] M_mig_app_zq_req;
  reg [1-1:0] M_mig_sys_rst;
  mig_7series_0 mig (
    .ddr3_dq(ddr3_dq),
    .ddr3_dqs_n(ddr3_dqs_n),
    .ddr3_dqs_p(ddr3_dqs_p),
    .sys_clk_i(M_mig_sys_clk_i),
    .clk_ref_i(M_mig_clk_ref_i),
    .app_addr(M_mig_app_addr),
    .app_cmd(M_mig_app_cmd),
    .app_en(M_mig_app_en),
    .app_wdf_data(M_mig_app_wdf_data),
    .app_wdf_end(M_mig_app_wdf_end),
    .app_wdf_mask(M_mig_app_wdf_mask),
    .app_wdf_wren(M_mig_app_wdf_wren),
    .app_sr_req(M_mig_app_sr_req),
    .app_ref_req(M_mig_app_ref_req),
    .app_zq_req(M_mig_app_zq_req),
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
    .app_rd_data(M_mig_app_rd_data),
    .app_rd_data_end(M_mig_app_rd_data_end),
    .app_rd_data_valid(M_mig_app_rd_data_valid),
    .app_rdy(M_mig_app_rdy),
    .app_wdf_rdy(M_mig_app_wdf_rdy),
    .app_sr_active(M_mig_app_sr_active),
    .app_ref_ack(M_mig_app_ref_ack),
    .app_zq_ack(M_mig_app_zq_ack),
    .ui_clk(M_mig_ui_clk),
    .ui_clk_sync_rst(M_mig_ui_clk_sync_rst),
    .init_calib_complete(M_mig_init_calib_complete),
    .device_temp(M_mig_device_temp)
  );
  
  always @* begin
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
    M_mig_app_sr_req = 1'h0;
    M_mig_app_ref_req = 1'h0;
    M_mig_app_zq_req = 1'h0;
    M_mig_app_wdf_data = mem_in[32+127-:128];
    M_mig_app_wdf_end = mem_in[160+0-:1];
    M_mig_app_wdf_wren = mem_in[160+0-:1];
    M_mig_app_wdf_mask = mem_in[161+15-:16];
    M_mig_app_cmd = mem_in[28+2-:3];
    M_mig_app_en = mem_in[31+0-:1];
    M_mig_app_addr = mem_in[0+27-:28];
    mem_out[0+127-:128] = M_mig_app_rd_data;
    mem_out[128+0-:1] = M_mig_app_rd_data_valid;
    mem_out[129+0-:1] = M_mig_app_rdy;
    mem_out[130+0-:1] = M_mig_app_wdf_rdy;
    M_mig_sys_clk_i = sys_clk;
    M_mig_clk_ref_i = clk_ref;
    M_mig_sys_rst = sys_rst;
    sync_rst = M_mig_ui_clk_sync_rst;
    ui_clk = M_mig_ui_clk;
  end
endmodule
