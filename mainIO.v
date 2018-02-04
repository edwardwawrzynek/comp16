module mainIO(clk, adrs, in, out, we, p0, p1SerialIn, p1We, p2SerialInWaiting, p3SerialOut, p3We, p4SerialBusy, p5VGATESTING);
input clk;
input [7:0] adrs;
reg [7:0] adrsReg;
input [15:0] in;
input we;
output [15:0] out;
reg [15:0] io[15:0];
reg [15:0] wePorts;

output [15:0] p0;
assign p0 = io[0];

output [7:0] p3SerialOut; 
assign p3SerialOut = io[3][7:0];
output p5VGATESTING;
assign p5VGATESTING = io[5][0];

input [7:0] p1SerialIn;
input [7:0] p2SerialInWaiting;
input p4SerialBusy;

output p1We;
assign p1We = wePorts[1];
output p3We;
assign p3We = wePorts[3];

assign out = io[adrsReg];

always @ (posedge clk)
	begin
		io[1][7:0] <= p1SerialIn;
		io[2][7:0] <= p2SerialInWaiting;
		io[4][0] <= p4SerialBusy;
		if(we)
			begin
				io[adrs] <= in;
				wePorts[adrs] <= 1'b1;
			end
		else
			begin
				wePorts <= 16'b0;
			end
		
		adrsReg <= adrs;
	end

endmodule