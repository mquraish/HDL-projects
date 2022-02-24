module binary_to_grey #(parameter N = 4)(
    clk, rst, out
);

input clk;
input rst;
output [N-1:0] out;

reg [N-1:0] q;

always@(posedge clk or posedge rst) begin
    if(rst) begin
        q<=0;
        out<=0;
    end
    else begin
       q <= q+1;
       out <= {q[N-1], q[N-2:0] ^ q[N-1:1]};
    end
end
endmodule