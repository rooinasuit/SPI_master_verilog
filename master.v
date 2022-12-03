module master (
    input CTRL_CLK,
    input SCLK_PULSE,
    input NRST,

    // SPI data stash //
    input [7:0] MOSI_data,
    output [7:0] MISO_data,
    //
    output [7:0] stash_ptr, 

    // pure SPI part //
    input MISO,      // master in slave out
    //
    output reg CS,   // chip select to slave (stable low upon transmission for a single-slave case)
    output reg SCLK, // SPI clock (the driven one) ~20MHz 
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
                    if (!ENABLE) begin
                        state <= START;
                    end
                end
                START: begin
                    CS <= 1'b0;
                    state <= CLK_STRETCH;
                end
                TRANSACTION: begin
                    case (bit_cycle)
                        0: begin
                            if (bit_counter <= 7)
                                MOSI_buffer <= MOSI_data;
                            else 
                        end
                        1: begin
                            SCLK <= 1'b1;
                            if (posedge SCLK) begin
                                MOSI <= MOSI_buffer[bit_counter];
                            end
                        end
                        2: begin
                            
                        end

                        3: begin
                            SCLK <= 0'b0;
                            if (negedge SCLK) begin
                                MISO_buffer <= {MISO_buffer[6:0], MISO};
                            end 
                        end
                    endcase
                end
                default: begin
                    CS <= 1'b1;
                    SCLK <= 1'b0;
                    MOSI <= 1'b0;
                    
                    bit_counter <= 3'd7;
                    state <= IDLE;
                end
            endcase
        end
    end
end

always @ (posedge CTRL_CLK) begin
    if (!NRST) begin
        MOSI_buffer <= 8'd0;
        MISO_buffer <= 8'd0;
        bit_counter <= 3'd0;
    end
    else begin
        MOSI_buffer <= MOSI_data; // from rom to buffer
        // 
        MISO_data <= MISO_buffer; // from buffer to rom
    end   

end

endmodule