//From https://github.com/jamieiles/uart, Liscensed under GPLv2
module uart(input wire [7:0] din,
	    input wire wr_en,
	    input wire clk,
	    output wire tx,
	    output wire tx_busy,
	    input wire rx,
	    output wire rdy,
	    input wire rdy_clr,
	    output wire [7:0] dout);

wire rxclk_en;
wire txclk_en;

parameter CLK_SPEED = 50000000;

baud_rate_gen #(.CLOCK_SPEED(CLK_SPEED)) uart_baud(.clk_50m(clk),
			.rxclk_en(rxclk_en),
			.txclk_en(txclk_en));
transmitter uart_tx(.din(din),
		    .wr_en(wr_en),
		    .clk_50m(clk),
		    .clken(txclk_en),
		    .tx(tx),
		    .tx_busy(tx_busy));
receiver uart_rx(.rx(rx),
		 .rdy(rdy),
		 .rdy_clr(rdy_clr),
		 .clk_50m(clk),
		 .clken(rxclk_en),
		 .data(dout));

endmodule
