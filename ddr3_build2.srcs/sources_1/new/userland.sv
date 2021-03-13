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
	ADDR_SET,
	DATA_SET,
	WRITE,
	READ,
	READ_DELAY,
	BURSTW_LENSET,
	BURSTW,
	BURSTR_LENSET,
	BURSTR,
	BURSTR_DELAY
} state_t;

(* fsm_encoding = "one_hot" *) state_t currentState;
state_t nextState;


always @(posedge clk) begin
	currentState <= nextState;
	case (currentState)
		IDLE :          io.sys_led[3:0] = 'b0001;
		ADDR_SET :      io.sys_led[3:0] = 'b0010;
		DATA_SET :      io.sys_led[3:0] = 'b0011;
		WRITE :         io.sys_led[3:0] = 'b0100;
		READ :          io.sys_led[3:0] = 'b0101;
		READ_DELAY :    io.sys_led[3:0] = 'b0110;
		BURSTW_LENSET : io.sys_led[3:0] = 'b0111;
		BURSTW :        io.sys_led[3:0] = 'b1000;
		BURSTR_LENSET : io.sys_led[3:0] = 'b1001;
		BURSTR : 	    io.sys_led[3:0] = 'b1010;
		BURSTR_DELAY :  io.sys_led[3:0] = 'b1011;
		default :       io.sys_led[3:0] = 'b1111;
	endcase
end

reg [7:0] cmd;
reg [31:0] addr;
reg [7:0] data;
reg [31:0] burstPtr;
reg [31:0] burstLen;


reg [7:0] burstReadCache;
reg burstReadCacheDirty;



initial begin 
	currentState <= IDLE;
	nextState <= IDLE;
end

assign io.led[15:8] = burstLen[7:0];
assign io.led[7:0] = cmd;

always @(posedge clk) begin

	//sensible defaults
	usb.dataWidth <= 'b001; 
	ddr.wr_valid <= 'b0;
	ddr.flush <= 'b0;
	ddr.rd_cmd_valid <= 'b0;
	usb.newDataOut <= 'b0;
	currentState <= nextState;
	
	
	case(currentState)
		IDLE : begin
			usb.dataWidth <= 'b001;
			if(usb.newDataIn) begin
				cmd <= usb.dataIn[7:0];
				nextState <= ADDR_SET;
			end
		end
		
		ADDR_SET : begin
			usb.dataWidth <= 'b100;
			if(usb.newDataIn) begin
				addr <= usb.dataIn[31:0];
				case(cmd)
					'h52    : nextState <= READ;
					'h57    : nextState <= DATA_SET;
					'h42	: nextState <= BURSTW_LENSET;
					'h50    : nextState <= BURSTR_LENSET;
					default : nextState <= IDLE;
				endcase
			end
		end
		
		DATA_SET : begin
			usb.dataWidth <= 'b001;
			if(usb.newDataIn) begin
				data <= usb.dataIn[7:0];
				nextState <= WRITE;
			end
		end
		
		WRITE : begin
			usb.dataWidth <= 'b001;
			if(ddr.wr_ready) begin
				ddr.wr_addr <= addr[27:0];
				ddr.wr_data <= data;
				ddr.wr_valid <= 'b1;
				nextState <= IDLE;
			end
		end
		
		READ : begin
			usb.dataWidth <= 'b001;
			if(ddr.rd_ready) begin
				ddr.rd_addr <= addr[27:0];
				ddr.rd_cmd_valid <= 'b1;
				nextState <= READ_DELAY;
			end
		end
		
		READ_DELAY : begin
			usb.dataWidth <= 'b001;
			if(ddr.rd_data_valid) begin
				usb.dataOut <= ddr.rd_data;
				usb.newDataOut <= 'b1;
				nextState <= IDLE;
			end
		end
		
		
		BURSTW_LENSET : begin
			usb.dataWidth <= 'b100;
			if(usb.newDataIn) begin
				burstPtr <= addr;
				burstLen <= usb.dataIn[27:0];
				nextState <= BURSTW;
			end
		end
		
		BURSTW : begin
			usb.dataWidth <= 'b001;
			if(usb.newDataIn) begin
				ddr.wr_addr <= burstPtr;
				ddr.wr_data <= usb.dataIn;
				ddr.wr_valid <= 'b1;
				if(burstLen == 'd0) begin //off by one error
					nextState <= IDLE;
				end else begin
					burstLen--;
					burstPtr++;
				end
			end
		end
		
		BURSTR_LENSET : begin
			usb.dataWidth <= 'b100;
			if(usb.newDataIn) begin
				burstPtr <= addr;
				burstLen <= usb.dataIn[27:0];
				nextState <= BURSTR;
			end
		end
		
		BURSTR : begin
			usb.dataWidth <= 'b001;
			//handle new data from DDR
			if(ddr.rd_data_valid) begin
				burstReadCache <= ddr.rd_data;
				burstReadCacheDirty <= 'b0;
			end
			
			//handle USB
			if(usb.busyOut & ~burstReadCacheDirty) begin	
				//nothing
			end else if(usb.busyOut & burstReadCacheDirty) begin
				ddr.rd_addr <= burstPtr;
				ddr.rd_cmd_valid <= 'b1;
			end else if(~usb.busyOut & ~burstReadCacheDirty) begin
				usb.dataOut <= burstReadCache;
				usb.newDataOut <= 'b1;
				burstReadCacheDirty <= 'b1;
				burstPtr++;
				burstLen--;
			end else if(~usb.busyOut & burstReadCacheDirty) begin
				ddr.rd_addr <= burstPtr;
				ddr.rd_cmd_valid <= 'b1;
			end
			
			//handle next state
			if(burstLen == 'd0) begin
				nextState <= IDLE;
			end
		end	
	endcase	
	if(rst) begin
		nextState <= IDLE;
		ddr.flush <= 'b1;
	end
end

endmodule

