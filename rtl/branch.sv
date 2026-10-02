interface branif #(parameter int WIDTH = 32);

    logic branch_condition;
    logic branch_taken;

    modport bin(
        output branch_condition,
        output branch_taken
    );

endinterface
 
 module branch (
 branif.bin bin,
 regmem.datapath dat,
 dec_if.ctrl ctrl);
 
 always_comb begin
 bin.branch_condition = '0;
 case(ctrl.branch_type) 
 '0 : begin 
         if(dat.read_data1 == dat.read_data2) 
         bin.branch_condition = '1;
end
'1 : begin
         if(dat.read_data1 != dat.read_data2) 
         bin.branch_condition = '1;
end
 endcase
 end
 endmodule
 
 
module bt(
    branif.bin bin,
    dec_if.ctrl ctrl,
    pc_if.bran bp,
    immgen_if.a_im aimm,
    regmem.datapath dat
);

    always_comb begin

        // Branch decision
        bin.branch_taken =
            (ctrl.branch && bin.branch_condition) ||
            ctrl.jump;

        // Default target
        bp.branch_target = bp.pc + aimm.imm;

        // JALR target
        if(ctrl.jalr)
            bp.branch_target = dat.read_data1 + aimm.imm;

        // JALR requires bit 0 = 0
        if(ctrl.jalr)
            bp.branch_target[0] = 1'b0;

        // PC selector
        bp.pc_src = bin.branch_taken;

    end

endmodule
 
 
 
