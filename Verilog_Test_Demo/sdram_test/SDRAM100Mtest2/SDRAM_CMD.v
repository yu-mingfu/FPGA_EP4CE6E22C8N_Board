`define UD #1
`define		CMD_INIT 	 5'b01111	//上电初始化命令端口		
`define		CMD_NOP		 5'b10111	// NOP COMMAND
`define		CMD_ACTIVE	 5'b10011	// ACTIVE COMMAND
`define		CMD_READ	 5'b10101	// READ COMMADN
`define		CMD_WRITE	 5'b10100	// WRITE COMMAND
`define		CMD_B_STOP	 5'b10110	// BURST	STOP
`define		CMD_PRGE	 5'b10010	// PRECHARGE
`define		CMD_A_REF	 5'b10001	// AOTO REFRESH
`define		CMD_LMR		 5'b10000	// LODE MODE REGISTER

module SDRAM_CMD(
					CLK_100M,
					RST_N,
					SDRAM_CKE,
					SDRAM_CS,
					SDRAM_RAS,
					SDRAM_CAS,
					SDRAM_WE,
					SDRAM_BA,
					SDRAM_ADDR,
					SDRAM_ADDR_IN,
					INIT_NS,
					WORK_NS,
					TIME_CNT_N
				);
				
input CLK_100M;
input RST_N;
input [21:0] SDRAM_ADDR_IN;
input [3:0] INIT_NS;
input [3:0] WORK_NS;
input [3:0] TIME_CNT_N;


output SDRAM_CKE,SDRAM_CS,SDRAM_RAS,SDRAM_CAS,SDRAM_WE;
output reg[1:0] SDRAM_BA;
output reg[11:0] SDRAM_ADDR;
reg [4:0] SDRAM_CMD;
assign {SDRAM_CKE,SDRAM_CS,SDRAM_RAS,SDRAM_CAS,SDRAM_WE}=SDRAM_CMD;


reg [4:0] SDRAM_CMD_N;
reg [1:0] SDRAM_BA_N;
reg [11:0] SDRAM_ADDR_N;

always@(posedge CLK_100M or negedge RST_N)
begin
	if(!RST_N)
		SDRAM_BA<=`UD 2'b11;
	else
		SDRAM_BA<=`UD SDRAM_BA_N;
end
always@(posedge CLK_100M or negedge RST_N)
begin
	if(!RST_N)
		SDRAM_ADDR<=`UD 12'hFFF;
	else
		SDRAM_ADDR<=`UD SDRAM_ADDR_N;
end
always@(posedge CLK_100M or negedge RST_N)
begin
	if(!RST_N)
		SDRAM_CMD<=`UD `CMD_INIT;
	else
		SDRAM_CMD<=`UD SDRAM_CMD_N;
end 
always@(*)
begin
	case(INIT_NS)
		    4'h0:
				begin
					SDRAM_CMD_N=`CMD_NOP;
					SDRAM_BA_N=2'h3;
					SDRAM_ADDR_N=12'hFFF;
				end
			4'h1 :
				if(TIME_CNT_N==4'h0)
					begin
						SDRAM_CMD_N=`CMD_PRGE;
						SDRAM_BA_N=2'b11;
						SDRAM_ADDR_N=12'hFFF;
					end
				else
				    begin
						SDRAM_CMD_N=`CMD_NOP;
						SDRAM_BA_N=2'h3;
						SDRAM_ADDR_N=12'hFFF;
					end
	4'h2,4'h3,4'h4,4'h5,4'h6,4'h7,4'h8,4'h9:
				if(TIME_CNT_N==4'h0)
					begin
						SDRAM_CMD_N=`CMD_A_REF;
						SDRAM_BA_N=2'h3;
						SDRAM_ADDR_N=12'hFFF;
					end
				else
				    begin
						SDRAM_CMD_N=`CMD_NOP;
						SDRAM_BA_N=2'h3;
						SDRAM_ADDR_N=12'hFFF;
					end
			4'ha :
				if(TIME_CNT_N==4'h0)
					begin
						SDRAM_CMD_N=`CMD_LMR;
						SDRAM_BA_N=2'b00;
						SDRAM_ADDR_N={
									2'b00,			//操作模式设置
									1'b0,			//操作模式设置(这里设置为A9=0,即突发读/突发写)
									2'b00,			//操作模式设置({A8,A7}=00),当前操作为模式寄存器设置
									3'b011,			// CAS潜伏期设置(这里设置为3，{A6,A5,A4}=011)
									1'b0,			//突发传输方式(这里设置为顺序，A3=b0)
									3'b011			//突发长度(这里设置为8，{A2,A1,A0}=011)
   							       };
					end
				else
				    begin
						SDRAM_CMD_N=`CMD_NOP;
						SDRAM_BA_N=2'h3;
						SDRAM_ADDR_N=12'hFFF;
					end
			4'hb:
				case(WORK_NS)
					4'h0,4'h2,4'h4,4'h5,4'h6,4'h8:
						begin
							SDRAM_CMD_N=`CMD_NOP;
							SDRAM_BA_N=2'h3;
							SDRAM_ADDR_N=12'hFFF;
						end
					4'h1:
						begin
							SDRAM_CMD_N=`CMD_ACTIVE;
							SDRAM_BA_N=SDRAM_ADDR_IN[21:20];
							SDRAM_ADDR_N=SDRAM_ADDR_IN[19:8];
						end
					4'h3:
						begin
							SDRAM_CMD_N=`CMD_READ;
							SDRAM_BA_N=SDRAM_ADDR_IN[21:20];
							SDRAM_ADDR_N={4'h4,SDRAM_ADDR_IN[7:0]};
						end
					4'h7:
						if(TIME_CNT_N==4'h0)
							begin
								SDRAM_CMD_N=`CMD_WRITE;
								SDRAM_BA_N=SDRAM_ADDR_IN[21:20];
								SDRAM_ADDR_N={4'h4,SDRAM_ADDR_IN[7:0]};
							end
						else
							begin
								SDRAM_CMD_N=`CMD_NOP;
								SDRAM_BA_N=2'h3;
								SDRAM_ADDR_N=12'hFFF;
							end
					4'h9:
					    if(TIME_CNT_N==4'h0)
							begin
								SDRAM_CMD_N=`CMD_A_REF;
								SDRAM_BA_N=2'h3;
								SDRAM_ADDR_N=12'hFFF;
							end
						else
							begin
								SDRAM_CMD_N=`CMD_NOP;
								SDRAM_BA_N=2'h3;
								SDRAM_ADDR_N=12'hFFF;
							end
					default:
						begin
							SDRAM_CMD_N=`CMD_NOP;
							SDRAM_BA_N=2'h3;
							SDRAM_ADDR_N=12'hFFF;
						end	
				endcase
			default:
				begin
					SDRAM_CMD_N=`CMD_NOP;
					SDRAM_BA_N=2'h3;
					SDRAM_ADDR_N=12'hFFF;
				end	
		endcase
end
endmodule
