interface wb_if# (parameter int WIDTH = 32);
logic[WIDTH-1:0] wb_result;
modport wb (
output wb_result);


module wb_mux(
wb_if.wb wb,
a_if.a_m am,
dif.did dm,
dec_if.ctrl ctrl);

always_comb begin
case(ctrl.memread)
'0 : wb.wb_result = am.result;
'1 : wb.wb_result = dm.read_data;
default : wb.wb_result = '0;
end
