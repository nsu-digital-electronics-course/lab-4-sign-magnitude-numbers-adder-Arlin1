`timescale 1ns / 1ps

module summator #(
    parameter SIZE = 8
) (
    input  logic [SIZE-1:0] a,
    input  logic [SIZE-1:0] b,
    output logic [SIZE-1:0] s,
    output logic            overflow
);

    logic a_sign, b_sign;
    logic [SIZE-2:0] a_mag, b_mag;
    logic [SIZE-2:0] mag_sum, mag_diff;
    logic [SIZE-2:0] res_mag;
    logic res_sign;
    logic carry_out;
    logic a_mag_gt_b;

    assign a_sign = a[SIZE-1];
    assign b_sign = b[SIZE-1];
    assign a_mag  = a[SIZE-2:0];
    assign b_mag  = b[SIZE-2:0];

    assign {carry_out, mag_sum} = a_mag + b_mag;

    assign mag_diff = (a_mag >= b_mag) ? (a_mag - b_mag) : (b_mag - a_mag);
    assign a_mag_gt_b = (a_mag > b_mag);

    always_comb begin
        overflow = 1'b0;
        res_mag  = '0;
        res_sign = 1'b0;

        if (a_sign == b_sign) begin
            res_mag = mag_sum;
            res_sign = a_sign;

            if (carry_out) begin
                overflow = 1'b1;
            end
        end else begin
            res_mag = mag_diff;
            
            if (a_mag == b_mag) begin
                res_sign = 1'b0;
            end else if (a_mag_gt_b) begin
                res_sign = a_sign;
            end else begin
                res_sign = b_sign;
            end
            
            overflow = 1'b0;
        end

        if (res_mag == '0) begin
            res_sign = 1'b0;
        end

        s = {res_sign, res_mag};
    end

endmodule
