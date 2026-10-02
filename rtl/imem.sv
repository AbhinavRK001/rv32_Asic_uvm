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
    if (dm.read_enable)
        dm.read_data = mem[dm.address[9:2]];
    else
        dm.read_data = '0;
end

always_ff @(posedge clk) begin
    if (dm.write_enable)
        mem[dm.address[9:2]] <= dm.write_data;
end

initial begin
$readmemh("program.mem", imm.mem);
end
endmodule
