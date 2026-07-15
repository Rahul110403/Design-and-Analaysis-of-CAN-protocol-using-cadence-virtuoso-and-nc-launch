// can_top.v - Simplified CAN controller top
module can_top(
	input wire clk,// system clock
	input wire rst_n,
// APB-lite/simple reg interface signals (simplified)
	input wire [7:0] tx_data,
	input wire tx_start,
	output wire tx_busy,
	output wire rx_valid,
	output wire [7:0] rx_data,
// physical single-wire representation for simulation only
	output wire can_tx,
// drives bus (0 dominant, 1 recessive)
	input wire can_rx
// sampled bus
);
wire bit_clk;
wire sample_point;
wire tx_shift_en;
wire rx_shift_en;
wire [10:0] tx_frame_bits;
wire tx_done;
wire rx_done;
can_tbu #(.SYSCLK_FREQ(100_000_000), .BITRATE(125_000)) tbu (
	.clk(clk), .rst_n(rst_n),
	.bit_clk(bit_clk),
	.sample_point(sample_point)
);
can_tx txu (
	.clk(clk), .rst_n(rst_n),
	.bit_clk(bit_clk),
	.sample_point(sample_point),
	.tx_data(tx_data),
	.tx_start(tx_start),
	.tx_busy(tx_busy),
	.can_tx(can_tx),
	.tx_done(tx_done)
);
can_rx rxu (
	.clk(clk), .rst_n(rst_n),
	.bit_clk(bit_clk),
	.sample_point(sample_point),
	.can_rx(can_rx),
	.rx_valid(rx_valid),
	.rx_data(rx_data),
	.rx_done(rx_done)
);
endmodule
