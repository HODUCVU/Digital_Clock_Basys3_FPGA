`timescale 1ns / 1ps
`include "top.v"

module digital_clock_tb();
    reg clk_100MHz, reset;
    reg inc_hr, inc_min;

    wire hsync, vsync;
    wire [11:0] rgb;

    localparam T = 2;
    top clock (.clk_100MHz(clk_100MHz), .reset(reset),
        .tick_hr(inc_hr), .tick_min(inc_min), 
        .hsync(hsync), .vsync(vsync),
        .rgb(rgb));
    
    always begin 
        clk_100MHz = 1'b1;
        #(T/2);
        clk_100MHz = 1'b0;
        #(T/2);
    end
    initial begin 
        $dumpfile("digital_clock_tb.vcd");
        $dumpvars(0, digital_clock_tb);
    end
    // Simulate
    initial begin 
        reset <= 1;
        inc_hr <= 0; inc_min <= 0; 
        #(2*T);
        reset <= 0;
        // modify minutes and hours
        inc_min <= 1;
        #(14*T*4)
        inc_min <= 0;
        inc_hr <= 1;
        #(14*T*4)
        inc_hr <= 0;
        #(1000000*T*2); // 200000
        $finish;
    end
endmodule