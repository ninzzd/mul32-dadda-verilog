// Author: Ninaad Desai
// Description: mul32p (pipelined 32-bit dadda multiplier) self-tester with LFSRs
`timescale 1 ns / 100 ps
module mul32phw(
    input clk,
    input rst,
    output err 
);
	reg clk_;
	wire mode;
	wire signed [31:0] a;
	wire signed [31:0] b;
	wire [31:0] au;
	wire [31:0] bu;
	wire [31:0] seed_a;
	wire [31:0] seed_b;
	wire [31:0] mask_a;
	wire [31:0] mask_b;
	wire signed [63:0] exp_ress;
	wire [63:0] exp_resu;
    wire [63:0] exp_res;
    wire [63:0] exp_res_buff;
    wire [63:0] res;
	
	lfsr #(.N(32)) lfsr_a(.clk(clk_),.rst(rst),.seed(seed_a),.mask(mask_a),.q(au));
	lfsr #(.N(32)) lfsr_b(.clk(clk_),.rst(rst),.seed(seed_b),.mask(mask_b),.q(bu));
    buffer #(.W(64),.L(8)) buff32 (
        .clk(clk),
        .in(exp_res),
        .out(exp_res_buff)
    );
	mul32p uut(
        .clk(clk),
        .a(a),
        .b(b),
        .mode(mode),
        .hi(res[63:32]),
        .lo(res[31:0])
    );
	
	assign mode = ~rst&clk;
	assign a = au; // a & au hold the same bits always, they differ in interpretation
	assign b = bu; // b & bu hold the same bits always, they differ in interpretation
	assign exp_resu = au * bu;
	assign exp_ress = a * b;
	assign exp_res = {64{~mode}}&exp_resu | {64{mode}}&exp_ress;
	assign err = (res == exp_res_buff ? 1'b0 : 1'b1);
	assign mask_a = 32'h8020_0003;
	assign mask_b = 32'h8000_0063;
	assign seed_a = 32'h0000_0001;
	assign seed_b = 32'hDEAD_BEEF;
	initial 
	begin
		clk_ <= 1'b0;
		
	end
	always @(posedge clk)
	begin
		clk_ <= ~clk_;
    end
endmodule