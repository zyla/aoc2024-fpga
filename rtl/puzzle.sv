/* verilator lint_off UNUSEDSIGNAL */

module puzzle (
    input clk,
    input rst,

    input wire       input_valid,  // Valid data recieved and available.
    input wire  [7:0] input_data,   // The recieved data.

    input  wire       output_busy,  // Module busy sending previous item.
    output logic       output_en,    // Send the data on output_data
    output logic [7:0] output_data   // The data to be sent
);

  reg [7:0] n_to_send = 0;
  typedef enum { INITIAL, SEND, SENDING } State;
  State state = INITIAL;

  State next_state;
  logic [7:0] next_n_to_send;

  always @(posedge clk) begin
    if (rst) begin
      n_to_send <= 0;
      state <= INITIAL;
    end else begin
      state <= next_state;
      n_to_send <= next_n_to_send;
    end
  end

  always_comb begin
    case(state)
      INITIAL: begin
        if (input_valid && input_data >= "0" && input_data <= "9") begin
          next_state = SEND;
          next_n_to_send = input_data - "0";
        end else begin
          next_state = INITIAL;
        end
        output_en = 0;
      end
      SEND: begin
        if(!output_busy) begin
          if(n_to_send > 0) begin
            next_state = SENDING;
            output_data = "A";
            output_en = 1;
            next_n_to_send = n_to_send - 1;
          end else begin
            next_state = INITIAL;
            output_en = 0;
          end
        end else begin
          output_en = 0;
        end
      end
      SENDING: begin
        output_en = 0;
        if(!output_busy) begin
          next_state = SEND;
        end
      end
    endcase
  end

endmodule
