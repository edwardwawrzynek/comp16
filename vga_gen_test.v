module vga_gen_test(x, y, disp_en, r, g, b);
input [31:0] x;
input [31:0] y;
input disp_en;
output r;
output g;
output b;

wire [2:0] col = x[6:4];

assign r = disp_en ? col[0] : 1'b0;
assign g = disp_en ? col[1] : 1'b0;
assign b = disp_en ? col[2] : 1'b0;


endmodule