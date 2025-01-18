/* verilator lint_off UNUSEDSIGNAL */

module toplevel (
input               clk     , // Top level system clock input.
input               sw_0    , // Button - for reset
output wire led_0,
input   wire        uart_rxd, // UART Recieve pin.
output  wire        uart_txd  // UART transmit pin.
);


// Clock frequency in hertz.
parameter CLK_HZ = 12000000;
parameter BIT_RATE =   115200;
parameter PAYLOAD_BITS = 8;

wire [PAYLOAD_BITS-1:0]  uart_rx_data;
wire        uart_rx_valid;
wire        uart_rx_break;

wire        uart_tx_busy;
wire [PAYLOAD_BITS-1:0]  uart_tx_data;
wire        uart_tx_en;

wire rst;

assign rst = sw_0;

blinky blinky_ (
  .clk(clk),
  .rst(rst),
  .led(led_0)
);

puzzle puzzle_ (
  .rst (rst),
  .clk (clk),
  .output_data (uart_tx_data),
  .output_en (uart_tx_en),
  .output_busy (uart_tx_busy),
  .input_data (uart_rx_data),
  .input_valid (uart_rx_valid)
);

// ------------------------------------------------------------------------- 

//
// UART R:X
uart_rx #(
.BIT_RATE(BIT_RATE),
.PAYLOAD_BITS(PAYLOAD_BITS),
.CLK_HZ  (CLK_HZ  )
) i_uart_rx(
.clk          (clk          ), // Top level system clock input.
.resetn       (!rst         ), // Asynchronous active low reset.
.uart_rxd     (uart_rxd     ), // UART Recieve pin.
.uart_rx_en   (1'b1         ), // Recieve enable
.uart_rx_break(uart_rx_break), // Did we get a BREAK message?
.uart_rx_valid(uart_rx_valid), // Valid data recieved and available.
.uart_rx_data (uart_rx_data )  // The recieved data.
);

//
// UART Transmitter module.
//
uart_tx #(
.BIT_RATE(BIT_RATE),
.PAYLOAD_BITS(PAYLOAD_BITS),
.CLK_HZ  (CLK_HZ  )
) i_uart_tx(
.clk          (clk          ),
.resetn       (!rst         ),
.uart_txd     (uart_txd     ),
.uart_tx_en   (uart_tx_en   ),
.uart_tx_busy (uart_tx_busy ),
.uart_tx_data (uart_tx_data ) 
);


endmodule
