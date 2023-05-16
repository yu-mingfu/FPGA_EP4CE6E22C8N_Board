module SDRAM_TOP(
					CLK_100M,
					RST_N,
					SDRAM_WR_REQ,
					SDRAM_RD_REQ,
					SDRAM_WR_ACK,
					SDRAM_RD_ACK,
					SDRAM_ADDR_IN,
					SDRAM_DATA_IN,
					SDRAM_DATA_OUT,
					SDRAM_CKE,
					SDRAM_CS,
					SDRAM_RAS,
					SDRAM_CAS,
					SDRAM_WE,
					SDRAM_BA,
					SDRAM_ADDR,
					SDRAM_DATA,
					SDRAM_UDQM,
					SDRAM_LDQM

				);
				
input CLK_100M,RST_N;
input SDRAM_WR_REQ,SDRAM_RD_REQ;
output SDRAM_WR_ACK,SDRAM_RD_ACK;

input [21:0] SDRAM_ADDR_IN;
input [15:0] SDRAM_DATA_IN;
output [15:0] SDRAM_DATA_OUT;

output SDRAM_CKE;			// SDRAM时钟有效信号
output SDRAM_CS;			// SDRAM片选信号
output SDRAM_RAS;			// SDRAM行地址选通脉冲
output SDRAM_CAS;			// SDRAM列地址选通脉冲
output SDRAM_WE;			// SDRAM写允许位
output[1:0] SDRAM_BA;		// SDRAM的L-Bank地址线
output[11:0] SDRAM_ADDR;	// SDRAM地址总线
inout[15:0] SDRAM_DATA;		// SDRAM数据总线
output SDRAM_UDQM;		// SDRAM高字节屏蔽
output SDRAM_LDQM;		// SDRAM低字节屏蔽
assign SDRAM_UDQM=0;
assign SDRAM_LDQM=0;

wire [3:0] INIT_CS,WORK_CS,TIME_CNT,TIME_CNT_N,INIT_NS,WORK_NS;

SDRAM_CTRL  I_SDRAM_CTRL(
						.CLK_100M(CLK_100M),
						.RST_N(RST_N),
						//.SDRAM_UDQM(SDRAM_UDQM),
						//.SDRAM_LDQM(SDRAM_LDQM),
						.SDRAM_WR_REQ(SDRAM_WR_REQ),
						.SDRAM_RD_REQ(SDRAM_RD_REQ),
						.SDRAM_WR_ACK(SDRAM_WR_ACK),
						.SDRAM_RD_ACK(SDRAM_RD_ACK),
						.INIT_CS(INIT_CS),
						.WORK_CS(WORK_CS),
						.TIME_CNT(TIME_CNT),
						.TIME_CNT_N(TIME_CNT_N),
						.INIT_NS(INIT_NS),
						.WORK_NS(WORK_NS)
						);
	
SDRAM_CMD   I_SDRAM_CMD(
							.CLK_100M(CLK_100M),
							.RST_N(RST_N),
							.SDRAM_CKE(SDRAM_CKE),
							.SDRAM_CS(SDRAM_CS),
							.SDRAM_RAS(SDRAM_RAS),
							.SDRAM_CAS(SDRAM_CAS),
							.SDRAM_WE(SDRAM_WE),
							.SDRAM_BA(SDRAM_BA),
							.SDRAM_ADDR(SDRAM_ADDR),
							.SDRAM_ADDR_IN(SDRAM_ADDR_IN),
							.INIT_NS(INIT_NS),
							.WORK_NS(WORK_NS),
							.TIME_CNT_N(TIME_CNT_N)						
					   );
					   
SDRAM_WR_DATA  I_SDRAM_WR_DATA(
								.CLK_100M(CLK_100M),
								.RST_N(RST_N),
								.SDRAM_DATA(SDRAM_DATA),
								.SDRAM_DATA_IN(SDRAM_DATA_IN),
								.SDRAM_DATA_OUT(SDRAM_DATA_OUT),
								.WORK_CS(WORK_CS),
								.TIME_CNT(TIME_CNT)								
							  );
							  
endmodule

