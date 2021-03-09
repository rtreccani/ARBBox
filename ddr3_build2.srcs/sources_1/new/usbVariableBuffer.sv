module usbVariableBuffer(
	input clk,
	input rst,
	//usb Rx
	input [7:0] usbRx,
	input newRx,
	
	output reg  [7:0] byteRx,
	output reg byteAvail,
	input takeByte,
	
	output reg [15:0] wordRx,
	output reg wordAvail,
	input takeWord,
	
	output reg [31:0] longRx,
	output reg longAvail,
	input takeLong
    );
    
reg [7:0] FIFO [4];

typedef enum {
	IDLE,
	ONE,
	TWO,
	THREE,
	FOUR,
	BLOCK
} state_t;

state_t currentState;
state_t nextState;

initial begin 
	currentState <= IDLE;
	nextState <= IDLE;
end

always @(posedge clk) begin
	currentState <= nextState;
	if(rst) begin
		currentState <= IDLE;
		nextState <= IDLE;
	end else begin
		case(currentState)
			IDLE : begin
				if(newRx) begin
					FIFO[0] <= usbRx;
					nextState <= ONE;
					byteAvail <= 'b1;
				end
			end
			
			ONE : begin
				if(takeByte) begin
					byteRx <= FIFO[0];
					nextState <= IDLE;
					byteAvail <= 'b0;
				end
				if(newRx) begin
					FIFO[1] <= usbRx;
					nextState <= TWO;
					wordAvail <= 'b1;
				end
				if(takeByte & newRx) begin
					FIFO[0] <= newRx;
					byteRx <= usbRx;
				end
			end
			
			TWO : begin
				if(usbRx) begin
					FIFO[2] <= usbRx;
					nextState <= THREE;
				end
				if(takeByte) begin
					byteRx <= FIFO[0];
					FIFO[0] <= FIFO[1];
					nextState <= ONE;
					wordAvail <= 'b0;
				end
				if(takeWord) begin
					wordRx <= {FIFO[1], FIFO[0]};
					nextState <= IDLE;
					//don't care if the buffer data is dirty in this instance
					wordAvail <= 'b0;
					byteAvail <= 'b0;
				end
				if(takeByte & usbRx) begin
					byteRx <= FIFO[0];
					FIFO[0] <= FIFO[1];
					FIFO[1] <= usbRx;
				end
				if(takeWord & usbRx) begin
					wordRx <= {FIFO[1], FIFO[0]};
					FIFO[0] <= usbRx;
					nextState <= ONE;
					wordAvail <= 'b0;
				end
			end
			
			THREE : begin
				if(newRx) begin
					FIFO[3] <= usbRx;
					nextState <= FOUR;
					longAvail <= 'b1;
				end
				if(takeByte) begin
					byteRx <= FIFO[0];
					FIFO[0] <= FIFO[1];
					FIFO[1] <= FIFO[2];
					nextState <= TWO;
				end
				if(takeWord) begin
					wordRx <= {FIFO[1], FIFO[0]};
					FIFO[0] <= FIFO[2];
					wordAvail <='b0;
					nextState <= ONE;
				end
				if(takeByte & newRx) begin
					byteRx <= FIFO[0];
					FIFO[0] <= FIFO[1];
					FIFO[1] <= FIFO[2];
					FIFO[2] <= usbRx;
				end
				if(takeWord & newRx) begin
					wordRx <= {FIFO[1], FIFO[0]};
					FIFO[0] <= FIFO[2];
					FIFO[2] <= usbRx;
					nextState <= TWO;
				end
			end
			
			FOUR : begin
				if(takeByte) begin
					longAvail <= 'b0;
					byteRx <= FIFO[0];
					nextState <= THREE;
					FIFO[0] <= FIFO[1];
					FIFO[1] <= FIFO[2];
					FIFO[2] <= FIFO[3];
					FIFO[3] <= 'b0;
				end
				if(takeWord) begin
					longAvail <= 'b0;
					wordRx <= {FIFO[1], FIFO[0]};
					nextState <= TWO;
					FIFO[0] <= FIFO[2];
					FIFO[1] <= FIFO[3];
				end
				if(takeLong) begin
					longAvail <= 'b0;
					wordAvail <= 'b0;
					byteAvail <= 'b0;
					nextState <= IDLE;
					longRx <= {FIFO[3], FIFO[2], FIFO[1], FIFO[0]};
					//don't care about the FIFO since it's dirty now
				end
			end
		endcase
	end
end			
				
endmodule
