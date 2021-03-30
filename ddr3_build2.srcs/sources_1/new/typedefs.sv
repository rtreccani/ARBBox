typedef struct {
	reg [31:0] startAddr;
	reg [31:0] endAddr;
	reg enable;
	reg [7:0] outpin;
} trigger_handle_t;


typedef struct { 
	reg [31:0] playbackLen;
	reg [31:0] loopCount;
	playmode_t loopMode;
	trigger_handle_t t1;
	trigger_handle_t t2;
} settings_t;
	
