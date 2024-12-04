module puzzle (
    input clk,
    input rst,

    input wire       input_valid,  // Valid data recieved and available.
    input wire  [7:0] input_data,   // The recieved data.

    input  wire       output_busy,  // Module busy sending previous item.
    output reg       output_en,    // Send the data on output_data
    output reg [7:0] output_data   // The data to be sent
);

  always @(posedge clk) begin
    if (rst) begin
      // reset
    end else begin
      if (input_valid && !output_busy) begin
        output_en <= 1;
        output_data <= input_data >= "a" && input_data <= "z" ? input_data - 32 : input_data;
      end
    end
  end

endmodule
