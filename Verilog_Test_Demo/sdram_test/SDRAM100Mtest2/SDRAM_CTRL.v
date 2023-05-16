`define UD #1
module SDRAM_CTRL(
					CLK_100M,
					RST_N,
					//SDRAM_UDQM,
					//SDRAM_LDQM,
					SDRAM_WR_REQ,
					SDRAM_RD_REQ,
					SDRAM_WR_ACK,
					SDRAM_RD_ACK,
					INIT_CS,
					WORK_CS,
					INIT_NS,
					WORK_NS,
					TIME_CNT,
					TIME_CNT_N
				 );
				 
input CLK_100M,RST_N;
//output SDRAM_UDQM,SDRAM_LDQM;

input SDRAM_WR_REQ,SDRAM_RD_REQ;
output SDRAM_WR_ACK,SDRAM_RD_ACK;
output reg[3:0] INIT_CS,WORK_CS;
output [3:0] TIME_CNT_N;
output [3:0] TIME_CNT;
wire SDRAM_INIT_DONE;//SDRAM初始化完成标志

reg [3:0] TIME_CNT;
reg [3:0] TIME_CNT_N;
output reg [3:0] INIT_NS;////////初始化的当前状态和下一状态
output reg [3:0] WORK_NS;////工作中的当前状态和下一状态 


///////////初始化状态////////////////////////
parameter SDRAM_IDLE	=4'h0;////SDRAM 空闲
//parameter SDRAM_200US   =5'h1;///SDRAM 200us稳定
parameter SDRAM_PRE     =4'h1;//SDRAM 所有BANK预充电
parameter SDRAM_AR1     =4'h2;//SDRAM第1次预刷新
parameter SDRAM_AR2     =4'h3;//SDRAM第2次预刷新
parameter SDRAM_AR3     =4'h4;//SDRAM第3次预刷新
parameter SDRAM_AR4     =4'h5;//SDRAM第4次预刷新
parameter SDRAM_AR5     =4'h6;//SDRAM第5次预刷新
parameter SDRAM_AR6     =4'h7;//SDRAM第6次预刷新
parameter SDRAM_AR7     =4'h8;//SDRAM第7次预刷新
parameter SDRAM_AR8     =4'h9;//SDRAM第8次预刷新
parameter SDRAM_MSR_SET =4'ha;//SDRAM 模式寄存器设置
parameter SDRAM_INIT_FINISH=4'hb;//SDRAM初始化完成 
//////////SDRAM参数/////////////////////////////
parameter SDRAM_TRP=3'h4;//所有BANK预充电时间，18ns（min）  
parameter SDRAM_TRC=4'h6;//刷新周期， 60ns（min）
parameter SDRAM_MODE=4'h6;//写模式寄存器的时间 
parameter SDRAM_TRCD=2'h1;//TRCD time 
parameter SDRAM_TCL=2'b01;//TCL time =3 CLK 
parameter SDRAM_RW_CLK=4'h7;//突发读写8个字节 
parameter SDRAM_TRDL=4'h3; 
parameter SDRAM_RWAIT=4'd6;
 

///////////工作状态转换/////////////////////////////////
parameter WORK_IDLE          =4'h0;//空闲
parameter WORK_ROW_ACTIVE	 =4'h1;//行有效
parameter WORK_TRCD			 =4'h2;//行有效等待
parameter WORK_READ_CMD 	 =4'h3;//发送读数据命令
parameter WORK_CL			 =4'h4;//CSA潜伏期
parameter WORK_READ			 =4'h5;//读数据状态
parameter WORK_RWAIT		 =4'h6;//读完成后的预充电状态
parameter WORK_WRITE		 =4'h7;//写状态
parameter WORK_WAIT			 =4'h8;//写完成后的预充电状态
parameter WORK_AR            =4'h9;//自动刷新状态64ms
////////////////////上电200us稳定期///////////////////////////////////
reg [14:0] CNT_200;
wire DELAY_200_DONE;
always@(posedge CLK_100M or negedge RST_N)
begin
	if(!RST_N)
		CNT_200<=`UD 15'h0;
	else if(CNT_200<15'd20_000)
		CNT_200<=`UD CNT_200+15'd1;
	else
		CNT_200<=`UD CNT_200;
end
assign DELAY_200_DONE=(CNT_200==15'd20_000);////200us延时后输出一个时钟的高脉冲标志

////////////初始化状态转移////////////////////
always@(posedge CLK_100M or negedge RST_N)
begin
	if(!RST_N)
		INIT_CS<=`UD SDRAM_IDLE;
	else
		INIT_CS<=`UD INIT_NS;
end 
always@(*)
begin
	case(INIT_CS)
		SDRAM_IDLE:
			if(DELAY_200_DONE)
				INIT_NS=SDRAM_PRE;
			else
				INIT_NS=INIT_CS;
		SDRAM_PRE:
			if(TIME_CNT==SDRAM_TRP)
				INIT_NS=SDRAM_AR1;
			else
				INIT_NS=INIT_CS;
		SDRAM_AR1:
			if(TIME_CNT==SDRAM_TRC)
				INIT_NS=SDRAM_AR2;
			else
				INIT_NS=INIT_CS;
		SDRAM_AR2:
			if(TIME_CNT==SDRAM_TRC)
				INIT_NS=SDRAM_AR3;
			else
				INIT_NS=INIT_CS;		
		SDRAM_AR3:
			if(TIME_CNT==SDRAM_TRC)
				INIT_NS=SDRAM_AR4;
			else
				INIT_NS=INIT_CS;				
		SDRAM_AR4:
			if(TIME_CNT==SDRAM_TRC)
				INIT_NS=SDRAM_AR5;
			else
				INIT_NS=INIT_CS;			
		SDRAM_AR5:
			if(TIME_CNT==SDRAM_TRC)
				INIT_NS=SDRAM_AR6;
			else
				INIT_NS=INIT_CS;
		SDRAM_AR6:
			if(TIME_CNT==SDRAM_TRC)
				INIT_NS=SDRAM_AR7;
			else
				INIT_NS=INIT_CS;	
		SDRAM_AR7:
			if(TIME_CNT==SDRAM_TRC)
				INIT_NS=SDRAM_AR8;
			else
				INIT_NS=INIT_CS;
		SDRAM_AR8:
			if(TIME_CNT==SDRAM_TRC)
				INIT_NS=SDRAM_MSR_SET;
			else
				INIT_NS=INIT_CS;
		SDRAM_MSR_SET:
			if(TIME_CNT==SDRAM_MODE)
				INIT_NS=SDRAM_INIT_FINISH;
			else
				INIT_NS=INIT_CS;
		SDRAM_INIT_FINISH:
			INIT_NS=INIT_CS;	
		default:
			INIT_NS=SDRAM_IDLE;
	endcase
end 
assign SDRAM_INIT_DONE=(INIT_CS==SDRAM_INIT_FINISH);

//////////64ms刷新周期,15us计数(4096行)/////////////
reg [10:0] CNT_15;
reg SDRAM_REF_REQ;//SDRAM刷新请求
wire SDRAM_REF_ACK;
always@(posedge CLK_100M or negedge RST_N)
begin
	if(!RST_N)
		SDRAM_REF_REQ<=1'b0;
	else if(CNT_15==11'd1498)
		SDRAM_REF_REQ<=1'b1;////产生自刷新请求
	else if(SDRAM_REF_ACK)
		SDRAM_REF_REQ<=1'b0;///刷新请求响应后，撤销刷新请求
end 
always@(posedge CLK_100M or negedge RST_N)
begin
	if(!RST_N)
		CNT_15<=`UD 11'd0;
	else if(CNT_15<11'd1499)
		CNT_15<=`UD CNT_15+11'd1;
	else
		CNT_15<=`UD 11'd0;
end

//////////////////工作状态转移///////////
reg SDRAM_R_W;
//reg SDRAM_R_W_N;/////SDRAM读写控制信号 */
always@(posedge CLK_100M or negedge RST_N)
begin
	if(!RST_N)
		WORK_CS<=`UD WORK_IDLE;
	else
		WORK_CS<=`UD WORK_NS;
end 
always@(*)
begin
	case(WORK_CS)
		WORK_IDLE:
			if(SDRAM_INIT_DONE && SDRAM_REF_REQ)
				WORK_NS=WORK_AR;
			else if(SDRAM_INIT_DONE && (SDRAM_RD_REQ || SDRAM_WR_REQ))
				WORK_NS=WORK_ROW_ACTIVE;
			else
				WORK_NS=WORK_CS;
		WORK_ROW_ACTIVE:
			WORK_NS=WORK_TRCD;
		WORK_TRCD:
			if((TIME_CNT==SDRAM_TRCD) && SDRAM_R_W)
				WORK_NS=WORK_READ_CMD;
			else if((TIME_CNT==SDRAM_TRCD)&&(!SDRAM_R_W))
				WORK_NS=WORK_WRITE;
			else
				WORK_NS=WORK_CS;
		WORK_READ_CMD:
			WORK_NS=WORK_CL;
		WORK_CL:
			if(TIME_CNT==SDRAM_TCL)
				WORK_NS=WORK_READ;
			else
				WORK_NS=WORK_CS;
		WORK_READ:
			if(TIME_CNT==SDRAM_RW_CLK-1)
				WORK_NS=WORK_RWAIT;//WORK_RWAIT;
			else
				WORK_NS=WORK_CS;
		WORK_RWAIT:
			if(TIME_CNT==SDRAM_RWAIT)
				WORK_NS=WORK_IDLE;
			else
				WORK_NS=WORK_CS;
			
		WORK_WRITE:
			if(TIME_CNT==SDRAM_RW_CLK)
				WORK_NS=WORK_WAIT;
			else
				WORK_NS=WORK_CS;
		WORK_WAIT:
			if(TIME_CNT==SDRAM_TRDL)
				WORK_NS=WORK_IDLE;
			else
				WORK_NS=WORK_CS;
		WORK_AR:
			if(TIME_CNT==SDRAM_TRC)
				WORK_NS=WORK_IDLE;
			else
				WORK_NS=WORK_CS;
		default:
			WORK_NS=WORK_IDLE;
	endcase
end 
//////////SDRAM读写控制信号//////////////////////////
always@(posedge CLK_100M or negedge RST_N)
begin
	if(!RST_N)
		SDRAM_R_W<=`UD 1'b0;
	else if(WORK_CS==WORK_IDLE)
	begin
	    if((SDRAM_REF_REQ)&& SDRAM_INIT_DONE)
			SDRAM_R_W<=`UD 1'b1;
		else if(SDRAM_INIT_DONE && SDRAM_WR_REQ)
			SDRAM_R_W<=`UD 1'b0;
		else if(SDRAM_INIT_DONE && SDRAM_RD_REQ)
			SDRAM_R_W<=`UD 1'b1;
	end
end
///////////////计数器////////////////////////////////
always@(posedge CLK_100M or negedge RST_N)
begin
	if(!RST_N)
		TIME_CNT<=`UD 4'h0;
	else
		TIME_CNT<=`UD TIME_CNT_N;
end
always@(*)
begin
	if((INIT_CS!=INIT_NS)||(WORK_CS!=WORK_NS))
		TIME_CNT_N=4'h0;
	else
		TIME_CNT_N=TIME_CNT+4'h1;
end 

assign SDRAM_RD_ACK=(((WORK_CS==WORK_READ)&&(TIME_CNT>4'd0))||((WORK_CS==WORK_RWAIT)&&(TIME_CNT<4'd2)));
assign SDRAM_WR_ACK=(((WORK_CS==WORK_TRCD)&&(WORK_NS==WORK_WRITE))||((WORK_CS==WORK_WRITE)&&(TIME_CNT<4'd7))); 
assign SDRAM_REF_ACK=(WORK_CS==WORK_AR);

endmodule
