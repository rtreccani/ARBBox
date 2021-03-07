module heartbeat #(
	parameter CLKFREQ = 100000000
	)(
	input clk,
	output reg beat
);

reg [32:0] counter;

initial begin
	counter = 'b0;
end

always @(posedge clk) begin
	counter <= counter + 1;
	if(counter == CLKFREQ) begin
		counter <= 0;
		beat <= ~beat;
	end
end

endmodule
