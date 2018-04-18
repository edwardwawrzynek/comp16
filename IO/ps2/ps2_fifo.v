module ps2_fifo(clk, new, in, data, inWaiting, next);
input clk;
input new;
input [8:0] in;

output [8:0] data;
output [7:0] inWaiting;
input next;

reg [8:0] mem [255:0];
reg [7:0] mem_write_adrs;
reg [7:0] mem_read_adrs;
assign inWaiting = mem_write_adrs - mem_read_adrs;
assign data = mem[mem_read_adrs]; 


always @ (posedge clk)
begin
	if(next)
		begin
			mem_read_adrs <= mem_read_adrs + 1;
		end
	if(new)
		begin
			mem[mem_write_adrs] <= in;
			mem_write_adrs <= mem_write_adrs + 1;
		end
end

endmodule

