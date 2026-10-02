interface pc_if #(parameter int WIDTH = 32);

    logic [WIDTH-1:0] pc;
    logic [WIDTH-1:0] pc_next;

    logic             pc_src;

    logic [WIDTH-1:0] branch_target;

    modport pc_mp(
        input pc_next,
        output pc
    );

    modport pc_mux(
        input pc,
        input branch_target,
        input pc_src,
        output pc_next
    );

    modport bran(
        input pc,
        output branch_target,
        output pc_src
    );

    modport alu(
        input pc
    );

endinterface


	module pc (
	    input  logic             clk,
	    input  logic             rst,
	    pc_if.pc_mp pcbus
	);

	    always_ff @(posedge clk, posedge rst) begin
		if (rst) begin
		    pcbus.pc <= '0;
		end
		else begin
		    pcbus.pc <= pcbus.pc_next;
		end
	    end
	endmodule


	module sel(
    pc_if.pc_mux pcbus
);

    always_comb begin

        case(pcbus.pc_src)

            1'b0:
                pcbus.pc_next = pcbus.pc + 32'd4;

            1'b1:
                pcbus.pc_next = pcbus.branch_target;

            default:
                pcbus.pc_next = pcbus.pc + 32'd4;

        endcase

    end

endmodule
	
