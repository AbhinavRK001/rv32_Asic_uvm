module rv32_sv (
input logic clk,
input logic rst);

a_if alu_bus();
branif bran_bus();
dif dif_bus();
imem_if imem_bus();
immgen_if immgen_bus();
dec_if dec_bus();
pc_if pc_bus();
regmem reg_bus();
wb_if wb_bus();


// PC 

pc pc_inst(
 .clk(clk), 
 .rst(rst),
 .pcbus(pc_bus)); 
 
 sel sel_inst(
.pcbus(pc_bus));

//instruction Memory
ins_mem ins_mem_inst(
.imm(imem_bus));

//instruction decoder

decoder decoder_inst(
.inp(immgen_bus),
.dc(dec_bus),
.rdc(reg_bus));

//imm_gen

imm_gen imm_gen_inst(
.iif(immgen_bus),
.ctrl(dec_bus));

//register file

regfile regfile_inst(
.clk(clk),
.regs(reg_bus));

//ALU

endmodule
