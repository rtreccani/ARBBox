module userland(
	ddr3_IF ddr,
	io_IF io,
	input clk
);

reg [7:0] address;


assign io.led[23:16] = ddr.rd_data;
assign ddr.rd_addr = 'd420;
assign ddr.wr_addr = 'd420;
assign ddr.flush = io.dip[2];
assign ddr.wr_data = io.dip[15:8];
assign io.led[15:8] = ddr.wr_data;
assign ddr.wr_valid = io.dip[0];
assign ddr.wr_ready = io.led[0];
assign ddr.rd_cmd_valid = io.dip[1];
assign ddr.rd_ready = io.led[1];
assign ddr.rd_data_valid = io.led[2];





//always @(posedge clk) begin

//	//sensible defaults :^) 
//	ddr.wr_valid <= 'b0;
//	ddr.rd_cmd_valid <= 'b0;
//	ddr.flush <= 'b0;
	
	
//	//big switch/case 
//	case(state)
//		W : begin
//			if(ddr.wr_ready) begin
//				ddr.wr_addr <= address;
//				ddr.wr_data <= address;
//				ddr.wr_valid <= 'b1;
//				address <= address + 'b1;
				
//				if(address == 8'h05) begin
//					address <= 'b0; 
//					state <= R_RQ; 
//				end	
//			end
//		end
		
//		R_RQ : begin
//			if (ddr.rd_ready) begin
//				ddr.rd_addr <= address;
//				ddr.rd_cmd_valid <= 'b1;
//				state <= R_DELAY;
//			end
//		end
		
//		R_DELAY : begin
//			if(ddr.rd_data_valid) begin
//				state <= DELAY;
//				address <= address + 'b1;
//				if(address == 'h05) begin
//					address <= 'h00;
//					state <= W;
//				end
//			end
//		end
		
//		DELAY : begin
//			counter <= counter + 1;
//			if(counter == 'd8000000) begin
//				counter <= 0;
//				state <= R_RQ;
//			end
//		end	
//	endcase
//end

endmodule

