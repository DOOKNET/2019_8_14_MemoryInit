`timescale 1ns/1ps

module tb_momoryinit( );

reg 	sclk;
reg		rst_n;
reg		initEn;
wire 	initValid;
wire	[31:0]	initAddr;
wire	initDone;
wire	initDonePuls;

initial	sclk = 1;
always #10 sclk = !sclk;

initial	begin
	rst_n = 0;
	#100
	rst_n = 1;
	initEn = 0;
	#100 
	initEn = 1;
end


MemoryInit			MemoryInit_inst(
	.clk			(sclk),
	.rst_n			(rst_n),
	.initEn			(initEn),

	.initValid		(initValid),
	.initAddr		(initAddr),
	.initDone		(initDone),
	.initDonePuls	(initDonePuls)
);




endmodule
