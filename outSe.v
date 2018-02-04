module outSe(i, s, o0, o1);
input s;
input [15:0] i;
output [15:0] o0;
output [15:0] o1;
assign o0 = s ? 16'b0 : i;
assign o1 = s ? i : 16'b0;
endmodule