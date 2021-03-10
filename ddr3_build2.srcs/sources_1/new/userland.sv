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

(* fsm_encoding = "one_hot" *) state_t currentState;
state_t nextState;


always @(posedge clk) begin
	currentState <= nextState;
	case (currentState)
		IDLE : io.sys_led[2:0] =       'b001;
		ONEIN : io.sys_led[2:0] =      'b010;
		TWOIN : io.sys_led[2:0] =      'b011;
		WRITE : io.sys_led[2:0] =      'b100;
		READ : io.sys_led[2:0] =       'b101;
		READ_DELAY : io.sys_led[2:0] = 'b110;
		default : io.sys_led[2:0] =    'b111;
	endcase
end

reg [7:0] cmd;
reg [31:0] addr;
reg [7:0] data;

reg [2:0] dataW;
assign usb.dataWidth = dataW;

assign io.sys_led[3] = ddr.wr_ready;
assign io.sys_led[4] = ddr.rd_ready;

initial begin 
	currentState <= IDLE;
	nextState <= IDLE;
end



always @(posedge clk) begin

	//sensible defaults 
	ddr.wr_valid <= 'b0;
	ddr.flush <= 'b0;
	ddr.rd_cmd_valid <= 'b0;
	usb.newDataOut <= 'b0;
	currentState <= nextState;
	
	
	case(currentState)
		IDLE : begin
			dataW <= 'b001;
			if(usb.newDataIn) begin
				dataW <= 'b100;
				cmd <= usb.dataIn[7:0];
				nextState <= ONEIN;
			end
		end
		
		ONEIN : begin
			dataW <= 'b100;
			if(usb.newDataIn) begin
				addr <= usb.dataIn[31:0];
				dataW <= 'b001;
				case(cmd)
					'h52    : nextState <= READ;
					'h57    : nextState <= TWOIN;
					default : nextState <= IDLE;
				endcase
			end
		end
		
		TWOIN : begin
			dataW <= 'b001;
			if(usb.newDataIn) begin
				data <= usb.dataIn[7:0];
				nextState <= WRITE;
				dataW <= 'b001;
			end
		end
		
		WRITE : begin
			if(ddr.wr_ready) begin
				ddr.wr_addr <= addr[27:0];
				ddr.wr_data <= data;
				ddr.wr_valid <= 'b1;
				nextState <= IDLE;
			end
		end
		
		READ : begin
			if(ddr.rd_ready) begin
				ddr.rd_addr <= addr[27:0];
				ddr.rd_cmd_valid <= 'b1;
				nextState <= READ_DELAY;
			end
		end
		
		READ_DELAY : begin
			if(ddr.rd_data_valid) begin
				usb.dataOut <= ddr.rd_data;
				usb.newDataOut <= 'b1;
				nextState <= IDLE;
			end
		end
		default : nextState <= IDLE;
	endcase	
	if(rst) begin
		nextState <= IDLE;
		ddr.flush <= 'b1;
	end
end

endmodule

