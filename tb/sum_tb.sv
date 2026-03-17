`timescale 1ns / 1ps

module sum_tb;

    parameter SIZE = 5;

    logic [SIZE-1:0] a, b;
    logic [SIZE-1:0] s;
    logic            overflow;

    summator #(.SIZE(SIZE)) dut (
        .a(a),
        .b(b),
        .s(s),
        .overflow(overflow)
    );

    task check_result;
        input [SIZE-1:0] val_a, val_b;
        input [SIZE-1:0] expected_s;
        input            expected_ovf;
        input string           test_name;
        
        begin
            a = val_a;
            b = val_b;
            #10;
            
            if (s !== expected_s || overflow !== expected_ovf) begin
                $display("[FAIL] %s", test_name);
                $display("  Inputs: A=%b (%d), B=%b (%d)", a, a, b, b);
                $display("  Expected: S=%b, OV=%b", expected_s, expected_ovf);
                $display("  Got:      S=%b, OV=%b", s, overflow);
                $error("Test failed!");
            end else begin
                $display("[PASS] %s", test_name);
            end
        end
    endtask

    initial begin
        $display("Starting Sign-Magnitude Adder Tests (SIZE=%0d)...", SIZE);
        $display("Format: [Sign][Magnitude]");

        check_result(5'b00101, 5'b00011, 5'b01000, 1'b0, "Pos + Pos (No Overflow)");
        check_result(5'b01111, 5'b00001, 5'b00000, 1'b1, "Pos + Pos (Overflow)");
        check_result(5'b10101, 5'b10011, 5'b11000, 1'b0, "Neg + Neg (No Overflow)");
        check_result(5'b11111, 5'b10001, 5'b00000, 1'b1, "Neg + Neg (Overflow)");
        check_result(5'b01010, 5'b10011, 5'b00111, 1'b0, "Pos + Neg (Pos Result)");
        check_result(5'b00011, 5'b11010, 5'b10111, 1'b0, "Pos + Neg (Neg Result)");
        check_result(5'b00101, 5'b10101, 5'b00000, 1'b0, "Pos + Neg = Zero");
        check_result(5'b00000, 5'b00000, 5'b00000, 1'b0, "+0 + +0");
        check_result(5'b00000, 5'b10000, 5'b00000, 1'b0, "+0 + -0 (Normalization)");
        check_result(5'b10000, 5'b10000, 5'b00000, 1'b0, "-0 + -0 (Normalization)");
        check_result(5'b01111, 5'b11111, 5'b00000, 1'b0, "Max + Min = Zero");

        $display("\nAll tests completed.");
        $finish;
    end

endmodule
