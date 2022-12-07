'timescale 1ns/1ps

module tb;

reg x;

initial begin
    x <= 0;

    #1 $display ("T=%0t At time #1", $realtime);
    x <= 1;

    #15 $display ("T=%0t At time #15", $realtime); 
    x <= 0;

    #128 $display ("T=%0t At time #128", $realtime);
    x <= 1;

    #12 $display ("T=%0t At time #12", $realtime); 
    x <= 0;

    #100 $display ("T = %0t End of sim", $realtime);
end

endmodule