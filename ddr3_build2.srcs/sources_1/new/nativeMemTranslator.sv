module nativeMemTranslator(
	ddr3_native_IF ddr,
	output [176:0] mem_in,
	input [130:0] mem_out
    );

assign mem_in = {ddr.addr, ddr.cmd, ddr.en, ddr.wr_data, ddr.wr_en, ddr.wr_mask};
assign mem_out = {ddr.rd_data, ddr.rd_valid, ddr.rdy, ddr.wr_rdy};

endmodule