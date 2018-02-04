module uartRecFIFO(clk, rdy, din, data, next, inWaiting);
input clk;
input rdy;
input [7:0] din;
output [7:0] data;
input next;
output [7:0] inWaiting;

reg [7:0] mem [255:0];
reg [7:0] mem_write_adrs;
reg [7:0] mem_read_adrs;
assign inWaiting = mem_write_adrs - mem_read_adrs;
assign data = mem[mem_read_adrs];

reg [1:0] state = 2'b00;


always @ (posedge clk)
	begin
	if(next)
		begin
			mem_read_adrs <= mem_read_adrs + 1;
		end
	case (state)
	2'b00:
		begin
			if(rdy)
				begin
					state <= 2'b01;
				end
		end
	2'b01:
		begin
				mem[mem_write_adrs] <= din;
				mem_write_adrs <= mem_write_adrs + 1;
				state <= 2'b00;
		end
	endcase
	end
endmodule

