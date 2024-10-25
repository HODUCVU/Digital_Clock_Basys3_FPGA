// `timescale 1ns / 1ps
module new_binary_clock(
    input clk_100MHz,                   // sys clock
    input reset,                        // reset clock
    input tick_hr,                      // to increment hours
    input tick_min,                     // to increment minutes
    output tick_1Hz,                    // 1Hz output signal
    output [3:0] sec_1s, sec_10s,       // BCD outputs for seconds
    output [3:0] min_1s, min_10s,       // BCD outputs for minutes
    output [3:0] hr_1s, hr_10s          // BCD outputs for hours
    );
    
	// signals for button debouncing
	reg a, b, c, d, e, f;
	wire db_hr, db_min;
	
	// debounce tick hour button input
	always @(posedge clk_100MHz) begin
		a <= tick_hr;
		b <= a;
		c <= b;
	end
	assign db_hr = c;
	
	// debounce tick minute button input
	always @(posedge clk_100MHz) begin
		d <= tick_min;
		e <= d;
		f <= e;
	end
	assign db_min = f;
	
    // ********************************************************
    // create the 1Hz signal
    reg [31:0] ctr_1Hz = 32'h0;
    reg r_1Hz = 1'b0;
    
    always @(posedge clk_100MHz or posedge reset)
        if(reset)
            ctr_1Hz <= 32'h0;
        else
            if(ctr_1Hz == 1) begin //49_999_999
                ctr_1Hz <= 32'h0;
                r_1Hz <= ~r_1Hz;
            end
            else
                ctr_1Hz <= ctr_1Hz + 1;
     
    // ********************************************************
    // regs for each time value
    reg [5:0] seconds_ctr = 6'b0;   // 0
    reg [5:0] minutes_ctr = 6'b0;   // 0
    reg [4:0] hours_ctr = 5'h17;// 23 --- 4'hc;     // 12
	
	// seconds counter reg control
    always @(posedge tick_1Hz or posedge reset)
        if(reset)
            seconds_ctr <= 6'b0;
        else
            if(seconds_ctr == 59)
                seconds_ctr <= 6'b0;
            else
                seconds_ctr <= seconds_ctr + 1;
            
    // minutes counter reg control       
    always @(posedge tick_1Hz or posedge reset)
        if(reset)
            minutes_ctr <= 6'b0;
        else 
            if(db_min | (seconds_ctr == 59))
                if(minutes_ctr == 59)
                    minutes_ctr <= 6'b0;
                else
                    minutes_ctr <= minutes_ctr + 1;
                    
    // hours counter reg control
    always @(posedge tick_1Hz or posedge reset)
        if(reset)
            hours_ctr <= 5'h17;// 4'hc;  // 12
        else 
            if(db_hr | (minutes_ctr == 59 && seconds_ctr == 59))
                if(hours_ctr == 23)
                    hours_ctr <= 5'h0;
                else
                    hours_ctr <= hours_ctr + 1;
                    
    // ********************************************************                
    // convert binary values to output bcd values
    assign sec_10s = seconds_ctr / 10;
    assign sec_1s  = seconds_ctr % 10;
    assign min_10s = minutes_ctr / 10;
    assign min_1s  = minutes_ctr % 10;
    assign hr_10s  = hours_ctr   / 10;
    assign hr_1s   = hours_ctr   % 10;     
     
    // 1Hz output            
    assign tick_1Hz = r_1Hz; 
            
endmodule