`define UD #1
module SDFIFO_CTL(
					CLK_50M,
					CLK_100M,
					WR_FIFO_DATA,
					WR_FIFO_REQ,
					RST_N,
					SDRAM_RD_REQ,
					SDRAM_WR_REQ,
					SDRAM_RD_ACK,
					SDRAM_WR_ACK,
					
					TX_EN,
					
					WR_DONE,
					
					RD_FIFO_REQ,
					RD_FIFO_DATA,
					
					SDRAM_DATA_OUT,
					SDRAM_DATA_IN,
					RD_EMPTY
				 );
				 
input CLK_50M;//写FIFO缓冲的写时钟以及读FIFO缓冲的读时钟
input CLK_100M;//写FIFO缓冲的读时钟以及读FIFO缓冲的写时钟
input RST_N;
input [15:0] WR_FIFO_DATA;//生成的数据写入FIFO缓冲
input WR_DONE;//写入完成标志
input WR_FIFO_REQ;//写FIFO缓冲的请求信号

input SDRAM_RD_ACK;
input SDRAM_WR_ACK;

input RD_FIFO_REQ;//读FIFO的请求信号
input [15:0] SDRAM_DATA_OUT;//sdram的数据送到读FIFO缓冲

output SDRAM_RD_REQ;
output SDRAM_WR_REQ;
output [15:0] SDRAM_DATA_IN;
output [15:0] RD_FIFO_DATA;//从读FIFO缓冲读取的数据送入串口显示
output  TX_EN;//串口发送使能标志

output RD_EMPTY;
wire SDRAM_RD_REQ;
wire SDRAM_WR_REQ;
wire TX_EN;


wire [8:0] WR_FIFO_USED;
wire [8:0] RD_FIFO_USED;

		
assign SDRAM_WR_REQ=(WR_FIFO_USED>=9'd8)&&(~WR_DONE);//FIFO（8个16bit数据）即发出写SDRAM请求信号
assign SDRAM_RD_REQ=(RD_FIFO_USED<=9'd256)&&(WR_DONE);//sdram写入完成且FIFO半空（256个16bit数据）即发出读SDRAM请求信号
assign TX_EN=((RD_FIFO_USED>=9'd4)&&(WR_DONE==1'b1));
/*always@(posedge CLK_100M or negedge RST_N)
begin
	if(!RST_N)
		TX_EN<=1'b0;
	else if(SDRAM_RD_ACK && WR_DONE)
		TX_EN<=1'b1;
end*/
//例化SDRAM写入数据缓存FIFO模块
WR_FIFO  I_WR_FIFO(
					.data(WR_FIFO_DATA),
					.rdclk(CLK_100M),
					.wrclk(CLK_50M),
					.rdreq(SDRAM_WR_ACK),
					.wrreq(WR_FIFO_REQ),
					.q(SDRAM_DATA_IN),
					.wrusedw(WR_FIFO_USED)
					//.aclr(!RST_N)
				  );

//例化SDRAM读出数据缓存FIFO模块
RD_FIFO  I_RD_FIFO(
					.data(SDRAM_DATA_OUT),
					.rdclk(CLK_50M),
					.wrclk(CLK_100M),
					.rdreq(RD_FIFO_REQ),
					.wrreq(SDRAM_RD_ACK),
					.q(RD_FIFO_DATA),
					.wrusedw(RD_FIFO_USED),
					.wrempty(RD_EMPTY)
					//.aclr(!RST_N)
				  );
endmodule




