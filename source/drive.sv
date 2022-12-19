
class master_input_driver;
`include "master_input_data.sv"
master_input_data master_input; // handler
virtual m_int v_m_int; // virtual m_int handler
mailbox rand_data;

	function new (virtual m_int v_m_int, mailbox rand_data);
		this.v_m_int = v_m_int;
		this.rand_data = rand_data;
	endfunction

	task main;
		repeat(10) begin
			rand_data.get(master_input); // rand data from mailbox
			
			// INPUTS
			v_m_int.MOSI_data 			 <= master_input.MOSI_data;
			v_m_int.MISO 				 <= master_input.MISO;
			
			// OUTPUTS
			master_input.MISO_data 		  = v_m_int.MISO_data;
			master_input.master_stash_ptr = v_m_int.master_stash_ptr;
			master_input.MOSI 			  = v_m_int.MOSI;
			
			master_input.print("driven data");
		end
	endtask

endclass