module mul32phw #(parameter N = 4096)(
    input clk,
    input rst
);
    // fsm wires and regs
    reg [1:0] state;

    // lfsr wires and regs
    reg lfsr_clk;
    reg lfsr_rst_cnt;
    wire [31:0] mask_a;
    wire [31:0] seed_a;
    wire [31:0] mask_b;
    wire [31:0] seed_b;
    reg lfsr_rst;
    assign mode = ~lfsr_clk;
    assign mask_a = 32'h8020_0003;
    assign seed_a = 32'h0000_0001;
    assign mask_b = 32'h8000_0063;
    assign seed_b = 32'hDEAD_BEEF;

    // mul32 wires and regs
    wire [31:0] a;
    wire [31:0] b;
    wire mode;
    wire [63:0] res;


    lfsr #(.N(32)) lfsr_a(
        .seed(seed_a),
        .mask(mask_a),
        .rst(lfsr_rst),
        .clk(lfsr_clk),
        .q(a)
    );

    lfsr #(.N(32)) lfsr_b(
        .seed(seed_b),
        .mask(mask_b),
        .rst(lfsr_rst),
        .clk(lfsr_clk),
        .q(b)
    );

    mul32p dut(
        .a(a),
        .b(b),
        .mode(mode),
        .clk(clk),
        .hi(res[63:32]),
        .lo(res[31:0])
    );

    initial
    begin
        lfsr_clk <= 1'b0;
        lfsr_rst_cnt <= 1'b0;
        state <= 4'h0;      
    end

    always @(posedge clk)
    begin
        if(rst)
        begin
            state <= 2'b00;
            lfsr_clk <= 1'b1;
        end
        case(state)
            2'b00:
            begin
                lfsr_rst_cnt <= 1'b0;
                lfsr_rst <= 1'b1;
                state <= 2'b01;
            end
            2'b01:
            begin
                lfsr_rst_cnt <= 1'b1;
                if(lfsr_rst_cnt == 1'b1)
                begin
                    lfsr_rst <= 1'b0;
                    state <= 2'b10;
                end
            end
            2'b10:
            begin

            end
        endcase 
    end
    always @(posedge clk)
    begin
        lfsr_clk <= ~lfsr_clk;
    end
endmodule