`include "./pc.sv"
`include "./alu.sv"
`include "./imem.sv"
`include "./immgen.sv"
`include "./inst_dec.sv"
`include "./register_file.sv"
`include "./data_mem.sv"
`include "./wb_mux.sv"
`include "./branch.sv"


module rv32_sv (
    input logic clk,
    input logic rst
);

    // ============================================================
    // INTERFACES
    // ============================================================

    a_if      alu_bus();
    branif    bran_bus();
    dif       dif_bus();
    imem_if   imem_bus();
    immgen_if immgen_bus();
    dec_if    dec_bus();
    pc_if     pc_bus();
    regmem    reg_bus();
    wb_if     wb_bus();


    // ============================================================
    // PC
    // ============================================================

    pc pc_inst (
        .clk  (clk),
        .rst  (rst),
        .pcbus(pc_bus)
    );

    sel sel_inst (
        .pcbus(pc_bus)
    );


    // ============================================================
    // INSTRUCTION MEMORY
    // ============================================================

    ins_mem ins_mem_inst (
        .imm(imem_bus)
    );


    // ============================================================
    // INSTRUCTION DECODER
    // ============================================================

    decoder decoder_inst (
        .inp(immgen_bus),
        .dc (dec_bus),
        .rdc(reg_bus)
    );


    // ============================================================
    // IMMEDIATE GENERATOR
    // ============================================================

    imm_gen imm_gen_inst (
        .iif (immgen_bus),
        .ctrl(dec_bus)
    );


    // ============================================================
    // REGISTER FILE
    // ============================================================

   regfile regfile_inst(
    .clk (clk),
    .regs(reg_bus),
    .ctrl(dec_bus)
);

    // ============================================================
    // ALU
    // ============================================================

    alu alu_inst (
        .al(alu_bus),
        .dc(dec_bus)
    );


    // ALU B MUX
    // Selects between rs2 and immediate

    mux_alu malu_inst (
        .b(alu_bus),
        .i(immgen_bus),
        .r(reg_bus),
        .c(dec_bus)
    );


    // ALU A MUX
    // Selects between rs1 and PC

    mux_alu_a malua_inst (
        .am (alu_bus),
        .r  (reg_bus),
        .pc (pc_bus),
        .c  (dec_bus)
    );


    // ============================================================
    // DATA MEMORY
    // ============================================================

    dm dm_inst (
        .clk(clk),
        .dm (dif_bus)
    );


    // ============================================================
    // WRITEBACK
    // ============================================================

    wb_mux wb_mux_inst (
        .wb  (wb_bus),
        .am  (alu_bus),
        .dm  (dif_bus),
        .pc  (pc_bus),
        .ctrl(dec_bus)
    );


    // ============================================================
    // BRANCH COMPARATOR
    // ============================================================

    branch branch_inst (
        .bin (bran_bus),
        .dat (reg_bus),
        .ctrl(dec_bus)
    );


    // ============================================================
    // BRANCH / JUMP TARGET
    // ============================================================

    bt bt_inst (
        .bin (bran_bus),
        .ctrl(dec_bus),
        .bp  (pc_bus),
        .aimm(immgen_bus),
        .dat (reg_bus)
    );


    // ============================================================
    // TOP-LEVEL CONNECTIONS
    // ============================================================

    // PC -> Instruction Memory
    assign imem_bus.pc = pc_bus.pc;

    // Instruction Memory -> Decoder / Immediate Generator
    assign immgen_bus.instr = imem_bus.imem;


    // ALU -> Data Memory address
    assign dif_bus.address = alu_bus.result;

    // Register rs2 -> Data Memory write data
    assign dif_bus.write_data = reg_bus.read_data2;

    // Decoder -> Data Memory control
    assign dif_bus.read_enable  = dec_bus.memread;
    assign dif_bus.write_enable = dec_bus.memwrite;


    // Writeback -> Register File
    assign reg_bus.write_data = wb_bus.wb_result;


endmodule
