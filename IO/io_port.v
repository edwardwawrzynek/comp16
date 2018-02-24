module io_port(
input io_clk,
input io_we,
input [7:0] io_addr,
input [15:0] io_data,
output reg [15:0] out,
input [15:0] data,
output [15:0] io_out,
output reg we
);

parameter io_port = 0;

assign io_out = (io_addr == io_port) ? data : 16'bz;

always @ (posedge io_clk)
begin
	if (io_we && io_addr == io_port)
	begin
		out <= io_data;
		we <= 1;
	end
	else
	begin
		we <= 0;
	end
end

endmodule
