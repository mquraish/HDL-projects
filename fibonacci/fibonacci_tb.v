module fibonacci_tb;
  reg clk = 1'b0;
  reg rst;
  reg [7:0] nth_number;
  wire fibonacci_number;

  
  always #5 clk = ~clk;
  
  fibonacci DUT(
    .clk(clk),
    .rst(rst),
    .nth_number(nth_number),
    .fibonacci_number(fibonacci_number)
  );
  
  initial begin
    #100
    rst = 1'b1;
    nth_number = 8'd4;
    #100
    rst = 1'b0;
    #(nth_number*10)
  	$finish;
  end
endmodule