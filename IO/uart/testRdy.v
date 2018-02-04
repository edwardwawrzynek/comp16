module testRdy(rdy, out);
input rdy;
output reg [7:0] out;

always @ (posedge rdy)
	begin
		out <= out +1;
	end
endmodule
