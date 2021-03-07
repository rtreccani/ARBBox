module userland(
	ddr3_IF ddr,
	io_IF io,
	usb_IF usb,
	input rst,
	input clk
);

reg [7:0] address;


heartbeat #(.CLKFREQ(81250000)) h(
	.clk(clk),
	.beat(io.sys_led[7])
);

typedef enum {
	IDLE,
	ONEIN,
	TWOIN,
	WRITE,
	READ,
	READ_DELAY
} state_t;

state_t currentState;
state_t nextState;

always @(posedge clk) begin
	currentState <= nextState;
	case (currentState)
		IDLE : io.sys_led[5:0] =       'b000001;
		ONEIN : io.sys_led[5:0] =      'b000010;
		TWOIN : io.sys_led[5:0] =      'b000011;
		WRITE : io.sys_led[5:0] =      'b000100;
		READ : io.sys_led[5:0] =       'b000101;
		READ_DELAY : io.sys_led[5:0] = 'b000110;
		default : io.sys_led[5:0] =    'b111111;
	endcase
end

reg [7:0] FIFO [3];

initial begin 
	currentState <= IDLE;
	nextState <= IDLE;
end

assign io.led = {FIFO[2], FIFO[1], FIFO[0]};

always @(posedge clk) begin

	//sensible defaults 
	ddr.wr_valid <= 'b0;
	ddr.rd_cmd_valid <= 'b0;
	usb.newDataOut <= 'b0;
	currentState <= nextState;
	
	
	case(currentState)
		IDLE : begin
			if(usb.newDataIn) begin
				FIFO[0] <= usb.dataIn;
				nextState <= ONEIN;
			end
		end
		
		ONEIN : begin
			if(usb.newDataIn) begin
				FIFO[1] <= usb.dataIn;
				nextState <= TWOIN;
			end
		end
		
		TWOIN : begin
			if(usb.newDataIn) begin
				FIFO[2] <= usb.dataIn;
				if(FIFO[0] == 'h57) begin
					nextState <= WRITE;
				end else if(FIFO[0] == 'h52) begin
					nextState <= READ;
				end
				else begin
					nextState <= IDLE;
				end
			end
		end
		
		WRITE : begin
			ddr.wr_addr <= {19'b0, FIFO[1]};
			ddr.wr_data <= FIFO[2];
			ddr.wr_valid <= 'b1;
			nextState <= IDLE;
		end
		
		READ : begin
			ddr.rd_addr <= {19'b0, FIFO[1]};
			ddr.rd_cmd_valid <= 'b1;
			nextState <= READ_DELAY;
		end
		
		READ_DELAY : begin
			if(ddr.rd_data_valid) begin
				usb.dataOut <= ddr.rd_data;
				usb.newDataOut <= 'b1;
				nextState <= IDLE;
			end
		end
	endcase	
end

endmodule

