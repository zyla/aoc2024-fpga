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

  enum { INITIAL, SENDING } state;

  reg [31:0] value = 0;
  reg [3:0] n_to_send = 0;

  wire [3:0] nibble_to_send = value[31:28];

  always @(posedge clk) begin
    if (rst) begin
      value <= 0;
      n_to_send <= 0;
      state <= INITIAL;
    end else begin
      case(state)
        INITIAL: begin
          if (input_valid) begin
            value <= 'hdead1234;
            n_to_send <= 8;
            state <= SENDING;
          end
        end
        SENDING: begin
          if(!output_busy) begin
            if(n_to_send > 0) begin
              n_to_send <= n_to_send - 1;
              value <= {value[27:0], 4'b0};
            end else begin
              state <= INITIAL;
            end
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
      SENDING: begin
        output_en = n_to_send > 0;
        output_data =
          nibble_to_send < 10 ?
            8'(nibble_to_send) + "0" :
            (8'(nibble_to_send) - 10 + "a");
      end
    endcase
  end

endmodule
