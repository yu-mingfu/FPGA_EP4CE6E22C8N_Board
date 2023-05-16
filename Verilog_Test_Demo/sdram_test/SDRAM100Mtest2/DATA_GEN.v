`define UD #1
module DATA_GEN(
					SYSCLK,
					RST_N,
					WR_FIFO_DATA,
					WR_ADDR,
					SDRAM_RD_ACK,
					WR_DONE,
					WR_FIFO_REQ
			   );

input SYSCLK;
input RST_N;
input SDRAM_RD_ACK;////系统读SDRAM响应信号,作为rdFIFO的输写有效信号,这里捕获它的下降沿作为读地址自增加标志位

output [15:0] WR_FIFO_DATA;//sdram数据写入缓存FIFO输入数据总线
output [21:0] WR_ADDR;//SDRAM读写地址产生
output WR_DONE;//所有数据写入sdram完成标志
output WR_FIFO_REQ;//sdram数据写入FIFO的请求信号

//////////////////////////////////////////
wire SYSCLK;
wire RST_N;
wire SDRAM_RD_ACK;////系统读SDRAM响应信号,作为rdFIFO的输写有效信号,这里捕获它的下降沿作为读地址自增加标志位

reg [15:0] WR_FIFO_DATA;//sdram数据写入缓存FIFO输入数据总线
wire [21:0] WR_ADDR;//SDRAM读写地址产生
reg WR_DONE;//所有数据写入sdram完成标志
reg WR_FIFO_REQ;//sdram数据写入FIFO的请求信号

//reg WR_DONE_N;
////////////////////////
reg SDRAM_RD_ACK_REG;
reg SDRAM_RD_ACK_REG_N;
wire SDRAM_RD_ACK_NEG;//sdram_rd_ack的下降沿

always@(posedge SYSCLK or negedge RST_N) 
	if(!RST_N)
		begin
			SDRAM_RD_ACK_REG<=`UD 1'b0;
			SDRAM_RD_ACK_REG_N<=`UD 1'b0;
		end
	else
		begin
			SDRAM_RD_ACK_REG<=`UD SDRAM_RD_ACK;
			SDRAM_RD_ACK_REG_N<=`UD SDRAM_RD_ACK_REG;
		end
assign SDRAM_RD_ACK_NEG=~SDRAM_RD_ACK_REG && SDRAM_RD_ACK_REG_N;

//////////上电500us延时，等待SDRAM初始化///////////////////////////
reg [23:0] TIME_CNT;
reg [23:0] TIME_CNT_N;
wire DELAY_500US_DONE;//延时500us完成标志
always@(posedge SYSCLK or negedge RST_N)
begin
	if(!RST_N)
		TIME_CNT<=`UD 24'h0;
	else
		TIME_CNT<=`UD TIME_CNT_N;
end
always@(*)
begin
	if(TIME_CNT<24'd25000)
		TIME_CNT_N=TIME_CNT+24'h1;
	else
		TIME_CNT_N=TIME_CNT;
end
assign DELAY_500US_DONE=(TIME_CNT==24'd25000);

//每640ns写入8个16bit数据到sdram，
//上电后所有地址写入完毕时间需要不到360ms时间
reg [4:0] CNT_64;
//wire [7:0] CNT_64_N;
always@(posedge SYSCLK or negedge RST_N)
begin
	if(!RST_N)
		CNT_64<=`UD 5'd0;
	else if(DELAY_500US_DONE)
		CNT_64<=`UD CNT_64+5'd1;
end
//assign CNT_64_N=(DELAY_500US_DONE)?CNT_64+8'h1:CNT_64;
//////////////////////////////////////////////////
//读写sdram地址产生
reg [18:0] ADDR;
//reg [18:0] ADDR_N;
always@(posedge SYSCLK or negedge RST_N)
begin
	if(!RST_N)
		ADDR<=`UD 19'h0;
	else if(!WR_DONE && (CNT_64==5'h1f))
		ADDR<=`UD ADDR+1'b1;
	else if(WR_DONE && SDRAM_RD_ACK_NEG)
		ADDR<=`UD ADDR+1'b1;
end
/*always@(*)
begin
	if(!WR_DONE && (CNT_64==8'hff))
		ADDR_N=ADDR+19'h1;//写地址产生
	else if(WR_DONE && SDRAM_RD_ACK_NEG)
		ADDR_N=19'h7ffff;//ADDR+19'h1;//读地址产生
	else
		ADDR_N=ADDR;
end*/

assign WR_ADDR={ADDR,3'b000};

//////所有数据写入sdram完成////////////////////
always@(posedge SYSCLK or negedge RST_N)
begin
	if(!RST_N)
		WR_DONE<=`UD 1'b0;
	else if((ADDR==19'h7ffff)&&(CNT_64==5'h1f))
		WR_DONE<=`UD 1'b1;
end
/*always@(*)
begin
	if(ADDR_N==19'h7ffff)
		WR_DONE_N=1'b1;
	else
		WR_DONE_N=WR_DONE;
end*/

///////////////////////////////////////
//将写入SDRAM的数据先写入FIFO的请求信号
//reg WR_FIFO_REQ_N;

always@(posedge SYSCLK or negedge RST_N)
begin
	if(!RST_N)
		WR_FIFO_REQ<=`UD 1'b0;
	else if(!WR_DONE)
		begin
			if(CNT_64==5'h05)
				WR_FIFO_REQ<=`UD 1'b1;
			else if(CNT_64==5'h0d)
				WR_FIFO_REQ<=`UD 1'b0;
	    end
end
/*always@(*)
begin
	if(!WR_DONE)
		begin
			if(CNT_64_N==8'h6)
				WR_FIFO_REQ_N=1'b1;
			else if(CNT_64_N==8'hE)
				WR_FIFO_REQ_N=1'h0;
			else
				WR_FIFO_REQ_N=WR_FIFO_REQ;
		end
	else
		WR_FIFO_REQ_N=WR_FIFO_REQ;
end*/
//////////////////////////////////
//reg [15:0] WR_FIFO_DATA_N;
always@(posedge SYSCLK or negedge RST_N)
begin
	if(!RST_N)
		WR_FIFO_DATA<=`UD 16'hFFFF;
	else if(!WR_DONE &&((CNT_64>5'h05)&&(CNT_64<=5'h0d)))
		WR_FIFO_DATA<=`UD WR_FIFO_DATA+1'b1;
	//	WR_FIFO_DATA<=`UD 16'h5555;
end
/*always@(*)
begin
	if(!WR_DONE && (CNT_64_N>8'h5) && (CNT_64_N<8'hE))
		WR_FIFO_DATA_N=WR_FIFO_DATA+16'h1;
	else
		WR_FIFO_DATA_N=WR_FIFO_DATA;
end*/

endmodule

///////////////////////////////////////////////

