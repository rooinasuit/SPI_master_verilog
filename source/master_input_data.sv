
class master_input_data;

rand bit [7:0] MOSI_data;
rand bit MISO;

bit [7:0] MISO_data;
bit [7:0] master_stash_ptr;
bit MOSI;

	function void print (string tag="");
		$display("T=%0t  %s  MOSI_data=0x%0h  MISO=0x%0h  MISO_data=0x%0h master_stash_ptr=0x%0h MOSI=0x%0h",
			  	$time, tag, MOSI_data, MISO, MISO_data, master_stash_ptr, MOSI);
	endfunction

endclass
