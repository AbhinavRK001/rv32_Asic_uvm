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
immgen_if.inmem iif,
dec_if.ctrl ctrl);

always_comb begin
               iif.imm = '0;
 case(ctrl.imm_type)

            // I-type
            4'b0000: begin
                iif.imm[11:0]  = iif.instr[31:20];
                iif.imm[31:12] = {20{iif.instr[31]}};
            end

            // S-type
            4'b0001: begin
                iif.imm[11:5]  = iif.instr[31:25];
                iif.imm[4:0]   = iif.instr[11:7];
                iif.imm[31:12] = {20{iif.instr[31]}};
            end

            // B-type
            4'b0010: begin
                iif.imm[12]    = iif.instr[31];
                iif.imm[11]    = iif.instr[7];
                iif.imm[10:5]  = iif.instr[30:25];
                iif.imm[4:1]   = iif.instr[11:8];
                iif.imm[0]     = 1'b0;
                iif.imm[31:13] = {19{iif.instr[31]}};
            end

            // U-type
            4'b0011: begin
                iif.imm[31:12] = iif.instr[31:12];
                iif.imm[11:0]  = '0;
            end

            // J-type
            4'b0100: begin
                iif.imm[20]    = iif.instr[31];
                iif.imm[10:1]  = iif.instr[30:21];
                iif.imm[11]    = iif.instr[20];
                iif.imm[19:12] = iif.instr[19:12];
                iif.imm[0]     = 1'b0;
                iif.imm[31:21] = {11{iif.instr[31]}};
            end
        endcase

            
end
endmodule

