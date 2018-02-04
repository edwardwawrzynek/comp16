//FIX-Add reset to all blocks, ram needs to load first instr. Central waits one clok to let ram load, works, but could be bettter
module central(clk, delayed, instrRAM, step, a, b, aluOpReg, result, out, we, pc, microReset, marOut, mdrOut, mdrIn, hlt, cond, ce, PCIncr, pcIn, ioAdrs, ioIn, ioOut, ioWe);
input clk;
input delayed;
output reg hlt;
//To increment PC
output reg PCIncr;
//Real PC-Needed for failed conditional jumps
input [15:0] pcIn;
//First Clock = 0, Next Clocks = 1
reg firstClock = 1'b0;
//Set microcode step to 0-Used for instrs that do not take 4 steps, and to let ram load on first clock cycle
output reg microReset;
/*
IO Ports
*/
output reg [7:0] ioAdrs;
output reg [15:0] ioOut;
output reg ioWe;
input [15:0] ioIn;
/*
Instructions -all 16 bit
All instructions start with 4 bit opcode

Reg based (_ represents 1 bit) 
| _ _ _ _ | _ _ _ _ | _ _ _ _ | _ _ _ _ |
|  Opcode | Src reg | Dst reg | Alu op  |

Reg and Value based(_ represents 1 bit)
| _ _ _ _ | _ _ _ _ | _ _ _ _ _ _ _ _ |
|  Opcode |   reg   |      value      |

Instructions (* means implemented)
[opcode in hex]:Name[args:length in bits]
	Full Name-Description
	
*0:nop[null:12]
	nop-No operation - does nothing
	
*1:mov[src reg:4][dst reg:4][alu op:4]
	Move-moves the value in src reg into dst reg, and sets the ALU's operation to alu op
	
*2:jmp[reg:4][value:8]
	Jump-puts value into least significant part of reg, moves reg to pc, disables conditional jump
	
*3:jpc[reg:4][value:8]
	Jump Conditional-puts value into least signficiant part of reg, moves reg to pc, enables conditional jump

*4:pra[reg:4][value:8]
	Put Register A-Puts value into least significant part of reg([7:0])

*5:prb[reg:4][value:8]
	Put Register B-Puts value into most significant part of reg([15:8])
	
*6:lod[reg:4][adrs:8]
	Load-puts value into lest significant part of mar, moves mdr to reg

*7:str[reg:4][adrs:8]
	Store-puts value into lest significant part of mar,moves reg to mdr
	
*8:psh[i_reg:4][v_reg:4]
	Push-Put v_reg in mem at i_reg adress, decrease i_reg

*9:pop[i_reg:4][v_reg:4]
	Pop-Put memory adress i_reg+1 into v_reg, increase i_reg
	
*A:srt[a_reg:4][adrs:8]
	Subroutine-Put ards in lower half of a_reg, disable conditional jump, set mar equal to stack pointer. Set mdr equal to pc, pc equal to a_reg, and deincrement stack pointer
	
*B:ret[num_args:12]
	Return-put stack pointer -1 in mar, disable conditional jump, then set pc equal to mdr, increment stack pointer num_args+1
	
C:out[reg:4][io_port:8 - Really only 4 bits now to keep compile times low ]
	Output-Set io_port equal to reg

D:in[reg:4][io_port:8]
	Input-set reg equal to io_port

*/

//InstrRAM is a line to instr from RAM, instr is set equal to it when a new instruction is loaded
input [15:0] instrRAM;
//Instr, and instr split into different parts
reg [15:0] instr;

wire [3:0] opcode;
assign opcode = instr[15:12];


//Reg based Instrs
wire [3:0] srcReg;
assign srcReg = instr[11:8];

wire [3:0] dstReg;
assign dstReg = instr[7:4];

wire [3:0] aluOp;
assign aluOp = instr[3:0];
//Reg and value based Instrs
wire [7:0] value;
assign value = instr[7:0];

wire [11:0] value12;
assign value12 = instr[11:0];
//(srcReg used as reg for reg and value based)

/*Steps
4 steps-2 bit step value
Steps [step in binary]:step
00:load new instr, increment pc, set regs to external values
01:Instruction Specific
10:Instruction Specific
11:Instruction Specific
*/

input [1:0] step;

/*Regs [hex num]:[name]:[abbreviation]
0: A reg (A)
1: B reg (B)
2: Result Reg (RES)
3: Program Counter (PC)
4: Memory Adress Reg (MAR)
5: Memory Data Reg (MDR)
6: Conditional Reg (COND)
7: Base Pointer (BP)
8: Stack Pointer (SP)
9: Construction Register (CR)
**More regs through 16th reg, no specific purpose yet**

*/

//16 Regs, each 16 bits
reg [15:0] regFile [15:0];

//Write Enable for each reg(pulled high whenever reg is writen to, used for external compnents(RAM, Outputs, etc...)
output reg [15:0] we;

//Access regs from externals
output [15:0] a;
assign a = regFile[0];

output [15:0] b;
assign b = regFile[1];

output [15:0] out;
assign out = regFile[10];

output [15:0] pc;
assign pc = regFile[3];

output [15:0] marOut;
assign marOut = regFile[4];

output reg ce;
//assign ce = regFile[7][4];

output reg [3:0] aluOpReg;
//assign aluOpReg = regFile[7][3:0];

output [15:0] mdrOut;
assign mdrOut = regFile[5];

