'timescale 1ns/1ps

module clock_domains (
    input CLK,
    input NRST,

    output CTRL_CLK,
    output SCLK_PULSE
);

reg [4:0] ctrl_cnt;
reg [9:0] pulse_cnt;

always @ (posedge CLK) begin
    if (!NRST) begin
        ctrl_cnt <= 5'd0;
        pulse_cnt <= 10'd0;
    end
    else if (ctrl_cnt > 26) begin
        ctrl_cnt <= 5'd0;
        pulse_cnt <= pulse_cnt + 1'b1;
    end
    else if (pulse_cnt > 999) begin
        pulse_cnt <= 10'd0;
    end
    else
        ctrl_cnt <= ctrl_cnt + 1'b1;
end

assign CTRL_CLK = (ctrl_cnt == 26) ? 1'b1 : 1'b0;
assign SCLK_PULSE = (pulse_cnt == 999) ? 1'b1 : 1'b0;

endmodule