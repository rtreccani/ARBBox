`timescale 1ns / 1ps

module usbWidthSelector_tb(
    );
    
logic [7:0] byteIn;
logic newByteIn;
logic [2:0] byteWidth;
logic rst;
logic [31:0] wordOut;
logic newWordOut;

usbWidthSelector u(.*);

initial begin
	rst <= 'b0;
	byteWidth <= 'b001;
	#160
	byteWidth <= 'b010;
	#320 
	byteWidth <= 'b100;
	#620
	byteWidth <= 'b001;
end

always begin
	rst <='b0;
	#10 
	newByteIn = 'b1;
	byteIn = $urandom;
	#10
	newByteIn = 'b0;
end
endmodule
