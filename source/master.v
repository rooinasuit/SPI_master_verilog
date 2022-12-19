module master (
    // synchronising domains //
    input CTRL_CLK,
    input SCLK_PULSE,
    input NRST,
    input ENABLE,

    // SPI master data stash //
    input [7:0] MOSI_data,
    output reg [7:0] MISO_data,
    //
    output reg [7:0] master_stash_ptr, 

    // pure SPI part //
    input MISO,      // master in slave out
    //
    output reg CS,   // chip select to slave (stable low upon transmission for a single-slave case)
    output reg SCLK, // SPI clock (the driven one)
    output reg MOSI  // master out slave in
);

// THE CHOSEN SPI MODE IS [0] //

// SCLK stays low on idle
// Data sent on posedge
// Data received on negedge

localparam IDLE = 0;
localparam START = 1;
localparam TRANSACTION = 2;

reg [1:0] state;

reg [7:0] MOSI_buffer;
reg [7:0] MISO_buffer;

reg [2:0] bit_counter;
reg [1:0] bit_cycle;

always @ (posedge CTRL_CLK) begin
    if (!NRST) begin
        CS <= 1'b1;
        SCLK <= 1'b0;
        MOSI <= 1'b0;
        
        MISO_buffer <= 8'd0;
        MOSI_buffer <= 8'd0;
        master_stash_ptr <= 8'd0;

        bit_cycle <= 2'd0;
        bit_counter <= 3'd7;
        state <= IDLE;
    end
    else begin
        if (SCLK_PULSE) begin
            case (state)
                IDLE: begin
                    CS <= 1'b1;
                    SCLK <= 1'b0;
                    MOSI <= 1'b0;

                    MISO_buffer <= 8'd0;
                    MOSI_buffer <= 8'd0;

                    bit_cycle <= 2'd0;
                    bit_counter <= 3'd7;
                    if (!ENABLE) begin
                        state <= START;
                    end
                end
                START: begin
                    CS <= 1'b0;
                    state <= TRANSACTION;
                end
                TRANSACTION: begin
                    case (bit_cycle)
                        0: begin
                            if (bit_counter == 7) begin
                                MOSI_buffer <= MOSI_data;
                                bit_cycle <= 1;
                            end
                            else
                                bit_cycle <= 1;
                        end
                        1: begin
                            SCLK <= 1'b1;
                            MOSI <= MOSI_buffer[bit_counter];
                            bit_cycle <= 2;
                        end
                        2: begin
                            SCLK <= 1'b0;
                            bit_counter <= bit_counter - 1'b1;
                            MISO_buffer <= {MISO_buffer[6:0], MISO};
                        end
                        3: begin
                            if (bit_counter == 3'd0) begin
                                MISO_data <= MISO_buffer;
                                master_stash_ptr <= master_stash_ptr + 1'b1;
                                bit_cycle <= 0;
                                bit_counter <= 3'd7;
                            end
                            else
                                bit_cycle <= 0;
                        end
                    endcase
                end
                default: begin
                    CS <= 1'b1;
                    SCLK <= 1'b0;
                    MOSI <= 1'b0;

                    MISO_buffer <= 8'd0;
                    MOSI_buffer <= 8'd0;

                    bit_cycle <= 2'd0;
                    bit_counter <= 3'd7;
                    if (!ENABLE) begin
                        state <= START;
                    end
                end
            endcase
        end
        else if (!ENABLE)
            CS <= 1'b1;
            state <= IDLE;
      end
end

endmodule