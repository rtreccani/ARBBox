`timescale 1ns / 1ps


module usbWidthSelector(
	input clk,
	input rst,
	input [2:0] byteWidth,
	input [7:0] byteIn,
	input newByteIn,
	output reg [31:0] wordOut,
	output reg newWordOut,
	output [2:0] available
);

reg [31:0] FIFO;
reg [2:0] avail;
initial begin
	avail <= 'b0;
end

assign available = avail;


always @(posedge clk) begin
	newWordOut <= 'b0;
	if(rst) begin
		avail <= 'b0;
	end else begin
		if(newByteIn) begin
			if (avail == byteWidth - 1) begin
				newWordOut <= 'b1;
				wordOut <= {FIFO[23:0], byteIn};
				avail <= 'b000;
				FIFO <= 32'b0;
			end else begin
				avail <= avail + 1;
				FIFO <= {FIFO[23:0], byteIn};
			end
		end
	end
end


endmodule
