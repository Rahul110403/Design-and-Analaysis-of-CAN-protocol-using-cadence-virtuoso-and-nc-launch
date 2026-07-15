// can_rx.v - simplified receiver to match the toy transmitter above
module can_rx(
input wire clk,
input wire rst_n,
input wire bit_clk,
input wire sample_point,
input wire can_rx,
output reg rx_valid,
output reg [7:0] rx_data,
output reg rx_done
);
reg [3:0] state;
localparam R_IDLE=0, R_RECV=1, R_DONE=2;
reg [3:0] bit_cnt;
reg [7:0] shift;
always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
state <= R_IDLE; 
bit_cnt <= 0;
shift <= 0;
rx_data <= 0;
rx_valid <= 0; 
rx_done <= 0; 
end else begin
rx_done <= 0;
rx_valid <= 0;
if (sample_point) begin
case(state)
R_IDLE: begin
// detect start by sampling: if bus != 1 (recessive) assume start
if (can_rx==1'b0) begin
state <= R_RECV;
bit_cnt <= 0;
shift <= 8'hFF;
end
end
R_RECV: begin
// sample at sample_point -- in this simplified model we sample on bit_clk
shift <= {can_rx, shift[7:1]};
bit_cnt <= bit_cnt + 1;
if (bit_cnt==7) state <= R_DONE;
end
R_DONE: begin
rx_data <= shift;
rx_valid <= 1;
rx_done <= 1;
state <= R_IDLE;
end
default: state <= R_IDLE;
endcase
end
end
end endmodule
