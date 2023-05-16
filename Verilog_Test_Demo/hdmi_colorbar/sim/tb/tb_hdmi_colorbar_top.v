//****************************************Copyright (c)***********************************//
//原子哥在线教学平台：www.yuanzige.com
//技术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com 
//关注微信公众平台微信号："正点原子"，免费获取ZYNQ & FPGA & STM32 & LINUX资料。
//版权所有，盗版必究。
//Copyright(C) 正点原子 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           tb_hdmi_colorbar_top
// Last modified Date:  2019/7/1 9:30:00
// Last Version:        V1.1
// Descriptions:        TestBench
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2019/7/1 9:30:00
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

`timescale  1ns/1ns                     //定义仿真时间单位1ns和仿真时间精度为1ns

module  tb_hdmi_colorbar_top;              

//parameter  define
parameter  T = 20;                      //时钟周期为20ns

//reg define
reg          sys_clk;                   //时钟信号
reg          sys_rst_n;                 //复位信号

//wire define
wire         tmds_clk_p;
wire         tmds_clk_n;
wire  [2:0]  tmds_data_p;
wire  [2:0]  tmds_data_n;      

//*****************************************************
//**                    main code
//*****************************************************

//给输入信号初始值
initial begin
    sys_clk            = 1'b0;
    sys_rst_n          = 1'b0;     //复位
    #(T+1)  sys_rst_n  = 1'b1;     //在第21ns的时候复位信号信号拉高
end

//50Mhz的时钟，周期则为1/50Mhz=20ns,所以每10ns，电平取反一次
always #(T/2) sys_clk = ~sys_clk;

//例化HDMI彩条顶层模块
hdmi_colorbar_top  u_hdmi_colorbar_top(
    .sys_clk       (sys_clk),
    .sys_rst_n     (sys_rst_n),
     
    .tmds_clk_p    (tmds_clk_p),
    .tmds_clk_n    (tmds_clk_n),
    .tmds_data_p   (tmds_data_p),
    .tmds_data_n   (tmds_data_n)
    );

endmodule
