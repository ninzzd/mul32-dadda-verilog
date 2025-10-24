`timescale 1 ns / 100 ps
module mul32phw_tb;
    reg clk;
    reg rst;

    mul32phw dut(
        .clk(clk),
        .rst(rst)
    );

    initial
    begin
        $dumpfile("mul32phw_tb.vcd");
        $dumpvars(0,mul32phw_tb);
        clk <= 1'b0;
        rst <= 1'b0;
        #250
        $finish;
    end
    always #5 clk <= ~clk;
endmodule