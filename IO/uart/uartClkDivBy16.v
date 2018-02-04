module uartClkDivBy16(clk_in, clk_out);
input clk_in;
output clk_out;

reg [7:0] counter;

assign clk_out = (counter<8)?0:1;

always @ (posedge clk_in)
	begin
		counter <= counter + 1;
		if(counter>=15)
			begin
				counter <= 0;
			end
	end
endmodule