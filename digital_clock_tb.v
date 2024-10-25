`timescale 1ns / 1ps
`include "top.v"

module digital_clock_tb();
    reg clk_100MHz, reset;
    reg tick_hr, tick_min;
    reg set_alarm, alarm_en;
    wire buzzer;
    wire hsync, vsync;
    wire [11:0] rgb;

    localparam T = 2;
    top clock (.clk_100MHz(clk_100MHz), .reset(reset),
        .tick_hr(tick_hr), .tick_min(tick_min), 
        .set_alarm(set_alarm), .alarm_en(alarm_en),
        .buzzer(buzzer),
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
        tick_hr <= 0; tick_min <= 0; 
        set_alarm <= 0; alarm_en <= 0;

        #(2*T);
        reset <= 0;
        // modify minutes and hours
        // tick_min <= 1;
        // #(14*T*4)
        // tick_min <= 0;
        // tick_hr <= 1;
        // #(14*T*4)
        // tick_hr <= 0;
        // set alarm
        set_alarm <= 1;
        tick_min <= 1;
        #(14*T*4)
        tick_min <= 0;
        tick_hr <= 1;
        #(14*T*4)
        tick_hr <= 0;
        set_alarm <= 0;
        // enable alarm
        alarm_en <= 1;
        #(10000*T*4*10)
        alarm_en <= 0;
        #(1000000*T*2); // 200000
        $finish;
    end
endmodule