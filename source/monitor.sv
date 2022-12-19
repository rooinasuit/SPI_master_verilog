
class master_monitor;
`include "master_input_data.sv"
master_input_data master_input; // handler
virtual m_int v_m_int; // virtual m_int handler
mailbox score_data;
	
	function new (virtual m_int v_m_int, mailbox score_data);
		this.v_m_int = v_m_int;
		this.score_data = score_data;
	endfunction

	task main;
		repeat(10) begin
			master_input = new();

			// SAMPLING SECTION
			master_input.MOSI_data 		  = v_m_int.MOSI_data;
			master_input.MISO 			  = v_m_int.MISO;
			master_input.MISO_data 		  = v_m_int.MISO_data;
			master_input.master_stash_ptr = v_m_int.master_stash_ptr;
			master_input.MOSI 			  = v_m_int.MOSI;

			score_data.put(master_input);
			master_input.print("monitor data");
		end
	endtask

endclass