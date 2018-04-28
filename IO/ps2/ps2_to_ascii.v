module ps2_to_ascii(clk, new_in, in, out, new_char, jmpff00);
input clk;
input new_in;
input [7:0] in;

output [8:0] out;
output new_char;

//Used to jump to bootloader if pause is pressed
output reg jmpff00;

assign out = {released, cur};

reg real_new;
reg [7:0] cur;
reg released;
reg released_sent;

reg prev_new_in;

assign new_char = real_new;

always @ (posedge clk)
begin
	prev_new_in <= new_in;
	if(!new_in || prev_new_in)
		begin
			real_new <= 0;
			if(released_sent)
				begin
					released_sent <= 0;
					released <= 0;
				end
		end
	else if(in != 8'he0 && in != 8'hf0)
		begin
			if(in == 8'he1)
				begin
					jmpff00 <= 1;
				end
			else
				begin
					jmpff00 <= 0;
				end
			real_new <= 1;
			released_sent <= 1;
			//PS2 to Ascii Keycodes - US keyboard
			case(in)
				8'h76: cur <= 8'd27; //Esc
				8'h05: cur <= 8'd11; //F1
				8'h06: cur <= 8'd12; //F2
				8'h04: cur <= 8'd13; //F3
				8'h0c: cur <= 8'd14; //F4
				8'h03: cur <= 8'd15; //F5
				8'h0b: cur <= 8'd19; //F6
				8'h83: cur <= 8'd20; //F7
				8'h0a: cur <= 8'd21; //F8
				8'h01: cur <= 8'd22; //F9
				8'h09: cur <= 8'd23; //F10
				8'h78: cur <= 8'd24; //F11
				8'h07: cur <= 8'd25; //F12
				8'h0e: cur <= "`";
				8'h16: cur <= "1";
				8'h1e: cur <= "2";
				8'h26: cur <= "3";
				8'h25: cur <= "4";
				8'h2e: cur <= "5";
				8'h36: cur <= "6";
				8'h3d: cur <= "7";
				8'h3e: cur <= "8";
				8'h46: cur <= "9";
				8'h45: cur <= "0";
				8'h4e: cur <= "-";
				8'h55: cur <= "=";
				8'h66: cur <= 8'd8; //Backspace
				8'h0d: cur <= 8'd9; //Tab
				8'h54: cur <= "[";
				8'h5b: cur <= "]";
				8'h5d: cur <= "|";
				8'h58: cur <= 8'd20; //Caps Lock
				8'h29: cur <= " ";
				8'h4a: cur <= "/";
				8'h4c: cur <= ";";
            			8'h52: cur <= "'";
            			8'h41: cur <= ",";
            			8'h49: cur <= ".";
				8'h71: cur <= 8'd46; //Del
				8'h7d: cur <= 8'd33; //Page Up
				8'h7a: cur <= 8'd34; //Page Down
				8'h70: cur <= 8'd45; //Insert
				8'h6c: cur <= 8'd36; //Home
				8'h69: cur <= 8'd35; //End
				8'h6b: cur <= 8'd28; //Left Arrow
				8'h75: cur <= 8'd29; //Up Arrow
				8'h74: cur <= 8'd30; //Right Arrow
				8'h72: cur <= 8'd31; //Down Arrow
				8'h5a: cur <= 8'd10; //Enter
				8'h12: cur <= 8'd16; //Left Shift
				8'h59: cur <= 8'd16; //Right Shift
				8'h14: cur <= 8'd17; //Ctrl
				8'h11: cur <= 8'd18; //Alt
				8'h15: cur <= "q";
				8'h1d: cur <= "w";
				8'h24: cur <= "e";
				8'h2d: cur <= "r";
				8'h2c: cur <= "t";
				8'h35: cur <= "y";
				8'h3c: cur <= "u";
				8'h43: cur <= "i";
				8'h44: cur <= "o";
				8'h4d: cur <= "p";
				8'h1c: cur <= "a";
				8'h1b: cur <= "s";
				8'h23: cur <= "d";
				8'h2b: cur <= "f";
				8'h34: cur <= "g";
				8'h33: cur <= "h";
				8'h3b: cur <= "j";
				8'h42: cur <= "k";
				8'h4b: cur <= "l";
				8'h1a: cur <= "z";
				8'h22: cur <= "x";
				8'h21: cur <= "c";
				8'h2a: cur <= "v";
				8'h32: cur <= "b";
				8'h31: cur <= "n";
				8'h3a: cur <= "m";
				default: cur <= 0;
			endcase
		end
	else if(in == 8'hf0)
		begin
			released <= 1;
			real_new <= 0;
		end
	else
		begin
			real_new <= 0;
		end
end

endmodule
