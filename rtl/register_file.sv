interface regmem #(parameter int WIDTH = 32);

    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    logic [WIDTH-1:0] read_data1;
    logic [WIDTH-1:0] read_data2;
    logic [WIDTH-1:0] write_data;

    modport regi(
        input rs1, rs2, rd, write_data,
        output read_data1, read_data2
    );

    modport dec(
        output rs1, rs2, rd
    );

    modport datapath(
        input read_data1,
        input read_data2
    );

endinterface

module regfile(
input clk,
regmem.regi regs
 dec_if.ctrl ctrl);
logic[31:0]register[0:31];

always_comb begin
    if (regs.rs1 == 0)
        regs.read_data1 = '0;
    else
        regs.read_data1 = register[regs.rs1];

    if (regs.rs2 == 0)
        regs.read_data2 = '0;
    else
        regs.read_data2 = register[regs.rs2];
end

always_ff @(posedge clk)begin
if (ctrl.regwrite && regs.rd != 0)
    register[regs.rd] <= regs.write_data;

end
endmodule