output [15:0] cond;
assign cond = regFile[6];

input [15:0] result;
input [15:0] mdrIn;

always @(posedge clk)
begin
	case(step)
	2'b00:
		begin
			//Set regs
			regFile[2] <= result;
			regFile[5] <= mdrIn;
			we <= 16'b0;
			ce <= 1'b0;
			ioWe <= 1'b0;
			if(!firstClock)
				begin
					firstClock <= 1'b1;
					microReset <= 1'b1;
				end
			else
				begin
					instr <= instrRAM;
					microReset <= 1'b0;
					regFile[3] <= pcIn + 1;
					PCIncr <= 1'b1;
				end
			end
	2'b01:
		begin
			PCIncr <= 1'b0;
			case(opcode)
				4'h0:
					begin
						hlt <= 1'b0;
					end
				4'h1:
					begin
						regFile[dstReg] <= regFile[srcReg];
						aluOpReg <= aluOp;
						we[dstReg] <= 1'b1;
						if(dstReg != 4'h3)
						begin
							microReset <= 1'b1;
						end
				end
				4'h2:
					begin
						regFile[srcReg][7:0] <= value;
						we[srcReg] <= 1'b1;
						ce <= 1'b0;
					end
				4'h3:
					begin
						regFile[srcReg][7:0] <= value;
						we[srcReg] <= 1'b1;
						ce <= 1'b1;
					end
				4'h4:
					begin
						regFile[srcReg][7:0] <= value;
						we[srcReg] <= 1'b1;
						microReset <= 1'b1;
					end
				4'h5:
					begin
						regFile[srcReg][15:8] <= value;
						we[srcReg] <= 1'b1;
						microReset <= 1'b1;
					end
				default:
					begin
						we <= 16'b0;
					end
				4'h6:
					begin
						regFile[4][7:0] <= value;
						we[4] <= 1'b1;
					end
				4'h7:
					begin
						regFile[4][7:0] <= value;
						we[4] <= 1'b1;
					end
				4'h8:
					begin
						regFile[4] <= regFile[srcReg];
						we[4] <= 1'b1;
					end
				4'h9:
					begin
						regFile[4] <= regFile[srcReg] + 1'b1;
						we[4] <= 1'b1;
					end
				4'ha:
					begin
						regFile[srcReg][7:0] <= value;
						//Disable Comditional
						ce <= 1'b0;
						regFile[4] <= regFile[8];
						we[4] <= 1'b1;
						we[srcReg] <= 1'b1;
					end
				4'hb:
					begin
						ce <= 1'b0;
						regFile[4] <= regFile[8] + 1'b1;
						we[4] <= 1'b1;
					end
				4'hc:
					begin
						ioAdrs <= value;
					end
				4'hd:
					begin
						ioAdrs <= value;
					end
			endcase
		end
	2'b10:
		begin 
				begin
					case(opcode)
					4'h2:
						begin
							we[srcReg] <= 1'b0;
							we[3] <= 1'b1;
							regFile[3] <= regFile[srcReg];
							microReset <= 1'b1;
						end
					4'h3:
						begin
							we[srcReg] <= 1'b0;
							we[3] <= 1'b1;
							regFile[3] <= regFile[srcReg];
							microReset <= 1'b1;
						end
					4'h6:
						begin
							regFile[srcReg] <= mdrIn;
							we <= 16'b0;
							microReset <= 1'b1;
						end
					4'h7:
						begin
							regFile[5] <= regFile[srcReg];
							we[4] <= 1'b0;
							we[5] <= 1'b1;
							microReset <= 1'b1;
						end
					4'h8:
						begin
							regFile[5] <= regFile[dstReg];
							regFile[srcReg] <= regFile[srcReg] - 1'b1;
							we[4] <= 1'b0;
							we[5] <= 1'b1;
							we[srcReg] <= 1'b1;
							microReset <= 1'b1;
						end
					4'h9:
						begin
							regFile[dstReg] <= mdrIn;
							regFile[srcReg] <= regFile[srcReg] + 1'b1;
							we[4] <= 1'b0;
							we[dstReg] <= 1'b1;
							microReset <= 1'b1;
						end
					4'ha:
						begin
							regFile[5] <= pcIn;
							regFile[3] <= regFile[srcReg];
							regFile[8] <= regFile[8] - 1'b1;
							we[4] <= 1'b0;
							we[5] <= 1'b1;
							we[srcReg] <= 1'b0;
							we[3] <= 1'b1;
							microReset <= 1'b1;
						end
					4'hb:
						begin
							regFile[3] <= mdrIn;
							regFile[8] <= regFile[8] + 1'b1 + value12;
							we[4] <= 1'b0;
							we[3] <= 1'b1;
							microReset <= 1'b1;
						end
					4'hc:
						begin
							ioWe <= 1'b1;
							ioOut <= regFile[srcReg];
							microReset <= 1'b1;
						end
					4'hd:
						begin
							regFile[srcReg] <= ioIn;
							microReset <= 1'b1;
						end
					default:
						begin
						we <= 16'b0;
						end
					endcase
				end
		end
	2'b11:
		begin
			regFile[3] <= pcIn;
			//KEEP THIS LINE, or Quartus sets hlt t0 1'b1 by default and synthesizes everything else away
			hlt <= 1'b0;
			we <= 16'b0;
		end
	endcase
end
endmodule