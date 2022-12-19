`include "generate.sv"
`include "drive.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class master_environment;

master_input_generator gen;
master_input_driver    drive;
master_monitor         monit;
master_scoreboard      score;

mailbox mgen;
mailbox mscore;

	virtual m_int v_m_int;
	
	function new(virtual m_int v_m_int);
		this.v_m_int = v_m_int;
		mgen = new();
		mscore = new();
		gen = new(mgen);
		drive = new(v_m_int, mgen);
		monit = new(v_m_int, mscore);
		score = new(mscore);
		
	endfunction

	task test();
		fork
			gen.main();
			drive.main();
			monit.main();
			score.main();
		join
	endtask

	task run;
		test();
		$finish;
	endtask

endclass