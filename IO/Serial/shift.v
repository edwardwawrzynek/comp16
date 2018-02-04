module shift(clk, ser, par);
input clk, ser;
output [15:0] par;
reg [15:0] tmp;

assign par = tmp;

always @ (posedge clk)
begin
	tmp = {tmp[14:0], ser};
end
endmodule