typedef struct packed{
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
} ui_memory_t;