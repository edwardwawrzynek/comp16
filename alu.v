module alu(clk, a, b, result, op);
input [3:0] op;
input clk;
input [15:0] a;
input [15:0] b;
output reg [15:0] result;
always @ (posedge clk)
	begin
		case(op)
			4'b0000: result <= #1 a + b;
			4'b0001: result <= #1 a - b;
			4'b0010: result <= #1 a * b;
			4'b0011: result <= #1 ~ a;
			4'b0100: result <= #1 a | b;
			4'b0101: result <= #1 a & b;
			4'b0110: result <= #1 ! a;
			4'b0111: result <= #1 a && b;
			4'b1000: result <= #1 a >> b;
			4'b1001: result <= #1 a << b;
			4'b1010: result <= #1 a == b;
			4'b1011: result <= #1 a > b;
			4'b1100: result <= #1 a >= b;
			default: result <= #1 a;
		endcase
	end	
endmodule