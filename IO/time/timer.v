module timer(clk50mhz, ms, s);
parameter ms_cycles = 50000;
parameter s_cycles = 50000000;

input clk50mhz;
output reg [15:0] ms;
output reg [15:0] s;

reg [32:0] ms_count;
reg [32:0] s_count;

always @ (posedge clk50mhz)
begin
	if(ms_count >= ms_cycles)
		begin
			ms <= ms + 1'b1;
			ms_count <= 32'b0;
		end
	else
		begin
			ms_count <= ms_count + 1'b1;
		end
	if(s_count >= s_cycles)
		begin
			s <= s + 1'b1;
			s_count <= 32'b0;
		end
	else
		begin
			s_count <= s_count + 1'b1;
		end
end
endmodule
