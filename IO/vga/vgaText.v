module vgaTextGen(disp_en, x, y, pixel_clk, out, ram_clk, addr, data_in, data_out, we, text_mem_clk, col_out);

input text_mem_clk;
input pixel_clk;
input [31:0] x;
input [31:0] y;
input disp_en;

//For writing to text ram
input ram_clk;
input [9:0] addr;
output [15:0] data_out;
input [15:0] data_in;
reg [9:0] text_addr;
input we;

output reg out;
/*Memory Initilization for charsets and text ram*/
parameter CHARSET_MEM_FILE = "charset.txt";

reg [63:0] charset_ram [0:255];
reg [15:0] text_mem [0:999];

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

//Non-color
assign text_index = xChar + (10'd40 * yChar);

reg [10:0] real_text_index;
wire [15:0] current_char;
assign current_char = text_mem[real_text_index];
assign charset_index = current_char[7:0];

assign charset = charset_ram[charset_index];

wire [5:0] charset_pixel;
assign charset_pixel = (charPixelY << 6'd3) + charPixelX;

wire pixel;
assign pixel = disp_en ? charset[6'd63 - charset_pixel] : 1'b0;

//Col
wire [7:0] col;
output reg [7:0] col_out;
wire [7:0] mem_col;
assign mem_col = current_char[15:8];
assign col = pixel ? (mem_col == 8'b0 ? 8'd255 : mem_col) : 8'b0;

//CLocked Memory and signal stabalization
always @ (posedge pixel_clk)
begin
	col_out <= col;
	out <= pixel;
end

always @ (posedge text_mem_clk)
begin
	real_text_index <= text_index;
end

assign data_out = text_mem[text_addr];
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
end

endmodule