interface wb_if# (parameter int WIDTH = 32);
logic[WIDTH-1:0] wb_result;
modport wb (
output wb_result);
endinterface

module wb_mux(
    wb_if.wb wb,
    a_if.a_m am,
    dif.did dm,
    pc_if.pc_mux pc,
    dec_if.ctrl ctrl
);

    always_comb begin

        case(ctrl.wb_sel)

            2'b00:
                wb.wb_result = am.result;

            2'b01:
                wb.wb_result = dm.read_data;

            2'b10:
                wb.wb_result = pc.pc + 32'd4;

            default:
                wb.wb_result = '0;

        endcase

    end

endmodule
