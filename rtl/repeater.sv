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
        end else begin
          state <= INITIAL;
        end
      end
      SEND: begin
        if(!output_busy) begin
          if(n_to_send > 0) begin
            state <= SENDING;
            n_to_send <= n_to_send - 1;
          end else begin
            state <= INITIAL;
          end
        end
      end
      SENDING: begin
        if(!output_busy) begin
          state <= SEND;
        end
      end
    endcase
    end
  end
  
  always_comb begin
    case(state)
      INITIAL: begin
        output_en = 0;
      end
      SEND: begin
        if(!output_busy) begin
          if(n_to_send > 0) begin
            output_data = "B";
            output_en = 1;
          end else begin
            output_en = 0;
          end
        end else begin
          output_en = 0;
        end
      end
      SENDING: begin
        output_en = 0;
      end
    endcase
  end

endmodule
