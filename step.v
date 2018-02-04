module step(clk, step, rst);
//Clock - Delayed
input clk;
//Reset step to 0
input rst;
//2 bit step
output reg [1:0] step;

always @ (posedge clk)
begin
	if(rst)
		begin
			step <= 0;
		end
	else
		begin
			step <= #1 step + 1;
		end
end

endmodule