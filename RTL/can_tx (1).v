// can_tx.v - simplified transmitter (sends 8-bit data as a toy 'frame')
module can_tx(
input wire clk,
input wire rst_n,
input wire bit_clk,
input wire sample_point,
input wire [7:0] tx_data,
input wire tx_start,
output reg tx_busy,
output reg can_tx,
output reg tx_done
);
reg [3:0] state;
localparam IDLE=0, LOAD=1, SEND=2, EOF=3;
reg [3:0] bit_cnt;
reg [7:0] shift;
always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
state <= IDLE; tx_busy <= 0; can_tx <= 1; tx_done <= 0;
bit_cnt <= 0; shift <= 0;
end else begin
tx_done <= 0;
if (tx_start && state==IDLE) begin
state <= LOAD; tx_busy <= 1;
end
if (sample_point) begin
case(state)
LOAD: begin
shift <= tx_data;
bit_cnt <= 0;
state <= SEND;
can_tx <= 1; // recessive before sending
end
SEND: begin
// send LSB first (toy format), dominant = 0, recessive = 1can_tx <= shift[0];
can_tx <= shift[0];
shift <= {1'b1, shift[7:1]};
bit_cnt <= bit_cnt + 1;
if (bit_cnt==7) state <= EOF;
end
EOF: begin
can_tx <= 1; // release bus
tx_done <= 1;
tx_busy <= 0;
state <= IDLE;
end
default: state <= IDLE;
endcase
end
end
end
endmodule
