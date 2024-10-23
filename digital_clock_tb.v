`timescale 1ns / 1ps
`include "design_top.v"

module digital_clock_tb();
    reg clk_100MHz, reset;
    reg inc_hr, inc_min;
    reg inc_day, inc_month, inc_year, inc_cent;
    reg set_am_pm;

    wire blink, hsync, vsync;
    wire [11:0] rgb;

    localparam T = 2;
    design_top clock (.clk_100MHz(clk_100MHz), .reset(reset),
        .inc_hr(inc_hr), .inc_min(inc_min), .inc_month(inc_month),
        .inc_day(inc_day), .inc_year(inc_year), .inc_cent(inc_cent),
        .set_am_pm(set_am_pm),
        .blink(blink), .hsync(hsync), .vsync(vsync),
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

    initial begin 
        // Simulate
        reset <= 1;
        inc_hr <= 0; inc_min <= 0; 
        inc_day <= 0; inc_month <= 0; inc_year <= 0; inc_cent <= 0;
        set_am_pm <= 0;
        #(2*T);
        reset <= 0;
        inc_month <= 1;
        #(14*T*4)
        inc_month <= 0;
        inc_day <= 1;
        #(29*T*8)
        inc_day <= 0;
        #(1000000*T*2); // 200000
        $finish;
    end
endmodule
    /*
    // In new_binary_clock -> count seconds
    // create the 1Hz signal
    reg [31:0] ctr_1Hz = 32'h0;
    reg r_1Hz = 1'b0;
    always @(posedge clk_100MHz or posedge reset)
        if(reset)
            ctr_1Hz <= 32'h0;
        else
            if(ctr_1Hz == 49_999_999) begin
                ctr_1Hz <= 32'h0;
                r_1Hz <= ~r_1Hz;
            end
            else
                ctr_1Hz <= ctr_1Hz + 1;
    // ================
    // In calendar -> fix begining day
    // calendar regs and logic
    reg [3:0] month = 10;
    reg [4:0] day = 22;
    reg [6:0] year = 24;
    reg [6:0] century = 20;
    */
    