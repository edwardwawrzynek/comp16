module debugOut(highSe, inSel, i0, i1, i2, i3, i4, i5, i6, i7, out);
input highSe;
input [2:0] inSel;
input [15:0] i0;
input [15:0] i1;
input [15:0] i2;
input [15:0] i3;
input [15:0] i4;
input [15:0] i5;
input [15:0] i6;
input [15:0] i7;

output [7:0] out;

wire [15:0] data;

assign data = inSel[2] ? (inSel[1] ? (inSel[0] ? (i7) : (i6)) : (inSel[0] ? (i5) : (i4))) : (inSel[1] ? (inSel[0] ? (i3) : (i2)) : (inSel[0] ? (i1) : (i0)));
assign out = highSe ? data[15:8] : data[7:0];
endmodule