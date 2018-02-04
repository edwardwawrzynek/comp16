module manual(clk, in, hlt, out, delayed);
input hlt;
//Fpga Clk, fast(in mhz)
input clk;
//Manual clk signal
input in;
//out clk
reg out1;
output out;
assign out =  hlt ? 1'b0 : out1;
//delayed clok
reg delayed1;
output delayed;
assign delayed = hlt ? 1'b0 : delayed1;
//delay in clk cycles
reg [3:0] delay = 4'd7;

always @ (posedge clk)
begin
	if(in)
		begin
		out1 <= 1'b1;
		if(delay != 4'd0)
			begin
				delay <= #1 delay - 1;
			end
		if(delay == 4'd0)
			begin
				delayed1 <= 1'b1;
			end
		end
	if(in == 1'b0)
		begin
			out1 <= 1'b0;
			delayed1 <= 1'b0;
			delay <= 4'd7;
		end
end
endmodule