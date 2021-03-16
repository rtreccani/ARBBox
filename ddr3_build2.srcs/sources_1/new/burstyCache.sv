`timescale 1ns / 1ps
module burstyCache(
	input clk,
	input sys_rst,
	ddr3_native_IF ddr,
	burstCache_IF bc
);

reg [15:0] cacheLines [16];
reg [3:0] cachePtr;

reg [23:0] externalPtr;
reg line1Dirty;
reg line2Dirty;

typedef enum {
	IDLE,
	WBANK1,
	WBANK2,
	RBANK1,
	RBANK2
} state_t;

state_t currentState;
state_t nextState;


always @(posedge clk) begin
	if(bc.ptrRst) begin
		cachePtr <= 'b0;
		externalPtr <= 'b0;
	end
	currentState <= nextState;
	
	case(currentState)
		IDLE : begin
			if(ptrIncrement) begin
				if(writeEnable) begin
					nextState <= WBANK1;
				end else begin
					nextState <= RBANK1;
					
end 
endmodule
