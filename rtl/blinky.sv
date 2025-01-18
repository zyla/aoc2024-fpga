/* verilator lint_off UNUSEDSIGNAL */

module blinky (
input clk,
input rst,
output wire led
);

// Clock frequency in hertz.
parameter CLK_HZ = 12000000;

reg [31:0] counter;

always @(posedge clk) begin
  if(counter >= CLK_HZ)
    counter <= 0;
  else
    counter <= counter + 1;
end

assign led = counter < (CLK_HZ / 2);

endmodule
