interface a_if #(parameter int WIDTH = 32);
logic[WIDTH-1:0] a;
logic[WIDTH-1:0]b;
logic[WIDTH-1:0]result;
modport alum(
input a,b,
output result);
modport a_m(
output b,
input result);
//i will take aluop from the modport of instruction decoder??
endinterface

module alu(
a_if.alum al,
dec_if.ctrl dc);
always_comb begin
case(dc.aluop)
'0000 : al.result = al.a + al.b;
'0001 : al.result = al.a - al.b;
'0010 : al.result = al.a & al.b;
'0011 : al.result = al.a | al.b;
'0100 : al.result = al.a ^ al.b;
'0101 : al.result = al.a << al.b;
'0110 : al.result = al.a >> al.b;
'0111 : al.result = al.a >>> al.b;
default : al.result = '0;
end
endmodule

module mux_alu(
a_if.a_m b,
immgen_if.a_im i,
regmem.regi r,
dec_if.ctrl c);
always_comb begin
case(c.alusrc)
'0 : b.b = r.read_data2;
'1 : b.b = i.imm;
default : b.b = r.read_data2;
end
endmodule
