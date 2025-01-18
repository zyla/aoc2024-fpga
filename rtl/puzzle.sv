/* verilator lint_off UNUSEDSIGNAL */

module puzzle (
    input clk,
    input rst,

    input wire       input_valid,  // Valid data recieved and available.
    input wire  [7:0] input_data,   // The recieved data.

    input  wire       output_busy,  // Module busy sending previous item.
    output reg       output_en,    // Send the data on output_data
    output reg [7:0] output_data   // The data to be sent
);

  reg [7:0] n_to_send = 0;

  enum { INITIAL, SEND, SENDING } state = INITIAL;

  always @(posedge clk) begin
    if (rst) begin
      n_to_send <= 0;
      state <= INITIAL;
    end else begin
      case(state)
        INITIAL: begin
          if (input_valid && input_data >= "0" && input_data <= "9") begin
            state <= SEND;
            n_to_send <= input_data - "0";
          end
          output_en <= 0;
        end
        SEND: begin
          output_en <= 0;
          if(!output_busy) begin
            if(n_to_send > 0) begin
              state <= SENDING;
              output_data <= "A";
              output_en <= 1;
              n_to_send <= n_to_send - 1;
            end else begin
              state <= INITIAL;
            end
          end
        end
        SENDING: begin
          output_en <= 0;
          if(!output_busy) begin
            state <= SEND;
          end
        end
      endcase
    end
  end

endmodule
