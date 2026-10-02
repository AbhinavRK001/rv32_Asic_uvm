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
modport a_a(
    output a
);
endinterface

module alu(
    a_if.alum al,
    dec_if.ctrl dc
);

    always_comb begin

        case(dc.aluop)

            4'b0000: al.result = al.a + al.b;
            4'b0001: al.result = al.a - al.b;
            4'b0010: al.result = al.a & al.b;
            4'b0011: al.result = al.a | al.b;
            4'b0100: al.result = al.a ^ al.b;
            4'b0101: al.result = al.a << al.b[4:0];
            4'b0110: al.result = al.a >> al.b[4:0];
            4'b0111: al.result = $signed(al.a) >>> al.b[4:0];

            // LUI
            4'b1000: al.result = al.b;

            default: al.result = '0;

        endcase

    end

endmodule

module mux_alu(
    a_if.a_m b,
    immgen_if.a_im i,
    regmem.regi r,
    dec_if.ctrl c
);

    always_comb begin

        case(c.alusrc_b)

            1'b0: b.b = r.read_data2;
            1'b1: b.b = i.imm;

            default: b.b = '0;

        endcase

    end

endmodule

module mux_alu_a(
    a_if.a_a am,
    regmem.regi r,
    pc_if.alu pc,
    dec_if.ctrl c
);

    always_comb begin

        case(c.alusrc_a)

            1'b0: am.a = r.read_data1;
            1'b1: am.a = pc.pc;

            default: am.a = '0;

        endcase

    end

endmodule
