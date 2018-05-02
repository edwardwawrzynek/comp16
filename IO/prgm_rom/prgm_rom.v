module prmg_rom(clk, addrs, val);
input clk;
input [15:0] addrs;
output reg [15:0] val;
(* ram_init_file = "IO/prgm_rom/prgm_rom.mif" *) reg [15:0] mem[0:65535];

always @ (posedge clk)
	begin
	val <= mem[addrs];
end
endmodule
