// Author: Ninaad Desai
// Description: 32-bit pipelined dadda multiplier testbench
`timescale 1ns/1ps
module mul32p_tb();
    reg [1:0] mode;
    reg clk;
    reg signed [31:0] a;
    reg signed [31:0] b;
    wire [1:0] mode_;
    wire signed [31:0] a_; // a after buffer
    wire signed [31:0] b_; // b after buffer
    wire [31:0] a_u; // a after buffer as unsigned
    wire [31:0] b_u; // b after buffer as unsigned

    // Actual results
    wire [63:0] res;
    wire signed [63:0] res_s;
    // Expected results
    wire signed [63:0] exp_res_ss;
    wire signed [63:0] exp_res_su;
    wire [63:0] exp_res_uu;
    // Comparison
    wire eq_su;
    wire eq_uu;
    wire eq_ss;


    // Clock
    always #0.500 clk = ~clk;

    // Design under test
    mul32p #(.T(0.000)) uut(
        .clk(clk),
        .a(a),
        .b(b),
        .mode(mode),
        .lo(res[31:0]),
        .hi(res[63:32])
    );
    assign res_s = res;
    // Buffering inputs to DUT for expected result calculation
    buffer #(.W(66),.L(8)) buff(
        .clk(clk),
        .in({a,b,mode}),
        .out({a_,b_,mode_})
    );
    assign a_u = a_;
    assign b_u = b_;
    assign exp_res_ss = $signed(a_)*$signed(b_);
    assign exp_res_su = $signed(a_)*$unsigned(b_);
    assign exp_res_uu = $unsigned(a_u)*$unsigned(b_u);
    assign eq_ss = (res_s == exp_res_ss)?1'b1:1'b0;
    assign eq_su = (res_s == exp_res_su)?1'b1:1'b0;
    assign eq_uu = (res == exp_res_uu)?1'b1:1'b0;

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
            // if(mode_ == 1'b1)
            // begin
            //     //          
            //     $fwrite(log,"%0t,%0b,%0d,%0d,%0d,%0d,%0b\n",$realtime,mode_,a_,b_,exp_res_signed,res_signed,eq);
            // end
            // else
            // begin
            //     $fwrite(log,"%0t,%0b,%0d,%0d,%0d,%0d,%0b\n",$realtime,mode_,a_u,b_u,exp_res_unsigned,res_unsigned,eq_u);
            // end
            if(mode_ == 2'b00) // uu
            begin
                $fwrite(log,"%3t,%2b,%0d,%0d,%0d,%0d,%0b\n",$realtime,mode_,a_u,b_u,exp_res_uu,res,eq_uu);
            end
            else if(mode_ == 2'b01) // ss
            begin
                $fwrite(log,"%3t,%2b,%0d,%0d,%0d,%0d,%0b\n",$realtime,mode_,a_,b_,exp_res_ss,res_s,eq_ss);
            end
            else if(mode_ == 2'b10) // su
            begin
                $fwrite(log,"%3t,%2b,%0d,%0d,%0d,%0d,%0b\n",$realtime,mode_,a_,b_,exp_res_su,res_s,eq_su);
            end
        end
    end
    initial
    begin
        $dumpfile("mul32p_tb.vcd");
        $dumpvars(0,mul32p_tb);
        $timeformat(-9,2," ns",6);
        clk <= 0;
        mode <= 2'b00;
        a <= 292;
        b <= 6785;
        #0.001
        $fwrite(log,"Time,Mode,a,b,exp_res,res,eq\n");
        #2.000
        mode <= 2'b01;
        a <= -12345678;
        b <= 87654321;
        #2.000
        mode <= 2'b10;
        a <= 32'h7AAAAAAA;
        b <= -1;
        #20.000
        $fclose(log);
        $finish;
    end

endmodule