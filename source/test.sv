`include "master_env.sv"
program test(m_int i_m_int); // not virtual handler!
master_environment envir;

	initial begin
		envir = new(i_m_int);
		envir.run();
	end	

endprogram
