module vending_machine_refund (
    input wire clk,          // Clock signal
    input wire reset,        // Reset signal (also acts as refund signal)
    input wire coin_0_5,     // 0.5 yuan coin input
    input wire coin_1,       // 1 yuan coin input
    input wire beverage_select, // Beverage selection input
    output reg beverage,     // Beverage output
    output reg [1:0] change  // Change output (00 = 0 yuan, 01 = 0.5 yuan, 10 = 1 yuan)
);

    // State Encoding
    parameter IDLE = 3'b000, 
              COIN_INSERTED = 3'b001, 
              BEVERAGE_SELECTED = 3'b010, 
              DISPENSING = 3'b011, 
              REFUND = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] coin_count;

    // State Transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= REFUND;
        end else begin
            state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        next_state = state; // Default to stay in the same state
        beverage = 0;
        change = 2'b00;

        case (state)
            IDLE: begin
                if (coin_0_5 || coin_1)
                    next_state = COIN_INSERTED;
            end
            COIN_INSERTED: begin
                if (coin_0_5)
                    coin_count = coin_count + 1;
                else if (coin_1)
                    coin_count = coin_count + 2;
                    
                if (coin_count >= 4) // 2 yuan needed
                    next_state = BEVERAGE_SELECTED;
            end
            BEVERAGE_SELECTED: begin
                if (beverage_select)
                    next_state = DISPENSING;
            end
            DISPENSING: begin
                beverage = 1;
                if (coin_count > 4) begin
                    change = (coin_count - 4) / 2;
                end
                next_state = IDLE;
            end
            REFUND: begin
                change = coin_count / 2;
                next_state = IDLE;
            end
        endcase
    end

endmodule
