module txt_col(for_en, col_bak, col_for, r2, r1, r0, g2, g1, g0, b1, b0);
parameter BAK_COL_FILE = "";
parameter FOR_COL_FILE = "";

input for_en;
input [3:0] col_bak;
input [3:0] col_for;

wire [7:0] bak_col;
wire [7:0] for_col;
wire [7:0] col;
assign col = for_en ? for_col : bak_col;

reg [7:0] bak_ram[15:0];
reg [7:0] for_ram[15:0];
/*
assign bak_col = bak_ram[col_bak];
assign for_col = for_ram[col_for];
*/

assign bak_col = {col_bak[3], col_bak[2], col_bak[2], col_bak[3], col_bak[1], col_bak[1], col_bak[3], col_bak[0]};
assign for_col = {col_for[3], col_for[2], col_for[2], col_for[3], col_for[1], col_for[1], col_for[3], col_for[0]};
output r2, r1, r0, g2, g1, g0, b1, b0;
assign r2 = col[7];
assign r1 = col[6];
assign r0 = col[5];
assign g2 = col[4];
assign g1 = col[3];
assign g0 = col[2];
assign b1 = col[1];
assign b0 = col[0];

initial begin
  if (BAK_COL_FILE != "") begin
    $readmemh(BAK_COL_FILE, bak_ram);
  end
  if (FOR_COL_FILE != "") begin
    $readmemh(FOR_COL_FILE, for_ram);
  end
end

endmodule