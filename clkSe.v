module clkSe(c0, c1, d0, d1, hlt, sel, out, delay);
input c0, c1, d0, d1, hlt, sel;
output out, delay;
assign out = hlt ? 1'b0 : (sel ? c1 : c0);
assign delay = hlt ? 1'b0 : (sel ? d1 : d0);
endmodule