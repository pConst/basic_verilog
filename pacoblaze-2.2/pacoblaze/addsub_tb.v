
`define WIDTH 16

module addsub_tb;

parameter tck = 10;

reg op, oc; // 0: add, 1: sub
wire [`WIDTH-1:0] y;
reg [`WIDTH-1:0] a, b;
reg c_in;
wire c_out, h_out;

reg clk;

addsub dut(
	op, oc, y, a, b, c_in,
	c_out, h_out
);

initial begin
	$dumpvars(-1, dut);
	$dumpfile("addsub_tb.vcd");
end

always #(tck/2) clk = ~clk;

integer i, j;
initial begin
	clk = 0;
	op = 0; oc = 0;
	c_in = 0;
	for (i=0; i<(1<<`WIDTH); i=i+50)
		for (j=0; j<(1<<`WIDTH); j=j+50) begin
			a = i;
			b = j;
			@(negedge clk);
			$display("%h %h : %h %h", c_out, y, a, b);
		end
	$finish;

end

endmodule
