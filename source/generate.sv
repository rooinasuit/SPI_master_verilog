`include "master_input_data.sv"
class master_input_generator;

master_input_data master_input; // handler
mailbox rand_data; // mailbox with data for other parts

	function new (mailbox rand_data);
		this.rand_data = rand_data;
	endfunction

	task main;
	
		repeat (10) begin
			master_input = new; // new master_input_data class object
			master_input.randomize(); // randomize new data for master_input rand inputs
			master_input.print("generated data"); // display a string for master_input print function
			rand_data.put(master_input); // put rand data in a mailbox for master_input
		end
	endtask

endclass
