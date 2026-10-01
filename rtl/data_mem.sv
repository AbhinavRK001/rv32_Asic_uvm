interface dif #(parameter int WIDTH = 32);

    logic [WIDTH-1:0] address;
    logic [WIDTH-1:0] write_data;
    logic [WIDTH-1:0] read_data;
    logic read_enable;
    logic write_enable;

    modport did(
        output address,
        output write_data,
        output read_enable,
        output write_enable,
        input read_data
    );

    modport dmem(
        input address,
        input write_data,
        input read_enable,
        input write_enable,
        output read_data
    );

endinterface

module dm(
    input clk,
    dif.dmem dm
);

    logic [31:0] mem [0:255];

    always_comb begin
        if (dm.read_enable)
            dm.read_data = mem[dm.address[31:2]];
        else
            dm.read_data = '0;
    end

    always_ff @(posedge clk) begin
        if (dm.write_enable)
            mem[dm.address[31:2]] <= dm.write_data;
    end

endmodule
