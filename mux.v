module mux(i0, i1, s, o);
input [15:0] i0;
input [15:0] i1;
input s;
output [15:0] o;
assign o = s ? i1 : i0;
endmodule