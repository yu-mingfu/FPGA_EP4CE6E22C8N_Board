`define UD #1
module SDRAM_WR_DATA(
						CLK_100M,
						RST_N,
						SDRAM_DATA,
						SDRAM_DATA_IN,
						SDRAM_DATA_OUT,
						WORK_CS,
						TIME_CNT
					);
					
input CLK_100M,RST_N;
inout [15:0] SDRAM_DATA;
input [15:0] SDRAM_DATA_IN;
output [15:0] SDRAM_DATA_OUT;
input [3:0] WORK_CS;
input [3:0] TIME_CNT;

wire SDLINK ;//sdram读写方向位控制
assign SDLINK=(WORK_CS==4'h7)?1'b1:1'b0;
assign SDRAM_DATA=SDLINK?SDRAM_DATA_IN:16'hzzzz;


//////////////SDRAM 读控制//////////////////////
wire [15:0] SDRAM_DATA_OUT;
reg [15:0] SDR_DOUT;

always@(posedge CLK_100M or negedge RST_N)
begin
	if(!RST_N)
		SDR_DOUT<=`UD 16'd0;
	else if((WORK_CS==4'h5)||((WORK_CS==4'h6)&&(TIME_CNT==4'd0)))
		SDR_DOUT<=`UD SDRAM_DATA;
end
assign SDRAM_DATA_OUT=SDR_DOUT;
//assign SDRAM_DATA_OUT=((WORK_CS==4'h5)||((WORK_CS==4'h6)&&(TIME_CNT==4'd0)))?SDR_DOUT:16'h0;
///////////////////////////////////////////////////////////////////
endmodule
