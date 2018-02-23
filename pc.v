module PC(clk, pc, cond, ce, incr, pcOut, jmpToff00);
input jmpToff00;
input clk;
input [15:0] pc;
input [15:0] cond;
input ce;
input incr;
//Reg to store state if ce and cond is 0
reg [15:0] pcReg;

//Output connection
output [15:0] pcOut;

assign pcOut = jmpToff00 ? 16'hff00 : (ce ? (cond ? pc : pcReg) : pc);

always @ (posedge clk)
begin
	if(incr)
	begin
		pcReg <= pcReg + 1;
	end
	else if(ce)
		begin
			//Jump if condition is not 0-Should be settable in flag reg, implement later
			if(cond)
				begin
					pcReg <= pc;
				end
		end
	else
		begin
			pcReg <= pc;
		end
end
endmodule