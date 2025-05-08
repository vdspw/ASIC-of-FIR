`timescale 1ns / 1ps

module shift_register_logic_tb;
    // Inputs
    logic Clock, Reset, FILTER, BitIn;

    // Instantiate the DUT (Device Under Test)
    filt dut (
        .Clock(Clock),
        .Reset(Reset),
        .FILTER(FILTER),
        .BitIn(BitIn)
    );

    // Clock generation (50 MHz, 20ns period)
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

    // Test stimulus
    initial begin
        // Initialize inputs
      
      $dumpfile("shift_register_logic.vcd");
        $dumpvars(0, shift_register_logic_tb);
      
        Reset = 1;
        FILTER = 0;
        BitIn = 0;

        // Apply reset
        #20;
        Reset = 0;

        // Wait a few cycles
        #40;

        // Send a pattern of bits to buffer_1_q
        $display("Loading bits into buffer_1_q...");
        repeat (8) begin
            BitIn = $random % 2; // Random bit (0 or 1)
            #20;
            $display("Time=%0t: BitIn=%b, buffer_1_q[7:0]=%b, buffer_2_q[7:0]=%b", 
                     $time, BitIn, dut.buffer_1_q[7:0], dut.buffer_2_q[7:0]);
        end

        // Pulse FILTER to transfer buffer_1_q to buffer_2_q
        $display("Pulsing FILTER to transfer buffer_1_q to buffer_2_q...");
        FILTER = 1;
        #20;
        $display("Time=%0t: FILTER=%b, buffer_1_q[7:0]=%b, buffer_2_q[7:0]=%b (FILTER high)", 
                 $time, FILTER, dut.buffer_1_q[7:0], dut.buffer_2_q[7:0]);
        FILTER = 0;
        #20;
        $display("Time=%0t: FILTER=%b, buffer_1_q[7:0]=%b, buffer_2_q[7:0]=%b (post-transfer)", 
                 $time, FILTER, dut.buffer_1_q[7:0], dut.buffer_2_q[7:0]);

        // Send a few more bits to show buffer_1_q shifts but buffer_2_q stays
        $display("Sending more bits to buffer_1_q...");
        repeat (4) begin
            BitIn = $random % 2;
            #20;
            $display("Time=%0t: BitIn=%b, buffer_1_q[7:0]=%b, buffer_2_q[7:0]=%b", 
                     $time, BitIn, dut.buffer_1_q[7:0], dut.buffer_2_q[7:0]);
        end

        // Pulse FILTER again for another transfer
        $display("Pulsing FILTER again...");
        FILTER = 1;
        #20;
        $display("Time=%0t: FILTER=%b, buffer_1_q[7:0]=%b, buffer_2_q[7:0]=%b (FILTER high)", 
                 $time, FILTER, dut.buffer_1_q[7:0], dut.buffer_2_q[7:0]);
        FILTER = 0;
        #20;
        $display("Time=%0t: FILTER=%b, buffer_1_q[7:0]=%b, buffer_2_q[7:0]=%b (post-transfer)", 
                 $time, FILTER, dut.buffer_1_q[7:0], dut.buffer_2_q[7:0]);

        // End simulation
        #100;
        $finish;
    end
endmodule
