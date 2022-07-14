`timescale 1ns / 1ps

module priority_encoder_tb;

reg [7:0] in;
wire [2:0] out;

priority_encoder DUT(
    .in(in),
    .out(out)
);

integer i;

initial begin
#100
in = 8'b00000000;
#1 $display("Input: %b   Output: %b",in,out);
for(i=1; i<130; i=i<<1) begin
#10 in = i;
#1 $display("Input: %b   Output: %b",in,out);
#10 in = i+1;
#1 $display("Input: %b   Output: %b",in,out);
end
#10
in = 8'b11111111;
#1 $display("Input: %b   Output: %b",in,out);
$finish;
end
endmodule
