//****************************************Copyright (c)***********************************//
//原子哥在线教学平台：www.yuanzige.com
//技术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com 
//关注微信公众平台微信号："正点原子"，免费获取ZYNQ & FPGA & STM32 & LINUX资料。
//版权所有，盗版必究。
//Copyright(C) 正点原子 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           serializer_10_to_1
// Last modified Date:  2021/4/7 9:30:00
// Last Version:        V1.1
// Descriptions:        用于实现10:1并串转换
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2021/4/7 9:30:00
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

`timescale 1ns / 1ps

module serializer_10_to_1(
    input           serial_clk_5x,      // 输入串行数据时钟
    input   [9:0]   paralell_data,      // 输入并行数据

    output 			serial_data_p,      // 输出串行差分数据P
    output 			serial_data_n       // 输出串行差分数据N
    );
    
//reg define
reg   [2:0]  bit_cnt = 0;    
reg   [4:0]  datain_rise_shift = 0;
reg   [4:0]  datain_fall_shift = 0;
    
//wire define
wire  [4:0]  datain_rise;    
wire  [4:0]  datain_fall;
  
//*****************************************************
//**                    main code
//*****************************************************

//上升沿发送Bit[8]/Bit[6]/Bit[4]/Bit[2]/Bit[0]
assign  datain_rise = {paralell_data[8],paralell_data[6],paralell_data[4],
                       paralell_data[2],paralell_data[0]};

//下降沿发送Bit[9]/Bit[7]/Bit[5]/Bit[3]/Bit[1]                       
assign  datain_fall = {paralell_data[9],paralell_data[7],paralell_data[5],
                       paralell_data[3],paralell_data[1]};

//位计数器赋值
always @(posedge serial_clk_5x) begin
    if(bit_cnt == 3'd4)
        bit_cnt <= 1'b0;
    else
        bit_cnt <= bit_cnt + 1'b1;
end                       

//移位赋值，发送并行数据的每一位
always @(posedge serial_clk_5x) begin
    if(bit_cnt == 3'd4) begin               
        datain_rise_shift <= datain_rise;
        datain_fall_shift <= datain_fall; 
    end    
    else begin
        datain_rise_shift <= datain_rise_shift[4:1];
        datain_fall_shift <= datain_fall_shift[4:1];
    end    
end                     

//例化DDIO_OUT IP核
ddio_out  u_ddio_out_p(
    .datain_h    (datain_rise_shift[0]),
    .datain_l    (datain_fall_shift[0]),
    .outclock    (serial_clk_5x),
    .dataout     (serial_data_p)
    );

//例化DDIO_OUT IP核
ddio_out  u_ddio_out_n(
    .datain_h    (~datain_rise_shift[0]),
    .datain_l    (~datain_fall_shift[0]),
    .outclock    (serial_clk_5x),
    .dataout     (serial_data_n)
    );    
 
endmodule
