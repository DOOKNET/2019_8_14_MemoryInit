module MemoryInit(
	input	clk,
	input	rst_n,
	input	initEn,

	output	initValid,
	output	[31:0]	initAddr,
	output	initDone,
	output	initDonePuls
);

//===============//
reg		initEn_r0;
reg		initEn_r1;
reg		initEn_r2;
reg		initEn_r3;
wire	initEn_pose;
wire	initEn_nege;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		initEn_r0 <= 0;
		initEn_r1 <= 0;
		initEn_r2 <= 0;
		initEn_r3 <= 0;	
	end
	else	begin
		initEn_r0 <= initEn;
		initEn_r1 <= initEn_r0;
		initEn_r2 <= initEn_r1;
		initEn_r3 <= initEn_r2;
	end
end

assign	initEn_pose = initEn_r2 & ~initEn_r3;
assign	initEn_nege = ~initEn_r2 & initEn_r3;
//===================//


reg	[2:0]	state;
reg	[31:0]	addr;
reg		valid;
reg		done;
reg		done_plus;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		state <= 3'b0;
		addr <= 0;
	end
	else	begin
		case (state)
		3'd0:
			if(initEn_pose)	begin
				addr <= 32'd0;
				valid <= 1;
				done <= 0;
				done_plus <= 0;
				state <= state + 1;
			end
			else	begin
				addr <= 32'd0;
				valid <= 0;
				done <= 0;
				done_plus <= 0;
			end
		3'd1:
			if(addr == 32'd31)	begin
				addr <= addr + 1;
				valid <= 1;
				done <= 0;
				done_plus <= 1;
				state <= state + 1;
			end
			else	begin
				addr <= addr + 1;
				valid <= 1;
				done <= 0;
				done_plus <= 0;
			end
		3'd2:
			if(addr == 32'd32)	begin
				addr <= 32'd0;
				valid <= 0;
				done <= 1;
				done_plus <= 0;
				state <= state + 1;
			end
			else	begin
				addr <= addr + 1;
				valid <= 1;
				done <= 0;
				done_plus <= 1;
			end
		3'd3:
			if(initEn_nege)	begin
				state <= 0;
			end
			else	begin
				addr <= 32'd0;
				valid <= 0;
				done <= 1;
				done_plus <= 0;
			end

		default:	begin
			state <= 0;
		end
		endcase
	end
	
end

assign initValid = valid;
assign initAddr = addr;
assign initDone = done;
assign initDonePuls = done_plus;


endmodule
