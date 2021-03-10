`timescale 1ns / 1ps

module usbWidthSelector_tb(
    );
   
logic clk;
logic [7:0] byteIn;
logic newByteIn;
logic [2:0] byteWidth;
logic rst;
logic [31:0] wordOut;
logic newWordOut;
logic available;

usbWidthSelector u(.*);

initial begin
	clk <= 'b0;
	rst <= 'b0;
	byteWidth <= 'b001;
	#1600
	byteWidth <= 'b010;
	#3200
	byteWidth <= 'b100;
	#6200
	byteWidth <= 'b001;
end


always begin
	#10 clk = ~clk;
	
end

always begin
	rst <='b0;
	#100
	newByteIn = 'b1;
	byteIn = $urandom;
	#100
	newByteIn = 'b0;
end
endmodule
