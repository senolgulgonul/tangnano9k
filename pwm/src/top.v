module pwm_generator(
    input wire clk,         // 27MHz clock input
    input wire button1,     // Button to increase duty cycle (active-low)
    input wire button2,     // Button to decrease duty cycle (active-low)
    input wire button3,     // Button to decrease duty cycle (active-low)

    output reg pwm_out      // PWM output
);

    reg [19:0] counter;     // 20-bit counter to handle up to 540,000
    reg [19:0] duty_cycle;  // Register to store duty cycle
    reg [19:0] max_count = 540000;  // 27MHz / 50Hz = 540,000

    // State variables to track button presses
    reg button1_pressed = 0;
    reg button2_pressed = 0;

    initial begin
        duty_cycle = 27000;  // Initial 5% duty cycle
    end

    always @(posedge clk) begin
        if (counter < max_count - 1)
            counter <= counter + 1;
        else
            counter <= 0;
    end

    always @(posedge clk) begin
        if (counter < duty_cycle)
            pwm_out <= 1;
        else
            pwm_out <= 0;
    end

    always @(posedge clk) begin
        if (!button1) begin  // Button1 pressed (active-low)
            if (!button1_pressed && duty_cycle < 54000) begin
                duty_cycle <= duty_cycle + 2700;  // Increase by 0.5%
                button1_pressed <= 1;
            end
        end else begin
            button1_pressed <= 0;
        end
        
        if (!button2) begin  // Button2 pressed (active-low)
            if (!button2_pressed && duty_cycle > 27000) begin
                duty_cycle <= duty_cycle - 2700;  // Decrease by 0.5%
                button2_pressed <= 1;
            end
        end else begin
            button2_pressed <= 0;
        end
    end

endmodule
