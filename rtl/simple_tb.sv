module tb;

    logic clk, rst;

    rv32_sv dut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        $display("TIME=%0t  PC=%08h", $time, dut.pc_bus.pc);
    end

    // Waveform recording
    initial begin
    $shm_open("waves.shm");
    $shm_probe("AS");
    $shm_probe(dut.pc_bus.pc);
    $shm_probe(dut.pc_bus.pc_next);
    $shm_probe(dut.pc_bus.pc_src);
end

    initial begin
        clk = 1'b0;
        rst = 1'b1;

        #10;
        rst = 1'b0;

        #200;
        $finish;
    end

endmodule
