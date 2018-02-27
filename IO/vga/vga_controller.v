module VGA_controller(
input pixel_clk, //pixel clk
output reg h_sync, //Horizontal Sync
output reg v_sync, //Vertical Sync
output reg disp_en, //Display Enable - used to enable video content output
output reg [31:0] x, //X location in pixels
output reg [31:0] y //y location in pixels
);

//Horizontal parameters
parameter h_pls = 32'd96; //Pulse Time
parameter h_fp = 32'd16; //Front Porch
parameter h_bp = 32'd48; //Back Porch
parameter h_pxls = 32'd640; //Number of pixels
parameter h_pol = 1'b0; //Polarity

//Vertical Parameters
parameter v_pls = 32'd2;//Pulse Time
parameter v_fp = 32'd12;//Front Porch
parameter v_bp = 32'd35; //Back Porch
parameter v_pxls = 32'd400;//Number of pixels
parameter v_pol = 1'b1;//Polarity

reg [31:0] h_loc = 32'd0;
reg [31:0] v_loc = 32'd0;

//Periods - total number of pixels clocks in x and y
parameter h_per = h_pls + h_bp + h_pxls + h_fp;
parameter v_per = v_pls + v_bp + v_pxls + v_fp;

always @ (posedge pixel_clk)
begin
	//Location increment logic, and reset if end reached
	if (h_loc < h_per - 1) 
		begin
			h_loc <= h_loc + 1;
		end
	else 
		begin
			h_loc <= 0;
			if (v_loc < v_per -1)
				begin
					v_loc <= v_loc + 1;
				end
			else
				begin
					v_loc <= 0;
				end
		end
	//Set horizontal sync 
	if (h_loc < h_pxls + h_fp || h_loc > h_pxls + h_fp + h_pls)
		begin
			h_sync <= !h_pol;
		end
	else
		begin
			h_sync <= h_pol;
		end
	//Set vertical sync
	if (v_loc < v_pxls + v_fp || v_loc > v_pxls + v_fp + v_pls)
		begin
			v_sync <= !v_pol;
		end
	else
		begin
			v_sync <= v_pol;
		end
	//Set disp_enable
	if (h_loc < h_pxls && v_loc < v_pxls)
		begin
			disp_en <= 1;
		end
	else
		begin
			disp_en <= 0;
		end
	//Set x and y
	if (h_loc < h_pxls)
		begin
			x <= h_loc;
		end
	if (v_loc < v_pxls)
		begin
			y <= v_loc;
		end
end	
endmodule
