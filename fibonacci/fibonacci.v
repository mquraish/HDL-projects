module fibonacci(
	input clk,
	input rst,
	input [7:0] nth_number,
	output [19:0] fibonacci_number
);

reg [19:0] previous_value, current_value;
reg [7:0] internal_counter;
reg number_ready;

always@(posedge clk or posedge rst) begin
	if(rst) begin
		previous_value <= 'd0;
		current_value <= 'd1;
		internal_counter <= 'd1;
		number_ready <= 'd0;
	end
	else begin
		internal_counter <= internal_counter + 1;
		current_value <= current_value + previous_value;
		previous_value <= current_value;
      if(internal_counter == (nth_number -2)) begin
			number_ready <= 1;
end
		else begin
			number_ready <= 0;
		end
	end
end

assign fibonacci_number = current_value;

always@(number_ready) begin
	if(number_ready) begin
      $display("N = %d, Nth Fibonacci number: %d", nth_number, fibonacci_number);
end
end
endmodule

