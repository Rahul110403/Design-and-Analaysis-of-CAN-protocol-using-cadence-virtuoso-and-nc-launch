// can_tbu.v - simplified bit timing uni
module can_tbu #(
 parameter SYSCLK_FREQ = 100_000_000,
 parameter BITRATE = 125_000
)(
 input wire clk,
 input wire rst_n,
 output reg bit_clk,// pulses once per CAN bit-time
 output reg sample_point
);
// asserted at sample point inside bit-time);
localparam integer CYCLES_PER_BIT = SYSCLK_FREQ / BITRATE;
integer counter;
integer sample_count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		counter <= 0;
		bit_clk <= 0;
		sample_point <= 0;
		sample_count <= 0;
	end else begin
		counter <= counter + 1;
		if (counter >= CYCLES_PER_BIT-1) begin
			counter <= 0;
			bit_clk <= 1;
			sample_count <= 0;
			sample_point <= 0;
			end 
		else begin
			bit_clk <= 0;
// sample at 75% of bit-time (simple)
		if (counter == (CYCLES_PER_BIT*3)/4) sample_point <= 1;
		else sample_point <= 0;
		end
  	  end
end
endmodule
