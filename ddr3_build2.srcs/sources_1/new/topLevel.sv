module topLevel(
	input                clk,
	input                rst_n,
	output reg  [7:0]    led,
	input                usb_rx,
	output reg           usb_tx,
	output reg  [23:0]   io_led,
    output reg  [7:0]    io_seg,
    output reg  [3:0]    io_sel,
    input       [4:0]    io_button,
    input       [23:0]   io_dip,
    
    //ddr3 interface
    output  [13:0]   ddr3_addr,
    output  [2:0]    ddr3_ba,
    output           ddr3_ras_n,
    output           ddr3_cas_n,
    output           ddr3_we_n,
    output           ddr3_reset_n,
    output           ddr3_ck_p,
    output           ddr3_ck_n,
    output           ddr3_cke,
    output           ddr3_cs_n,
    output  [1:0]    ddr3_dm,
    output           ddr3_odt
);


DDR3Interface(
	.clk100(clk),
	.sys_rst(rst),
	//UI interface
	.UI_wr_addr('b1010),
	.UI_wr_data('b11001010),
	.UI_wr_valid(io_button[0]),
	.UI_wr_ready(io_led[0]),
	.UI_rd_addr('b1010),
	.UI_rd_cmd_valid(io_button[0]),
	.UI_rd_ready(io_led[1]),
	.UI_rd_data(io_led[15:8]),
	.UI_rd_data_valid(io_led[2]),
	.UI_flush('b0),
	.UI_flush_ready(io_led[3]),
	//ddr3 interconnects
	.ddr3_dq(ddr3_dq),
	.ddr3_dqs_n(ddr3_dqs_n),
	.ddr3_dqs_p(ddr3_dqs_p),
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
	.ddr3_odt(ddr3_odt)
);

  
endmodule
