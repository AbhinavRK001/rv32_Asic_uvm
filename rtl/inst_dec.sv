interface dec_if #(parameter int WIDTH = 32);

    logic       regwrite;
    logic       memread;
    logic       memwrite;

    logic       alusrc_a;
    logic       alusrc_b;

    logic       branch;
    logic       branch_type;

    logic       jump;
    logic       jalr;

    logic [3:0] aluop;
    logic [3:0] imm_type;

    logic [1:0] wb_sel;

    modport dec(
        output regwrite,
        output memread,
        output memwrite,
        output alusrc_a,
        output alusrc_b,
        output branch,
        output branch_type,
        output jump,
        output jalr,
        output aluop,
        output imm_type,
        output wb_sel
    );

    modport ctrl(
        input regwrite,
        input memread,
        input memwrite,
        input alusrc_a,
        input alusrc_b,
        input branch,
        input branch_type,
        input jump,
        input jalr,
        input aluop,
        input imm_type,
        input wb_sel
    );

endinterface
module decoder(
    immgen_if.in_dec inp,
    dec_if.dec dc,
    regmem.dec rdc
);

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    always_comb begin

        rdc.rs1 = inp.instr[19:15];
        rdc.rs2 = inp.instr[24:20];
        rdc.rd  = inp.instr[11:7];

        opcode = inp.instr[6:0];
        funct3 = inp.instr[14:12];
        funct7 = inp.instr[31:25];

        // Defaults
        dc.regwrite    = 1'b0;
        dc.memread     = 1'b0;
        dc.memwrite    = 1'b0;

        dc.alusrc_a    = 1'b0;
        dc.alusrc_b    = 1'b0;

        dc.branch      = 1'b0;
        dc.branch_type = 1'b0;

        dc.jump        = 1'b0;
        dc.jalr        = 1'b0;

        dc.aluop       = 4'b0000;
        dc.imm_type    = 4'b0000;

        dc.wb_sel      = 2'b00;


        case(opcode)

            // =================================================
            // I-TYPE ALU
            // =================================================
            7'b0010011: begin

                dc.regwrite = 1'b1;
                dc.alusrc_b = 1'b1;
                dc.imm_type = 4'b0000;
                dc.wb_sel   = 2'b00;

                case(funct3)

                    3'b000: dc.aluop = 4'b0000; // ADDI
                    3'b111: dc.aluop = 4'b0010; // ANDI
                    3'b110: dc.aluop = 4'b0011; // ORI
                    3'b100: dc.aluop = 4'b0100; // XORI

                    default: begin
                        dc.regwrite = 1'b0;
                    end

                endcase

            end


            // =================================================
            // R-TYPE
            // =================================================
            7'b0110011: begin

                dc.regwrite = 1'b1;
                dc.alusrc_a = 1'b0;
                dc.alusrc_b = 1'b0;
                dc.wb_sel   = 2'b00;

                case(funct3)

                    3'b000: begin
                        if(funct7 == 7'b0000000)
                            dc.aluop = 4'b0000; // ADD
                        else if(funct7 == 7'b0100000)
                            dc.aluop = 4'b0001; // SUB
                        else
                            dc.regwrite = 1'b0;
                    end

                    3'b111: dc.aluop = 4'b0010; // AND
                    3'b110: dc.aluop = 4'b0011; // OR
                    3'b100: dc.aluop = 4'b0100; // XOR
                    3'b001: dc.aluop = 4'b0101; // SLL

                    3'b101: begin
                        if(funct7 == 7'b0000000)
                            dc.aluop = 4'b0110; // SRL
                        else if(funct7 == 7'b0100000)
                            dc.aluop = 4'b0111; // SRA
                        else
                            dc.regwrite = 1'b0;
                    end

                    default:
                        dc.regwrite = 1'b0;

                endcase

            end


            // =================================================
            // LW
            // =================================================
            7'b0000011: begin

                if(funct3 == 3'b010) begin

                    dc.regwrite = 1'b1;
                    dc.memread  = 1'b1;

                    dc.alusrc_b = 1'b1;
                    dc.aluop    = 4'b0000;

                    dc.imm_type = 4'b0000;
                    dc.wb_sel   = 2'b01;

                end

            end


            // =================================================
            // SW
            // =================================================
            7'b0100011: begin

                if(funct3 == 3'b010) begin

                    dc.memwrite = 1'b1;

                    dc.alusrc_b = 1'b1;
                    dc.aluop    = 4'b0000;

                    dc.imm_type = 4'b0001;

                end

            end


            // =================================================
            // BEQ / BNE
            // =================================================
            7'b1100011: begin

                dc.branch   = 1'b1;
                dc.aluop    = 4'b0001;
                dc.imm_type = 4'b0010;

                case(funct3)

                    3'b000: begin
                        dc.branch_type = 1'b0; // BEQ
                    end

                    3'b001: begin
                        dc.branch_type = 1'b1; // BNE
                    end

                    default: begin
                        dc.branch = 1'b0;
                    end

                endcase

            end


            // =================================================
            // LUI
            // =================================================
            7'b0110111: begin

                dc.regwrite = 1'b1;

                dc.alusrc_a = 1'b0;
                dc.alusrc_b = 1'b1;

                dc.aluop    = 4'b1000; // PASS B
                dc.imm_type = 4'b0011; // U-type

                dc.wb_sel   = 2'b00;

            end


            // =================================================
            // AUIPC
            // =================================================
            7'b0010111: begin

                dc.regwrite = 1'b1;

                dc.alusrc_a = 1'b1; // PC
                dc.alusrc_b = 1'b1; // immediate

                dc.aluop    = 4'b0000; // ADD
                dc.imm_type = 4'b0011; // U-type

                dc.wb_sel   = 2'b00;

            end


            // =================================================
            // JAL
            // =================================================
            7'b1101111: begin

                dc.regwrite = 1'b1;
                dc.jump     = 1'b1;

                dc.imm_type = 4'b0100; // J-type
                dc.wb_sel   = 2'b10;   // PC + 4

            end


            // =================================================
            // JALR
            // =================================================
            7'b1100111: begin

                if(funct3 == 3'b000) begin

                    dc.regwrite = 1'b1;
                    dc.jump     = 1'b1;
                    dc.jalr     = 1'b1;

                    dc.alusrc_a = 1'b0; // rs1
                    dc.alusrc_b = 1'b1; // immediate

                    dc.aluop    = 4'b0000; // ADD
                    dc.imm_type = 4'b0000; // I-type

                    dc.wb_sel   = 2'b10;   // PC + 4

                end

            end

            default: begin
            end

        endcase

    end

endmodule
