module intProc(rts, ack, out);
input rts, ack;
output reg out;
always @ (posedge rts or posedge ack)
	begin
		if (ack)
			begin
				out <= 1'b0;
			end
		else if (rts)
			begin
				out <= 1'b1;
			end
	end
endmodule