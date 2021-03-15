module userland(
	ddr3_IF ddr,
	io_IF io,
	usb_IF usb,
	input rst,
	input clk
);

reg [31:0] counter;

reg [23:0] val;

reg [5:0] oneCold;

initial begin 
	val <= 'b100110101100111001101111;
	counter <= 'b0;
	oneCold <= 'b011111;
end

wire [47:0] tmp;
assign io.led = val;
assign tmp = (val*val);

assign io.seg = {2'b11, oneCold[5:0]};
assign io.sel = {counter[16], ~counter[16], 0,0};

always @(posedge clk) begin
	counter <= counter + 1;
	if(counter > {io.dip, 3'b1}) begin
		if(val == (tmp[35:12])) begin
			val <= 'b100110101100111001101111; //reset
			oneCold <= {oneCold[0], oneCold[5:1]};
		end else begin
			val <= tmp[35:12]; //make an von neumann PRNG
		end
		oneCold <= {oneCold[0], oneCold[5:1]};
		counter <= 0;
	end
	
	if(rst) begin
		val <= 'b100110101100111001101111;
		counter <= 'b0;
	end
end

endmodule

