module tb_vending_machine_refund;

    reg clk;
    reg reset;
    reg coin_0_5;
    reg coin_1;
    reg beverage_select;
    wire beverage;
    wire [1:0] change;

    // Instantiate the vending machine with refund module
    vending_machine_refund uut (
        .clk(clk),
        .reset(reset),
        .coin_0_5(coin_0_5),
        .coin_1(coin_1),
        .beverage_select(beverage_select),
        .beverage(beverage),
        .change(change)
    );

    // Clock signal generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period => 100MHz clock
    end

    // Test cases
    initial begin
        // Initialize signals
        reset = 1; coin_0_5 = 0; coin_1 = 0; beverage_select = 0;
        #15 reset = 0; // Release reset signal

        // Insert 0.5 yuan coin
        #10 coin_0_5 = 1; #10 coin_0_5 = 0;

        // Insert 1 yuan coin
        #10 coin_1 = 1; #10 coin_1 = 0;

        // Insert another 0.5 yuan coin
        #10 coin_0_5 = 1; #10 coin_0_5 = 0;

        // Reset for refund
        #10 reset = 1; #10 reset = 0;

        // Insert 1 yuan coin to purchase beverage
        #10 coin_1 = 1; #10 coin_1 = 0;
        #10 coin_1 = 1; #10 coin_1 = 0;

        // Select beverage
        #10 beverage_select = 1; #10 beverage_select = 0;

        // End simulation
        #50 $stop;
    end
endmodule
