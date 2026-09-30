interface immgen_if#(parameter int WIDTH = 32);
logic signed [WIDTH-1:0] instr;
logic signed [WIDTH-1:0] imm;
modport inmem(
input instr,
output imm);
modport a_im( input imm);
modport in_dec(
input instr
);
endinterface

module imm_gen(
immgen_if.inmem iif);

always_comb begin
iif.imm[31:13] = {19{iif.instr[31]}};
iif.imm[12] = iif.instr[31];
 iif.imm[10:5] = iif.instr[30:25];
 iif.imm[4:1] = iif.instr[11:8];
 iif.imm[11] = iif.instr[7];
iif.imm[0] = '0;
end
endmodule

