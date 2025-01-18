/* verilator lint_off UNUSEDSIGNAL */

module puzzle
#( parameter                W = 32)  // value register width
(
    input clk,
    input rst,

    input wire       input_valid,  // Valid data recieved and available.
    input wire  [7:0] input_data,   // The recieved data.

    input  wire       output_busy,  // Module busy sending previous item.
    output logic       output_en,    // Send the data on output_data
    output logic [7:0] output_data   // The data to be sent
);

  enum { PARSING_1, PARSING_2, SENDING, NEWLINE } state;

  reg [W-1:0] value_1 = 0;
  reg [W-1:0] value = 0;
  reg [3:0] n_to_send = 0;

  localparam W_BCD = ((W + 3) / 4) * 4;

  reg [W_BCD-1:0] value_bcd = 0;

  logic [W-1:0] computation_result = value_1 + value;

  wire [W_BCD-1:0] value_bcd_computed;
  bin2bcd #(
    .N(W)
  ) bin2bcd_ (
    .binary_in(computation_result),
    .bcd_out(value_bcd_computed)
  );

  always @(posedge clk) begin
    if (rst) begin
      value <= 0;
      n_to_send <= 0;
      state <= PARSING_1;
    end else begin
      case(state)
        PARSING_1, PARSING_2: begin
          if (input_valid) begin
            if(input_data == "\n") begin
              value <= 0;
              case(state)
                PARSING_1: begin
                  value_1 <= value;
                  state <= PARSING_2;
                end
                PARSING_2: begin
                  value_bcd <= value_bcd_computed;
                  n_to_send <= 4'(W_BCD/4);
                  state <= SENDING;
                end
              endcase
            end else if (input_data >= "0" && input_data <= "9") begin
              value <= (value << 3) + (value << 1) + 32'(input_data) - "0";
            end else begin
              // TODO: print error
            end
          end
        end
        SENDING: begin
          if(!output_busy) begin
            if(n_to_send > 0) begin
              n_to_send <= n_to_send - 1;
              value_bcd <= value_bcd << 4;
            end else begin
              state <= NEWLINE;
            end
          end
        end
        NEWLINE: begin
          if(!output_busy) begin
            state <= PARSING_1;
          end
        end
      endcase
    end
  end
  
  always_comb begin
    case(state)
      PARSING_1, PARSING_2: begin
        output_en = 0;
      end
      SENDING: begin
        output_en = n_to_send > 0;
        output_data = 8'(value_bcd[W_BCD-1:W_BCD-4]) + "0";
      end
      NEWLINE: begin
        output_en = 1;
        output_data = "\n";
      end
    endcase
  end

endmodule
