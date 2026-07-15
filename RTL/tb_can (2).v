module tb_can;
    reg         clk;
    reg         rst_n;
    reg  [7:0]  tx_data;
    reg         tx_start;
    wire        tx_busy;

    wire        can_tx;
    wire        can_rx;

    wire        rx_valid;
    wire [7:0]  rx_data;

    // LOOPBACK CONNECTION (can_rx <— can_tx)
    assign can_rx = can_tx;
   real can_h_v,can_l_v;
   always @(*) begin 
     if (can_tx == 1'b0) begin 
        can_h_v = 3.5;
        can_l_v = 1.5;
     end else begin 
        can_h_v = 2.5;
        can_l_v = 2.5;
    end 
end

    // DUT INSTANCE
    can_top dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .tx_data  (tx_data),
        .tx_start (tx_start),
        .tx_busy  (tx_busy),
        .rx_valid (rx_valid),
        .rx_data  (rx_data),
        .can_tx   (can_tx),
        .can_rx   (can_rx)
    );

    // CLOCK: 100 MHz → 10 ns period
    always #5 clk = ~clk;

    initial begin
        // DEFAULTS
        clk      = 0;
        rst_n    = 0;
        tx_start = 0;
        tx_data  = 8'hA5;

        // RESET
        #100;
        rst_n = 1;

        // WAIT A LITTLE
        #200;

        // START TRANSMISSION (PULSE MUST BE WIDE ENOUGH)
        tx_start = 1;
        #50;               // MINIMUM 5 clock cycles for safety
        tx_start = 0;

        // WAIT FOR RECEIVER
        wait (rx_valid == 1);
        #20;

        $display("CAN RX DATA = %h at time %0t", rx_data, $time);

        #200;
        $finish;
    end

endmodule
