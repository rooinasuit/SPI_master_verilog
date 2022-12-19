
class master_scoreboard;
`include "master_input_data.sv"
master_input_data master_input; // handler
mailbox score_data;

	function new (mailbox score_data);
		this.score_data = score_data;
	endfunction

	task main;
		repeat(10) begin
			score_data.get(master_input);
			
			master_input.print("scoreboard");
		end
	endtask

endclass
