// Author: Ninaad Desai
// Description: 32-bit pipelined dadda multiplier testbench
`timescale 1ns/1ps
module mul32p_tb();
    reg mode;
    reg clk;
    reg signed [31:0] a;
    reg signed [31:0] b;
    wire eq_u;
    wire eq;
    wire [31:0] a_;
    wire [31:0] b_;
    wire signed [63:0] res_signed;
    wire [63:0] res_unsigned;
    wire signed [63:0] exp_res_signed;
    wire [63:0] exp_res_unsigned;

    always #0.500 clk = ~clk;
    mul32p #(.T(0.050)) uut(
        .clk(clk),
        .a(a),
        .b(b),
        .mode(mode),
        .lo(res_signed[31:0]),
        .hi(res_signed[63:32])
    );
    assign a_ = a;
    assign b_ = b;
    assign exp_res_signed = a*b;
    assign exp_res_unsigned = a_*b_;
    assign res_unsigned = res_signed;
    assign eq = (exp_res_signed == res_signed) ? 1'b1 : 1'b0;
    assign eq_u = (exp_res_unsigned == res_unsigned) ? 1'b1 : 1'b0;
    // task display;
    // endtask
    integer w;
    integer i;
    integer log;
    initial
    begin
        log = $fopen("mul32p_tb_log.csv","w");
        #0.002
        forever
        begin
            #1.000
            if(mode == 1'b1)
            begin
                //          
                $fwrite(log,"%0t,%0b,%0d,%0d,%0d,%0d,%0b\n",$realtime,mode,a,b,exp_res_signed,res_signed,eq);
            end
            else
            begin
                $fwrite(log,"%0t,%0b,%0d,%0d,%0d,%0d,%0b\n",$realtime,mode,a_,b_,exp_res_unsigned,res_unsigned,eq_u);
            end
        end
    end
    initial
    begin
        $dumpfile("mul32p_tb.vcd");
        $dumpvars(0,mul32p_tb);
        $timeformat(-9,2," ns",6);
        clk <= 0;
        mode <= 0;
        a <= 292;
        b <= 6785;
        #0.001
        $fwrite(log,"Time,Mode,a,b,exp_res,res,eq\n");
        #2.000
        a <= 32'h8FA4B672;
        b <= 32'h6C3F8132;
        #2.000
        mode <= 1;
        #20.000
        $fclose(log);
        $finish;
    end

endmodule