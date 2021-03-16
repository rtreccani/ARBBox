module userland(
	ddr3_IF ddr,
	io_IF io,
	usb_IF usb,
	input rst,
	input clk
);

reg [27:0] address;
reg[23:0] cacheMiss;
assign io.led = cacheMiss;

heartbeat #(.CLKFREQ(81250000)) h(
	.clk(clk),
	.beat(io.sys_led[7])
);
reg [27:0] addrPtr;
reg [127:0] currentLine;
reg [127:0] prefetchLine;
reg [1:0] dirtyLine;
reg [1:0] requestFired;

typedef enum{
	BURST_PRELOAD,
	BURST
} state_t;


state_t currentState;
state_t nextState;

initial begin
	dirtyLine <= 'b11;
	currentState <= BURST_PRELOAD;
	nextState <= BURST;
	addrPtr <= 'b0;
end


always @(posedge clk) begin
	ddr.wr_valid <= 'b0;
	ddr.rd_cmd_valid <= 'b0;

	case(currentState)
		BURST_PRELOAD : begin	
			if(~requestFired[1]) begin
				requestFired[1] <= 'b1;
				ddr.rd_addr <= addrPtr;
				ddr.rd_cmd_valid <= 'b1;
			end
			
			if(ddr.rd_data_valid) begin
				requestFired[1] <= 'b0;
				currentLine <= ddr.rd_data;
				dirtyLine[1] <= 'b0;
				nextState <= BURST;
			end
		end
		
		BURST : begin
			address++;
			if(dirtyLine[0] & ~requestFired[0]) begin
				requestFired <= 'b1;
				ddr.rd_addr <= address[27:4]+'d1;
				ddr.rd_cmd_valid <= 'b1;
			end
			
			if(dirtyLine[0] & requestFired[0]) begin
				if(ddr.rd_data_valid) begin
					dirtyLine[0] <= 'b0;
					requestFired[0] <= 'b0;
					prefetchLine <= ddr.rd_data;
				end
			end
			
			if(address % 'b10000 == 'b01111) begin
				currentLine <= prefetchLine;
				dirtyLine[0] <= 'b1;
			end
			
			if((address % 'b10000 == 'b01111) & dirtyLine[0]) begin
				cacheMiss++;
			end
		end
	endcase
end
endmodule

