module bin2bcd #(
    parameter N = 8,  // Width of binary input
    parameter DIGITS = ((N + 3) / 4) // Number of BCD digits needed
) (
    input  [N-1:0] binary_in,  // Binary input
    output [DIGITS*4-1:0] bcd_out // BCD output
);

    // Intermediate registers for shifting and BCD storage
    reg [N + DIGITS*4 - 1:0] shift_reg;
    integer i, j;

    // Combinational logic
    always @(*) begin
        // Initialize shift register: concatenate binary input and zeroed BCD digits
        shift_reg = { {(DIGITS*4){1'b0}}, binary_in };

        // Perform Double Dabble algorithm
        for (i = 0; i < N; i = i + 1) begin
            // Check each BCD digit for >= 5 and add 3 if true
            for (j = DIGITS-1; j >= 0; j = j - 1) begin
                if (shift_reg[N + j*4 +: 4] >= 5)
                    shift_reg[N + j*4 +: 4] = shift_reg[N + j*4 +: 4] + 3;
            end

            // Shift left by 1 bit
            shift_reg = shift_reg << 1;
        end
    end

    // Assign the BCD portion of the shift register to the output
    assign bcd_out = shift_reg[N +: DIGITS*4];

endmodule

