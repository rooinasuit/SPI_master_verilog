module slave (
    // synchronising domains //
    input CTRL_CLK,
    input SCLK_PULSE,
    input NRST,
    
    input [7:0] SDO_data,
    //
    output [7:0] slave_data_ptr,
    // pure SPI part //
    input CS,   // chip select from master
    input SCLK, // SPI clock (the driven one)
    input SDI,  // slave data in (from master)
    //
    output reg SDO  // slave data out (to master)
);

// will probably need to summon a slave's rom submodule here 

localparam IDLE = 0;
localparam TRANSACTION = 1;

// THE CHOSEN SPI MODE IS [0] //

// SCLK stays low on idle
// Data received on posedge
// Data sent on negedge

reg state;

reg [7:0] SDI_buffer;
reg [7:0] SDO_buffer;

reg [3:0] bit_counter;
reg [1:0] bit_cycle;

always @ (posedge CTRL_CLK) begin
    if (!NRST) begin
        SDO <= 1'b0;

        SDI_buffer <= 8'd0;
        SDO_buffer <= 8'd0;

        bit_cycle <= 2'd0;
        bit_counter <= 4'd8;
        state <= IDLE;
    end
    else begin
        if (SCLK_PULSE) begin
            case (state)
                IDLE: begin
                    SDO <= 1'b0;

                    SDI_buffer <= 8'd0;
                    SDO_buffer <= 8'd0;

                    bit_cycle <= 2'd0;
                    bit_counter <= 4'd8;
                    state <= IDLE;
                    if (!CS) begin
                        state <= TRANSACTION;
                    end
                end
                TRANSACTION: begin
                    case (bit_cycle)
                        0: begin
                            bit_counter <= bit_counter - 1'b1;
                            if (bit_counter == 7) begin
                                SDO_buffer <= SDO_data;
                                bit_cycle <= 1;
                            end
                            else
                                bit_cycle <= 1;
                        end
                        1: begin
                            SDI_buffer <= {SDI_buffer[6:0], SDI};
                            bit_cycle <= 2;
                        end
                        2: begin
                            SDO <= SDO_buffer[bit_counter];
                            bit_cycle <= 3;
                        end
                        3: begin
                            if (bit_counter == 0) begin
                                
                                bit_cycle <= 0;
                                bit_counter <= 4'd8;
                            end
                            else
                                bit_cycle <= 0;
                        end
                    endcase
                end
            endcase
        end
        else if (CS)
            state <= IDLE;
    end
end

endmodule