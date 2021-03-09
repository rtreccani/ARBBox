module usbVariableBuffer_tb(
);

logic clk;
logic rst;
logic [7:0] usbRx;
logic newRx;
logic takeByte;
logic [7:0] byteRx;
logic [15:0] wordRx;
logic [31:0] longRx;
logic takeWord;
logic takeLong;
logic byteAvail;
logic wordAvail;
logic longAvail;


usbVariableBuffer b(.*);


default clocking @(posedge clk); endclocking
always #10 clk++;

initial begin
	clk <= 0;
	rst <= 0;
	usbRx <= 0;
	newRx <= 0;
	takeByte <= 0;
	takeWord <= 0;
	takeLong <= 0;

	#8 
	usbRx <= 'd13;
	newRx <= 'b1;
	#10
	newRx <= 'b0;
	#10
	#20
	takeByte <= 'b1;
	#10
	takeByte <= 'b0;
	#10
	usbRx <= 'd19;
	newRx <= 'b1;
	#20
	usbRx <= 'd22;
	#20
	usbRx <= 'd22;
	#10 
	takeWord <= 'b1;
	newRx <= 'b0;
end







endmodule
