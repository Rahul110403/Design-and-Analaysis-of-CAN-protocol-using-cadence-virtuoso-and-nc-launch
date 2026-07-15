module can_bittiming #(
    parameter CLK_FREQ_HZ = 50000000
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] brp,       // prescaler (>=1)
    input  wire [11:0] tseg_reg,  // SJW[11:8], TSEG1[7:4], TSEG2[3:0]
    input  wire        enable,
    output reg         bit_clk,       // pulses once per CAN nominal bit
    output reg         sample_point   // asserted at sample point cycle
);

// Simple implementation: Use BRP to divide reference clock to TQ, and count TQs
reg [31:0] tq_cnt;
reg [31:0] tq_limit;
reg [7:0]  tq_per_bit;
reg [7:0]  tseg1, tseg2, sjw;
reg [7:0]  tq_pos; // current tq position
reg [31:0] brp_cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        brp_cnt <= 32'd0;
        tq_cnt <= 32'd0;
        tq_per_bit <= 8'd16; // default
        tseg1 <= 8'd13;
        tseg2 <= 8'd2;
        sjw <= 8'd1;
        tq_pos <= 8'd0;
        bit_clk <= 1'b0;
        sample_point <= 1'b0;
    end else begin
        // decode regs
        sjw <= tseg_reg[11:8];
        tseg1 <= tseg_reg[7:4];
        tseg2 <= tseg_reg[3:0];
        // simple safety defaults
        if (tseg1 == 8'd0) tseg1 <= 8'd13;
        if (tseg2 == 8'd0) tseg2 <= 8'd2;
        if (brp == 16'd0) tq_limit <= 32'd1; else tq_limit <= brp;

        if (!enable) begin
            brp_cnt <= 32'd0;
            tq_pos <= 8'd0;
            bit_clk <= 1'b0;
            sample_point <= 1'b0;
        end else begin
            // BRP divides reference clock into Time Quanta (TQ)
            if (brp_cnt >= (tq_limit-1)) begin
                brp_cnt <= 32'd0;
                // advance time quantum
                if (tq_pos >= (tseg1 + tseg2 + 1)) begin
                    tq_pos <= 8'd0;
                    bit_clk <= 1'b1; // pulse
                end else begin
                    tq_pos <= tq_pos + 8'd1;
                    bit_clk <= 1'b0;
                end
                // sample point when tq_pos == tseg1 (after sync + prop)
                sample_point <= (tq_pos == tseg1);
            end else begin
                brp_cnt <= brp_cnt + 32'd1;
                bit_clk <= 1'b0;
                sample_point <= 1'b0;
            end
        end
    end
end

endmodule
