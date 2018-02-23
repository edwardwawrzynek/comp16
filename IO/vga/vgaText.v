module vgaTextGen(disp_en, x, y, pixel_clk, out, ram_clk, addr, data_in, data_out, we, text_mem_clk);

input text_mem_clk;
input pixel_clk;
input [31:0] x;
input [31:0] y;
input disp_en;

output reg out;

//For writing to text ram
input ram_clk;
input [9:0] addr;
output [7:0] data_out;
input [7:0] data_in;
reg [9:0] text_addr;
input we;

/*Memory Initilization for charsets and text ram*/
parameter CHARSET_MEM_FILE = "charset.txt";
parameter TEXT_MEM_FILE = "text.txt";

reg [63:0] charset_ram [0:255];
reg [7:0] text_mem [0:799];

wire [7:0] charset_index;
wire [63:0] charset;

wire [9:0] text_index;

//X and Y pos in the character
wire [3:0] charX;
assign charX = x[3:0];
wire [3:0] charY;
assign charY = y[3:0];

//X and Y pixel positions in the character
wire [2:0] charPixelX;
assign charPixelX = x[3:1];
wire [2:0] charPixelY;
assign charPixelY = y[3:1];

//X and Y in terms of which char is being displayed
wire [5:0] xChar;
assign xChar = x[9:4];
wire [5:0] yChar;
assign yChar = y[9:4];


assign text_index = xChar + (10'd40 * yChar);

reg [10:0] real_text_index;
assign charset_index = text_mem[real_text_index];


assign charset = charset_ram[charset_index];

wire [5:0] charset_pixel;
assign charset_pixel = (charPixelY << 6'd3) + charPixelX;

wire pixel;
assign pixel = disp_en ? charset[6'd63 - charset_pixel] : 8'b0;

always @ (posedge pixel_clk)
begin
	out <= pixel;
end

always @ (posedge text_mem_clk)
begin
	real_text_index <= text_index;
end

assign data = text_mem[text_addr];
always @ (posedge ram_clk)
begin
	if (we)
		begin
			text_mem[text_addr] <= data_in;
		end
		text_addr <= addr;
end

initial begin
  if (CHARSET_MEM_FILE != "") begin
    $readmemh(CHARSET_MEM_FILE, charset_ram);
  end
  if (TEXT_MEM_FILE != "") begin
    $readmemh(TEXT_MEM_FILE, text_mem);
  end
end

endmodule