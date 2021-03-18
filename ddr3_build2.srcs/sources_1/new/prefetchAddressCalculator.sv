`timescale 1ns / 1ps

//takes in the current address, and a maximum at which the prefetch
//should load in the first line of memory for a 'loop'.
//outputs a line-aligned memory address.
module prefetchAddressCalculator(
	input [31:0] currentAddress,
	input [31:0] maxAddress,
	output [23:0] nextLineAddress,
	output reg cacheLineEnd
);

wire [23:0] currentBlockAddress;
wire [23:0] maxBlockAddress;
reg [23:0] outputBlockAddress;

assign currentBlockAddress = currentAddress [27:4];
assign maxBlockAddress = maxAddress [27:4];

initial begin
	outputBlockAddress <= 'b0;
end

always @(*) begin
	cacheLineEnd <= 'b0;
	outputBlockAddress <= currentBlockAddress + 'b1;
	if(currentBlockAddress <= maxBlockAddress) begin
		outputBlockAddress <= 'b0;
	end
	//flag raised at the end of a cache line to dirty the cache
	if(currentAddress % 'b10000 == 'b01111) begin
		cacheLineEnd <= 'b1;
	end
end	
endmodule
