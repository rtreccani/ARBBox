/*
   This file was generated automatically by Alchitry Labs version 1.2.5.
   Do not edit this file directly. Instead edit the original Lucid source.
   This is a temporary file and any changes made to it will be destroyed.
*/

/*
   Parameters:
     ENTRIES = 1
     WORD_SIZE = 16
     AGE_BITS = 3
*/
module lru_cache_16 (
    input clk,
    input rst,
    input [26:0] wr_addr,
    input [15:0] wr_data,
    input wr_valid,
    output reg wr_ready,
    input [26:0] rd_addr,
    input rd_cmd_valid,
    output reg rd_ready,
    output reg [15:0] rd_data,
    output reg rd_data_valid,
    input flush,
    output reg flush_ready,
    input [130:0] mem_out,
    output reg [176:0] mem_in
  );
  
  localparam ENTRIES = 1'h1;
  localparam WORD_SIZE = 5'h10;
  localparam AGE_BITS = 2'h3;
  
  
  localparam WORDS_PER_LINE = 8'h08;
  
  localparam BYTES_PER_WORD = 5'h02;
  
  localparam SUB_ADDR_BITS = 2'h3;
  
  localparam ADDR_SIZE = 6'h1b;
  
  reg [0:0] M_active_d, M_active_q = 1'h0;
  localparam IDLE_state = 3'd0;
  localparam PREP_WRITE_ENTRY_state = 3'd1;
  localparam PREP_READ_ENTRY_state = 3'd2;
  localparam FLUSH_state = 3'd3;
  localparam WRITE_DATA_state = 3'd4;
  localparam WRITE_CMD_state = 3'd5;
  localparam READ_CMD_state = 3'd6;
  localparam WAIT_READ_state = 3'd7;
  
  reg [2:0] M_state_d, M_state_q = IDLE_state;
  localparam IDLE_write_state = 1'd0;
  localparam PUT_write_state = 1'd1;
  
  reg M_write_state_d, M_write_state_q = IDLE_write_state;
  localparam IDLE_read_state = 1'd0;
  localparam FETCH_read_state = 1'd1;
  
  reg M_read_state_d, M_read_state_q = IDLE_read_state;
  reg [127:0] M_buffer_d, M_buffer_q = 1'h0;
  reg [24:0] M_address_d, M_address_q = 1'h0;
  reg [0:0] M_written_d, M_written_q = 1'h0;
  reg [7:0] M_valid_d, M_valid_q = 1'h0;
  reg [2:0] M_age_d, M_age_q = 1'h0;
  reg [0:0] M_active_entry_d, M_active_entry_q = 1'h0;
  reg [15:0] M_read_data_d, M_read_data_q = 1'h0;
  reg M_read_valid_d, M_read_valid_q = 1'h0;
  reg M_read_pending_d, M_read_pending_q = 1'h0;
  reg [26:0] M_read_addr_d, M_read_addr_q = 1'h0;
  reg M_write_pending_d, M_write_pending_q = 1'h0;
  reg [26:0] M_write_addr_d, M_write_addr_q = 1'h0;
  reg [15:0] M_write_data_d, M_write_data_q = 1'h0;
  reg [0:0] M_old_active_d, M_old_active_q = 1'h0;
  reg [2:0] M_return_state_d, M_return_state_q = 1'h0;
  
  integer i;
  
  reg handled;
  
  reg [0:0] oldest_entry;
  
  reg [0:0] entry;
  
  reg [2:0] max_age;
  
  always @* begin
    M_read_state_d = M_read_state_q;
    M_write_state_d = M_write_state_q;
    M_state_d = M_state_q;
    M_active_entry_d = M_active_entry_q;
    M_read_addr_d = M_read_addr_q;
    M_address_d = M_address_q;
    M_write_data_d = M_write_data_q;
    M_read_data_d = M_read_data_q;
    M_active_d = M_active_q;
    M_read_pending_d = M_read_pending_q;
    M_read_valid_d = M_read_valid_q;
    M_write_pending_d = M_write_pending_q;
    M_valid_d = M_valid_q;
    M_old_active_d = M_old_active_q;
    M_written_d = M_written_q;
    M_buffer_d = M_buffer_q;
    M_write_addr_d = M_write_addr_q;
    M_return_state_d = M_return_state_q;
    M_age_d = M_age_q;
    
    mem_in[31+0-:1] = 1'h0;
    mem_in[32+127-:128] = M_buffer_q;
    mem_in[28+2-:3] = 1'bx;
    mem_in[0+27-:28] = {M_address_q, 3'h0};
    mem_in[160+0-:1] = 1'h0;
    flush_ready = M_state_q == IDLE_state;
    wr_ready = M_write_state_q == IDLE_write_state;
    rd_ready = M_read_state_q == IDLE_read_state;
    rd_data = M_read_data_q;
    rd_data_valid = M_read_valid_q;
    M_read_valid_d = 1'h0;
    for (i = 1'h0; i < 8'h08; i = i + 1) begin
      mem_in[161+(i * 5'h02)*1+1-:2] = {5'h02{~M_valid_q[(M_active_entry_q)*8+(i)*1+0-:1]}};
    end
    max_age = 1'h0;
    oldest_entry = 1'h0;
    handled = 1'h0;
    for (i = 1'h0; i < 1'h1; i = i + 1) begin
      if (!handled) begin
        if (!M_active_q) begin
          oldest_entry = i;
          handled = 1'h1;
        end
        if (M_age_q > max_age) begin
          max_age = M_age_q;
          oldest_entry = i;
        end
      end
    end
    
    case (M_read_state_q)
      IDLE_read_state: begin
        if (rd_cmd_valid) begin
          for (i = 1'h0; i < 1'h1; i = i + 1) begin
            if (!((&M_age_q))) begin
              M_age_d = M_age_q + 1'h1;
            end
          end
          handled = 1'h0;
          for (i = 1'h0; i < 1'h1; i = i + 1) begin
            if (!handled && M_active_q && M_valid_q[(i)*8+(1'h1 ? rd_addr[0+2-:3] : 1'h0)*1+0-:1] && (M_address_q == rd_addr[3+23-:24])) begin
              handled = 1'h1;
              M_read_valid_d = 1'h1;
              M_read_data_d = M_buffer_q[(i)*128+(1'h1 ? rd_addr[0+2-:3] : 1'h0)*16+15-:16];
              M_age_d = 1'h0;
            end
          end
          if (!handled) begin
            M_read_pending_d = 1'h1;
            M_read_addr_d = rd_addr;
            M_read_state_d = FETCH_read_state;
          end
        end
      end
      FETCH_read_state: begin
        M_read_pending_d = 1'h1;
        handled = 1'h0;
        for (i = 1'h0; i < 1'h1; i = i + 1) begin
          if (!handled && M_active_q && M_valid_q[(i)*8+(1'h1 ? M_read_addr_q[0+2-:3] : 1'h0)*1+0-:1] && (M_address_q == M_read_addr_q[3+23-:24])) begin
            handled = 1'h1;
            M_read_valid_d = 1'h1;
            M_read_data_d = M_buffer_q[(i)*128+(1'h1 ? M_read_addr_q[0+2-:3] : 1'h0)*16+15-:16];
            M_age_d = 1'h0;
          end
        end
        if (handled) begin
          M_read_pending_d = 1'h0;
          M_read_state_d = IDLE_read_state;
        end
      end
    endcase
    
    case (M_write_state_q)
      IDLE_write_state: begin
        if (wr_valid) begin
          for (i = 1'h0; i < 1'h1; i = i + 1) begin
            if (!((&M_age_q))) begin
              M_age_d = M_age_q + 1'h1;
            end
          end
          handled = 1'h0;
          for (i = 1'h0; i < 1'h1; i = i + 1) begin
            if (!handled && M_active_q && (M_address_q == wr_addr[3+23-:24])) begin
              handled = 1'h1;
              M_written_d = 1'h1;
              M_valid_d[(i)*8+(1'h1 ? wr_addr[0+2-:3] : 1'h0)*1+0-:1] = 1'h1;
              M_buffer_d[(i)*128+(1'h1 ? wr_addr[0+2-:3] : 1'h0)*16+15-:16] = wr_data;
              M_age_d = 1'h0;
            end
          end
          if (!handled) begin
            M_write_pending_d = 1'h1;
            M_write_data_d = wr_data;
            M_write_addr_d = wr_addr;
            M_write_state_d = PUT_write_state;
          end
        end
      end
      PUT_write_state: begin
        M_write_pending_d = 1'h1;
        handled = 1'h0;
        for (i = 1'h0; i < 1'h1; i = i + 1) begin
          if (!handled && M_active_q && (M_address_q == M_write_addr_q[3+23-:24])) begin
            handled = 1'h1;
            M_written_d = 1'h1;
            M_valid_d[(i)*8+(1'h1 ? M_write_addr_q[0+2-:3] : 1'h0)*1+0-:1] = 1'h1;
            M_buffer_d[(i)*128+(1'h1 ? M_write_addr_q[0+2-:3] : 1'h0)*16+15-:16] = M_write_data_q;
            M_age_d = 1'h0;
          end
        end
        if (handled) begin
          M_write_pending_d = 1'h0;
          M_write_state_d = IDLE_write_state;
        end
      end
    endcase
    
    case (M_state_q)
      IDLE_state: begin
        if (flush) begin
          M_active_d = 1'h0;
          M_old_active_d = M_active_q;
          M_state_d = FLUSH_state;
        end else begin
          if (M_read_pending_q) begin
            entry = oldest_entry;
            handled = 1'h0;
            for (i = 1'h0; i < 1'h1; i = i + 1) begin
              if (!handled && M_active_q && M_valid_q[(i)*8+(1'h1 ? M_read_addr_q[0+2-:3] : 1'h0)*1+0-:1] && (M_address_q == M_read_addr_q[3+23-:24])) begin
                handled = 1'h1;
                entry = i;
              end
            end
            M_active_entry_d = entry;
            if (M_active_q && M_address_q != M_read_addr_q[3+23-:24]) begin
              M_active_d = 1'h0;
              M_state_d = PREP_READ_ENTRY_state;
            end else begin
              M_state_d = READ_CMD_state;
              M_address_d = M_read_addr_q[3+23-:24];
              if (M_address_q != M_read_addr_q[3+23-:24]) begin
                M_valid_d = 1'h0;
              end
            end
          end else begin
            if (M_write_pending_q) begin
              if (M_active_q) begin
                M_active_d = 1'h0;
                M_active_entry_d = oldest_entry;
                M_state_d = PREP_WRITE_ENTRY_state;
              end else begin
                M_written_d = 1'h0;
                M_valid_d = 1'h0;
                M_address_d = M_write_addr_q[3+23-:24];
                M_age_d = 1'h0;
                M_active_d = 1'h1;
                M_write_pending_d = 1'h0;
              end
            end
          end
        end
      end
      PREP_WRITE_ENTRY_state: begin
        if (M_written_q) begin
          M_return_state_d = PREP_WRITE_ENTRY_state;
          M_state_d = WRITE_DATA_state;
        end else begin
          M_written_d = 1'h0;
          M_valid_d = 1'h0;
          M_address_d = M_write_addr_q[3+23-:24];
          M_age_d = 1'h0;
          M_active_d = 1'h1;
          M_state_d = IDLE_state;
          M_write_pending_d = 1'h0;
        end
      end
      PREP_READ_ENTRY_state: begin
        if (M_written_q) begin
          M_return_state_d = PREP_READ_ENTRY_state;
          M_state_d = WRITE_DATA_state;
        end else begin
          M_state_d = READ_CMD_state;
          M_address_d = M_read_addr_q[3+23-:24];
          M_valid_d = 1'h0;
        end
      end
      FLUSH_state: begin
        M_state_d = IDLE_state;
        handled = 1'h0;
        for (i = 1'h0; i < 1'h1; i = i + 1) begin
          if (!handled && M_old_active_q && M_written_q) begin
            handled = 1'h1;
            M_active_entry_d = i;
            M_state_d = WRITE_DATA_state;
            M_old_active_d = 1'h0;
            M_return_state_d = FLUSH_state;
          end
        end
      end
      WRITE_DATA_state: begin
        mem_in[160+0-:1] = 1'h1;
        if (mem_out[130+0-:1]) begin
          M_state_d = WRITE_CMD_state;
        end
      end
      WRITE_CMD_state: begin
        mem_in[31+0-:1] = 1'h1;
        mem_in[28+2-:3] = 1'h0;
        if (mem_out[129+0-:1]) begin
          M_state_d = M_return_state_q;
          M_written_d = 1'h0;
        end
      end
      READ_CMD_state: begin
        mem_in[31+0-:1] = 1'h1;
        mem_in[28+2-:3] = 1'h1;
        if (mem_out[129+0-:1]) begin
          M_state_d = WAIT_READ_state;
        end
      end
      WAIT_READ_state: begin
        if (mem_out[128+0-:1]) begin
          for (i = 1'h0; i < 8'h08; i = i + 1) begin
            if (!M_valid_q[(M_active_entry_q)*8+(i)*1+0-:1]) begin
              M_buffer_d[(M_active_entry_q)*128+(i)*16+15-:16] = mem_out[0+(5'h10 * i)*1+15-:16];
            end
          end
          M_active_d = 1'h1;
          M_valid_d = 8'hff;
          M_age_d = 1'h0;
          M_read_pending_d = 1'h0;
          M_written_d = 1'h0;
          M_state_d = IDLE_state;
        end
      end
    endcase
  end
  
  always @(posedge clk) begin
    M_buffer_q <= M_buffer_d;
    M_address_q <= M_address_d;
    M_written_q <= M_written_d;
    M_valid_q <= M_valid_d;
    M_age_q <= M_age_d;
    M_active_entry_q <= M_active_entry_d;
    M_read_data_q <= M_read_data_d;
    M_read_valid_q <= M_read_valid_d;
    M_read_pending_q <= M_read_pending_d;
    M_read_addr_q <= M_read_addr_d;
    M_write_pending_q <= M_write_pending_d;
    M_write_addr_q <= M_write_addr_d;
    M_write_data_q <= M_write_data_d;
    M_old_active_q <= M_old_active_d;
    M_return_state_q <= M_return_state_d;
    
    if (rst == 1'b1) begin
      M_active_q <= 1'h0;
      M_state_q <= 1'h0;
      M_write_state_q <= 1'h0;
      M_read_state_q <= 1'h0;
    end else begin
      M_active_q <= M_active_d;
      M_state_q <= M_state_d;
      M_write_state_q <= M_write_state_d;
      M_read_state_q <= M_read_state_d;
    end
  end
  
endmodule
