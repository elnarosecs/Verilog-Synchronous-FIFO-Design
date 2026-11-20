`define DEPTH 13
`define DATA_WIDTH 32
`define PNTR_WIDTH $clog2(`DEPTH)
`include "syn_fifo.v"

module top;
	reg clk_i,rst_i,wr_en_i,rd_en_i;
	reg [`DATA_WIDTH-1:0] wdata_i;
	 wire [`DATA_WIDTH-1:0] rdata_o;
	 wire full_o,empty_o,underflow_o,overflow_o;

syn_fifo dut(
				.clk_i(clk_i),
				.rst_i(rst_i),
				.wr_en_i(wr_en_i),
				.rd_en_i(rd_en_i),
				.wdata_i(wdata_i),
				.rdata_o(rdata_o),
				.full_o(full_o),
				.empty_o(empty_o),
				.underflow_o(underflow_o),
				.overflow_o(overflow_o));


	initial begin
		clk_i = 0;
		forever #2 clk_i = ~clk_i;
	end

	task reset();
		begin
		wr_en_i = 0;
		rd_en_i = 0;
		wdata_i = 0;
		@(posedge clk_i);
		end
	endtask


	task write(input integer N);
	begin
		repeat(N) begin
			@(posedge clk_i);
			wr_en_i = 1;
			wdata_i = $random();
			@(posedge clk_i);
			wr_en_i = 0;
			wdata_i = 0;
		end
	end
	endtask

	task read(input integer N);
	begin
		repeat(N) begin
		@(posedge clk_i);
		rd_en_i = 1;
		@(posedge clk_i);
		rd_en_i = 0;
		end
	end
	endtask




	initial begin
		//x -> 1 (posedge)
		//0 -> 1 (posedge)
		//z -> 1 (posedge)
		rst_i = 1'b1;
		reset();
		repeat(2) @(posedge clk_i);
		rst_i = 0;

		//rst PASSED
			
		//full Passed
		write(`DEPTH);


		//empty Passed
		read(`DEPTH);


		//overflow
			write(`DEPTH+1);

		//underflow
			read(`DEPTH+1);



		//conncurrent write/read Passed
			fork
				write(10);
				read(10);
			join

		#100 $finish(); //objections, drain time		
	end






endmodule
