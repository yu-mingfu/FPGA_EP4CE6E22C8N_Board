module PLL(
				SYSCLK,
				RST_N,
				SYS_RST_N,
				CLK_50M,
				CLK_100M,
				SDRAM_CLK
			
		  );

input SYSCLK;		//FPAG输入时钟信号50MHz
input RST_N;	//FPGA输入复位信号

output SYS_RST_N;	//系统复位信号，低有效

output CLK_50M;		//PLL输出50MHz时钟
output CLK_100M;	//PLL输出100MHz时钟
output SDRAM_CLK;	//用于外部SDAM的时钟100M

wire LOCKED;		//PLL输出有效标志位，高表示PLL输出有效

//----------------------------------------------
//PLL复位信号产生，高有效
//异步复位，同步释放
wire PLL_RST;	//PLL复位信号，高有效

reg RST_REG,RST_REG_N;

always @(posedge SYSCLK or negedge RST_N)
	if(!RST_N) RST_REG <= 1'b1;
	else RST_REG <= 1'b0;

always @(posedge SYSCLK or negedge RST_N)
	if(!RST_N) RST_REG_N <= 1'b1;
	else RST_REG_N <= RST_REG;

assign PLL_RST = RST_REG_N;

//----------------------------------------------
//系统复位信号产生，低有效
//异步复位，同步释放
wire SYS_RST_N;	//系统复位信号，低有效
wire SYS_RST_N_R0;
reg SYS_RST_N_R1,SYS_RST_N_R2;

assign SYS_RST_N_R0 = RST_N & LOCKED;	//系统复位直到PLL有效输出

always @(posedge CLK_100M or negedge SYS_RST_N_R0)
	if(!SYS_RST_N_R0) SYS_RST_N_R1 <= 1'b0;
	else SYS_RST_N_R1 <= 1'b1;

always @(posedge CLK_100M or negedge SYS_RST_N_R0)
	if(!SYS_RST_N_R0) SYS_RST_N_R2 <= 1'b0;
	else SYS_RST_N_R2 <= SYS_RST_N_R1;

assign SYS_RST_N = SYS_RST_N_R2;

//----------------------------------------------
//例化PLL产生模块
PLL_CTL 		I_PLL_CTL(
					.areset(PLL_RST),	//PLL复位信号,高电平复位
					.inclk0(SYSCLK),		//PLL输入时钟，50MHz
					.c0(CLK_50M),		//PLL输出50MHz时钟			
					.c1(CLK_100M),		//PLL输出100MHz时钟
					.c2(SDRAM_CLK),		//用于外部SDAM的时钟100M
					.locked(LOCKED)		//PLL输出有效标志位，高表示PLL输出有效
				);
endmodule
