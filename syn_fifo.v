module syn_fifo(clk_i,rst_i,wr_en_i,rd_en_i,wdata_i,rdata_o,full_o,empty_o,underflow_o,overflow_o);
	input clk_i,rst_i,wr_en_i,rd_en_i;
	input [`DATA_WIDTH-1:0] wdata_i;
	output reg [`DATA_WIDTH-1:0] rdata_o;
	output reg full_o,empty_o,underflow_o,overflow_o;
	integer i;

	reg [`PNTR_WIDTH-1:0] wr_pntr;
	reg [`PNTR_WIDTH-1:0] rd_pntr;
	
	reg wr_tggle;
	reg rd_tggle;

	reg [`DATA_WIDTH-1:0] fifo [`DEPTH-1:0];

	always@(posedge clk_i or posedge rst_i) begin
		if(rst_i == 1) begin
			rdata_o <= 0;
			full_o <= 0;
			empty_o <= 1;
			underflow_o <= 0;
			overflow_o <= 0;
			rd_pntr <= 0;
			wr_pntr <= 0;
			wr_tggle <= 0;
			rd_tggle <= 0;
			for(i=0;i<`DEPTH;i=i+1) begin
				fifo[i] = 0;
			end
		end //rst
		else begin
				if(wr_en_i == 1) begin
					if(full_o == 1) begin
						overflow_o <= 1;
					end
					else begin
						overflow_o <= 0;
						fifo[wr_pntr] = wdata_i;
						if(wr_pntr == `DEPTH-1) begin
							wr_pntr <= 0;
							wr_tggle <= ~wr_tggle;
						end
						else begin
							wr_pntr = wr_pntr + 1;
						end
					end

				end
					
				if(rd_en_i == 1) begin
					if(empty_o == 1) begin
						underflow_o <= 1;
					end
					else begin
						underflow_o <= 0;
						rdata_o <= fifo[rd_pntr];
						if(rd_pntr == `DEPTH-1) begin
							rd_pntr <= 0;
							rd_tggle <= ~rd_tggle;
						end
						else begin
							rd_pntr <= rd_pntr + 1;
						end
					end
				end
		end
	end //always



	always@(*) begin
		if(wr_pntr == rd_pntr && wr_tggle != rd_tggle) 
			full_o <= 1;
		else
			full_o <= 0;

		if(wr_pntr == rd_pntr && wr_tggle == rd_tggle) 
			empty_o <= 1;
		else 	
			empty_o <= 0;
	end

endmodule
