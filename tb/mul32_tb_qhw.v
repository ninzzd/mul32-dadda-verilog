module mul32_tb_qhw(
	input clk,
	output [63:0] res,
	output [63:0] exp_res, // Unsigned interpretation of signed OR unsigned multiplication 
	output err
);
	reg clk_;
	reg rst;
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
	
	lfsr #(.N(32)) lfsr_a(.clk(clk_),.rst(rst),.seed(seed_a),.mask(mask_a),.q(au));
	lfsr #(.N(32)) lfsr_b(.clk(clk_),.rst(rst),.seed(seed_b),.mask(mask_b),.q(bu));
	mul32 uut(.a(a),.b(b),.mode(mode),.hi(res[63:32]),.lo(res[31:0]));
	
	assign mode = clk;
	assign a = au; // a & au hold the same bits always, they differ in interpretation
	assign b = bu; // b & bu hold the same bits always, they differ in interpretation
	assign exp_resu = au * bu;
	assign exp_ress = a * b;
	assign exp_res = {32{~mode}}&exp_resu | {32{mode}}&exp_ress;
	assign err = (res == exp_res ? 1'b0 : 1'b1);
	assign mask_a = 32'h8020_0003;
	assign mask_b = 32'h8000_0063;
	assign seed_a = 32'h0000_0001;
	assign seed_b = 32'hDEAD_BEEF;
	initial 
	begin
		clk_ <= 1'b0;
		rst <= 1'b1;
	end
	
	always @(posedge clk)
	begin
		if(rst == 1'b1)
		begin
			rst <= 0;
		end
		clk_ <= ~clk_;
	end
endmodule