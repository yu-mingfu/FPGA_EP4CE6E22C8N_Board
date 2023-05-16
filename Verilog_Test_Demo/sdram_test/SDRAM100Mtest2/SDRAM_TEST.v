`define UD #1
module SDRAM_TEST(
					SYSCLK,
					RST_N,
					
					SDRAM_CLK,
					SDRAM_CS,
					SDRAM_CAS,
					SDRAM_RAS,
					SDRAM_CKE,
					SDRAM_WE,
					SDRAM_ADDR,
					SDRAM_DATA,
					SDRAM_BA,
					UART_TX,
               	    SDRAM_LDQM,
 	                SDRAM_UDQM
					//EMPTY
				 );
input SYSCLK;
input RST_N;
output SDRAM_CLK;
output SDRAM_CKE;
output SDRAM_CAS;
output SDRAM_RAS;
output [1:0]  SDRAM_BA;
output [11:0] SDRAM_ADDR;
inout [15:0] SDRAM_DATA;
output SDRAM_WE;
output SDRAM_CS;
output SDRAM_LDQM;
output SDRAM_UDQM;

wire SDRAM_WR_REQ;
wire SDRAM_RD_REQ;
wire SDRAM_WR_ACK;
wire SDRAM_RD_ACK;
wire [21:0] SDRAM_ADDR_IN;
wire [15:0] SDRAM_DATA_IN;

wire [15:0] SDRAM_DATA_OUT;
wire [15:0] WR_FIFO_DATA;
wire WR_FIFO_REQ;
wire [15:0] RD_FIFO_DATA;
wire RD_FIFO_REQ;

wire CLK_50M;
wire CLK_100M;
wire SYS_RST_N;

wire [3:0] INIT_CS;
wire [3:0] WORK_CS;

output UART_TX;
//output EMPTY;

wire TX_EN;		//串口发送数据启动标志位，高有效
wire WR_DONE;
wire RD_EMPTY;
assign EMPTY=~RD_EMPTY;

//例化系统复位信号和PLL控制模块
PLL		I_PLL(
					.SYSCLK(SYSCLK),
					.RST_N(RST_N),
					.SYS_RST_N(SYS_RST_N),
					.CLK_50M(CLK_50M),
					.CLK_100M(CLK_100M),
					.SDRAM_CLK(SDRAM_CLK)
					);
					
 SDFIFO_CTL  I_SDFIFO_CTL(
							.CLK_50M(CLK_50M),
							.CLK_100M(CLK_100M),
							.WR_FIFO_DATA(WR_FIFO_DATA),
							.WR_FIFO_REQ(WR_FIFO_REQ),
							.RST_N(SYS_RST_N),
							.SDRAM_RD_REQ(SDRAM_RD_REQ),
							.SDRAM_WR_REQ(SDRAM_WR_REQ),
							.SDRAM_RD_ACK(SDRAM_RD_ACK),
							.SDRAM_WR_ACK(SDRAM_WR_ACK),
							
							.TX_EN(TX_EN),
							
							.WR_DONE(WR_DONE),
							
							.RD_FIFO_REQ(RD_FIFO_REQ),
							.RD_FIFO_DATA(RD_FIFO_DATA),
							
							.SDRAM_DATA_OUT(SDRAM_DATA_OUT),
							.SDRAM_DATA_IN(SDRAM_DATA_IN),
							.RD_EMPTY(RD_EMPTY)
				       );

SDRAM_TOP   I_SDRAM_TOP(
							.CLK_100M(CLK_100M),
							.RST_N(SYS_RST_N),
							.SDRAM_WR_REQ(SDRAM_WR_REQ),
							.SDRAM_RD_REQ(SDRAM_RD_REQ),
							.SDRAM_WR_ACK(SDRAM_WR_ACK),
							.SDRAM_RD_ACK(SDRAM_RD_ACK),
							.SDRAM_ADDR_IN(SDRAM_ADDR_IN),
							.SDRAM_DATA_IN(SDRAM_DATA_IN),
							.SDRAM_DATA_OUT(SDRAM_DATA_OUT),
							.SDRAM_CKE(SDRAM_CKE),
							.SDRAM_CS(SDRAM_CS),
							.SDRAM_RAS(SDRAM_RAS),
							.SDRAM_CAS(SDRAM_CAS),
							.SDRAM_WE(SDRAM_WE),
							.SDRAM_BA(SDRAM_BA),
							.SDRAM_ADDR(SDRAM_ADDR),
							.SDRAM_DATA(SDRAM_DATA),
							.SDRAM_UDQM(SDRAM_UDQM),
							.SDRAM_LDQM(SDRAM_LDQM)
					   );
//例化模拟写入数据到sdram模块

DATA_GEN			I_DATA_GEN(
						.SYSCLK(CLK_50M),
						.RST_N(SYS_RST_N),
						.WR_FIFO_DATA(WR_FIFO_DATA),
						.WR_FIFO_REQ(WR_FIFO_REQ),
						.WR_ADDR(SDRAM_ADDR_IN),
						.WR_DONE(WR_DONE),
						.SDRAM_RD_ACK(SDRAM_RD_ACK)
					);

uart_ctrl		uut_uartctrl(
					.clk(CLK_50M),
					.rst_n(SYS_RST_N),
					.tx_data(RD_FIFO_DATA[7:0]),
					.tx_start(TX_EN),		///////////
					.fifo232_rdreq(RD_FIFO_REQ),
					.rs232_tx(UART_TX)
					);
					
endmodule


