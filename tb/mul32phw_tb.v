`timescale 1 ns / 100 ps
module mul32phw_tb;
    reg clk;
    reg rst;
    wire [31:0] err_count;
    mul32phw uut(
        .clk(clk),
        .rst(rst),
        .err_count(err_count)
    );
    always #1.0 clk <= ~clk;
    initial 
    begin
        $dumpfile("mul32phw_tb.vcd");
        $dumpvars(0,mul32phw_tb);
        clk <= 1'b0;
        rst <= 1'b1;
        #2.0
        rst <= 1'b0;
        #100.0;
        $finish;
    end
endmodule