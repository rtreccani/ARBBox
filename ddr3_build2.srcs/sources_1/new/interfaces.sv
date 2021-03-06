interface ddr3_IF;
	logic [27:0] wr_addr;
	logic [7:0] wr_data;
	logic wr_valid;
	logic wr_ready;
	logic [27:0] rd_addr;
	logic rd_cmd_valid;
	logic rd_ready;
	logic [7:0] rd_data;
	logic rd_data_valid;
	logic flush;
	logic flush_ready;
endinterface : ddr3_IF
 
 
 interface io_IF;
 	logic [7:0] sys_led;
 	logic [23:0] led;
 	logic [7:0]  seg;
 	logic [3:0] sel;
 	logic [4:0] button;
 	logic [23:0] dip;
 endinterface : io_IF