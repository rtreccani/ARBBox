module userland(
	ddr3_IF ddr,
	io_IF io,
	usb_IF usb,
	input rst,
	input clk
);

reg [31:0] counter;

reg [23:0] val;

initial begin 
	val <= 'b100110101100111001101111;
	counter <= 'b0;
end

wire [47:0] tmp;
assign io.led = val;
assign tmp = (val*val);

always @(posedge clk) begin
	counter <= counter + 1;
	if(counter > {io.dip, 3'b1}) begin
		if(val == (tmp[35:12])) begin
			val <= ~(tmp[35:12]);
		end else begin
			val <= tmp[35:12]; //make an oppenheimer PRNG
		end
		counter <= 0;
	end
	
	if(rst) begin
		val <= 'b100110101100111001101111;
		counter <= 'b0;
	end
end

endmodule

