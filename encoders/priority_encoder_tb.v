`timescale 1ns / 1ps
module priority_encoder_tb;

reg [7:0] in;
wire [2:0] out;

priority_encoder DUT(
    .in(in),
    .out(out)
);

initial begin
#100
in = 8'b0000_0000;
#1 $display("Input: %b   Output: %b",in,out);
#10
in = 8'b0000_0001;
#1 $display("Input: %b   Output: %b",in,out);
#10
in = 8'b0000_1000;
#1 $display("Input: %b   Output: %b",in,out);
#10
in = 8'b0000_0000;
#1 $display("Input: %b   Output: %b",in,out);
#10
in = 8'b1000_0000;
#1 $display("Input: %b   Output: %b",in,out);
#10
$finish;
end
endmodule
