module heartbeat #(
	parameter CLKFREQ = 100000000
	)(
	input clk,
	input rst,
	output reg beat
);

reg [32:0] counter;

initial begin
	counter = 'b0;
end

always @(posedge clk, posedge rst) begin
	counter <= counter + 1;
	beat <= 'b0;
	if(counter == CLKFREQ) begin
		counter <= 0;
		beat <= 'b1;
	end
	if(rst) begin
		counter <= 0;
		beat <= 'b0;
	end
end

endmodule
