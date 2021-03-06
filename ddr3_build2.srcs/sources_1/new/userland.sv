module userland(
	ddr3_IF ddr,
	io_IF io,
	input clk
);

reg [7:0] currentAddress;
reg [7:0] newAddress;

typedef enum {R, W, R_DELAY, W_DELAY} state_e;

state_e currentState;
state_e newState;
reg [31:0] counter;
reg slowClk;

initial begin
	counter = 'b0;
	currentAddress = 'b0;
	currentState = R;
end


always @(posedge clk) begin 
	counter <= counter + 1;
	if (counter == 'd100000000) begin
		counter <= 0;
		slowClk <= ~slowClk;
	end
end 

always @(posedge slowClk) begin
	case(currentState)
		R : begin
			if(currentAddress == 'hFF) begin
				newAddress <= 'h00;
				newState <= W;
				ddr.wr_valid = 'b0;
			end else begin
				newAddress <= newAddress + 1;	
				ddr.wr_valid = 'b1;
			end
		end
	endcase
end





endmodule

