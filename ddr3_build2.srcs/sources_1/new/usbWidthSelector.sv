`timescale 1ns / 1ps


module usbWidthSelector(
	input rst,
	input [2:0] byteWidth,
	input [7:0] byteIn,
	input newByteIn,
	output reg [31:0] wordOut,
	output reg newWordOut
);

reg [31:0] FIFO;
reg [2:0] avail;

initial begin
	avail <= 'b0;
end

always @(posedge newByteIn) begin
	if(rst) begin
		avail <= 'b0;
		newWordOut <= 'b0;
	end else begin
		newWordOut <= 'b0;
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

always @(negedge newByteIn) begin
	newWordOut <='b0;
end

endmodule
