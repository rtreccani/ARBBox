module userland(
	ddr3_IF ddr,
	io_IF io,
	usb_IF usb,
	input rst,
	input clk
);

wire heartbeatPulse;
reg heartbeatRst;
//used to generate a pulse every X ticks for disconnect/discovery timer
heartbeat #(.CLKFREQ(81250000)) h(
	.clk(clk),
	.beat(heartbeatPulse),
	.rst(heartbeatRst)
);

//enumerate all the possible states of the statemachine
typedef enum {
	IDLE,
	DISCONNECTED,
	LOADLEN_AWAIT,
	LOAD,
	SETTING_AWAIT,
	PLAYBACK
} state_t;
//instantiate two state variables (to infer a D/Q latch)
//onehot encoding should simplify the logic under the hood
(* fsm_encoding = "one_hot" *) state_t currentState;
(* fsm_encoding = "one_hot" *) state_t nextState;


typedef enum {
	ONESHOT = 2'b00,
	REPEAT_N = 2'b01,
	REPEAT_INF = 2'b10
} playMode_t;

playMode_t playMode;


//on first boot move into the IDLE state 
initial begin 
	playMode <= ONESHOT;
	currentState <= DISCONNECTED;
	nextState <= DISCONNECTED;
end

enum {
	PLAYMODE
} settingMap_t;

//indicate current State on the LEDs and shift new state across
always @(posedge clk) begin
	currentState <= nextState;
	case (currentState)
		IDLE :			io.sys_led[3:0] = 'b0001;
		DISCONNECTED :  io.sys_led[3:0] = 'b0010;
		LOADLEN_AWAIT : io.sys_led[3:0] = 'b0011;
		LOAD          : io.sys_led[3:0] = 'b0100;
		SETTING_AWAIT : io.sys_led[3:0] = 'b0101;
		PLAYBACK      : io.sys_led[3:0] = 'b0110;
		default       : io.sys_led[3:0] = 'b1111;
	endcase
end

reg [31:0] loadPtr;
reg [31:0] loadLen;

wire [1:0] inBandSignal;
assign inBandSignal = usb.dataIn[1:0];

always @(posedge clk) begin
	//sensible defaults
	ddr.wr_valid <= 'b0;
	ddr.rd_cmd_valid <= 'b0;
	ddr.flush <= 'b0;
	usb.newDataOut <= 'b0;
	heartbeatRst <= 'b0;
	
	case(currentState)
		//list of sensitivities:
		//- usb.newDataIn (1 byte)
		//heartbeat timer pulse
		//list of possible states:
		//- IDLE (via magic packet)
		DISCONNECTED : begin
			usb.dataWidth <= 'b001;
			//if we get a packet in, check to see if its
			//a magic packet to move us into idle
			if(usb.newDataIn) begin
				if(usb.dataIn[7:0] == 'd64) begin
					nextState <= IDLE;
					heartbeatRst <= 'b1;
				end
			end
			//if we get a heartbeat pulse then retransmit
			//our magic packet to let the host know we're alive
			if(heartbeatPulse) begin 
				usb.dataOut <= 'd133;
				usb.newDataOut <= 'b1;
				heartbeatRst <= 'b1;
			end		 
		end
	
		//list of sensitivities: 
		//- usb.newDataIn(1 byte)
		//- trigger input (todo)
		//- heartbeat timer pulse
		//list of possible output states
		//- DISCONNECTED (via heartbeat timeout)
		//- 
		IDLE : begin
			usb.dataWidth <= 'b001;
			//handle incoming USB data and set next state if necessary
			if(usb.newDataIn) begin
				case(usb.dataIn[7:0])
					'd76 	: nextState <= LOADLEN_AWAIT;
					'd80 	: nextState <= PLAYBACK;
					'd83 	: nextState <= SETTING_AWAIT;
					'd64	: begin
						usb.dataOut <= 'd133;
						usb.newDataOut <= 'b1;
						heartbeatRst <= 'b1;
					end //i'm sorry that was really ugly but i couldn't oneline it 	
					default : nextState <= IDLE;
				endcase
			end
			if(heartbeatPulse) begin
				nextState <= DISCONNECTED;
				usb.dataOut <= 'd68;
				usb.newDataOut <= 'b1;
			end
		end
		
		LOADLEN_AWAIT : begin
			usb.dataWidth <= 'b100;
			loadPtr <= 'b0;
			if(usb.newDataIn) begin
				loadLen <= usb.dataIn;
				nextState <= LOAD;
				heartbeatRst <= 'b1;
			end
			if(heartbeatPulse) begin
				nextState <= DISCONNECTED;
			end
		end
		
		LOAD : begin
			usb.dataWidth <= 'b010; 
			if(usb.newDataIn) begin
				ddr.wr_addr <= loadPtr;
				ddr.wr_data <= {usb.dataIn[15:2], 2'b00};
				ddr.wr_valid <= 'b1;
				heartbeatRst <= 'b1;
				if(inBandSignal == 'b11) begin
					//host device instructs load stop
					nextState <= IDLE;
				end
			end
			if(heartbeatPulse) begin
				//if no response in heartbeat period, 
				//assume disconnected
				nextState <= DISCONNECTED;
			end
			//handle the load length and load pointers			
			if(loadLen == 'b0) begin
				//load finished successfully
				nextState <= IDLE;
			end else begin
				loadLen--;
				loadPtr++;
			end
		end
		
		SETTING_AWAIT : begin
			if(usb.newDataIn) begin
			
			end
		
		end	
			
	endcase
	
end

endmodule

