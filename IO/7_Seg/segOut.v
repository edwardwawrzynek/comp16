module segOut(clk, data, seg, sel);
input clk;
input [31:0] data;
output reg [7:0] seg;
output reg [3:0] sel;
reg [1:0] dig;

reg [13:0] count;

always @ (posedge clk)
	begin
		count <= count + 1;
		if (!count)
			begin
				dig <= dig + 1;
				case(dig)
					2'b0:
						begin
							sel <= 4'b0001;
							seg <= data[7:0];
						end
					2'b1:
						begin
							sel <= 4'b0010;
							seg <= data[15:8];
						end
					2'b10:
						begin
							sel <= 4'b0100;
							seg <= data[23:16];
						end
					2'b11:
						begin
							sel <= 4'b1000;
							seg <= data[31:24];
						end
				endcase
			end
	end

endmodule