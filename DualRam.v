module DualRAM(clk, aData, bData, aAdrs, bAdrs, aWE, bWE, aVal, bVal);
input [15:0] aData;
input [15:0] bData;

input [15:0] aAdrs;
input [15:0] bAdrs;

input aWE;
input bWE;

input clk;

output reg [15:0] aVal;
output reg [15:0] bVal;

//Memory
(* ram_init_file = "RAMData.mif", ramstyle = "no_rw_check" *) reg [15:0] mem[65535:0];

/*initial begin
		$readmemh("RAMData.txt", mem);
end*/
	
// Port A
always @ (posedge clk)
begin
	if (aWE) 
	begin
		mem[aAdrs] <= aData;
		aVal <= aData;
	end
	else 
	begin
		aVal <= mem[aAdrs];
	end
end

// Port B
always @ (posedge clk)
begin
	if (bWE)
	begin
		mem[bAdrs] <= bData;
		bVal <= bData;
	end
	else
	begin
		bVal <= mem[bAdrs];
	end
end

endmodule
