module io_port(
input io_clk,
input io_we,
input [7:0] io_addr,
input [15:0] io_data,
output reg [15:0] out
);

parameter io_port = 0;

always @ (posedge io_clk)
begin
	if (io_we && io_addr == io_port)
	begin
		out <= io_data;
	end
end

endmodule
