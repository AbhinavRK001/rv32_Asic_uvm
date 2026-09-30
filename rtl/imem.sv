interface imem_if #(parameter int WIDTH = 32);
 logic[WIDTH-1:0] pc;
logic [WIDTH-1:0]imem;
logic [WIDTH-1:0] mem [0:255];
 
modport im_if(
input pc,
output imem,
);

endinterface

module ins_mem(
imem_if.im_if imm);
always_comb begin
imm.imem = imm.mem[imm.pc[31:2]];
end 

initial begin
$readmemh("filename", imm.mem);
end
endmodule
