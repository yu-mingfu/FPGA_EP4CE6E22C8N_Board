//****************************************Copyright (c)***********************************//
//原子哥在线教学平台：www.yuanzige.com
//技术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com 
//关注微信公众平台微信号："正点原子"，免费获取ZYNQ & FPGA & STM32 & LINUX资料。
//版权所有，盗版必究。
//Copyright(C) 正点原子 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           dvi_transmitter_top
// Last modified Date:  2021/4/7 9:30:00
// Last Version:        V1.1
// Descriptions:        DVI发送端顶层模块
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2021/4/7 9:30:00
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module dvi_transmitter_top(
    input        pclk,           // pixel clock
    input        pclk_x5,        // pixel clock x5
    input        reset_n,        // reset
    
    input [23:0] video_din,      // RGB888 video in
    input        video_hsync,    // hsync data
    input        video_vsync,    // vsync data
    input        video_de,       // data enable
    
    output       tmds_clk_p,     // TMDS 时钟通道
    output       tmds_clk_n,
    output [2:0] tmds_data_p,    // TMDS 数据通道
    output [2:0] tmds_data_n
    );
    
//wire define    
wire        reset;
    
//并行数据
wire [9:0]  red_10bit;
wire [9:0]  green_10bit;
wire [9:0]  blue_10bit;
wire [9:0]  clk_10bit;  
  
//串行数据
wire [2:0]  tmds_data_serial;
wire        tmds_clk_serial;

//*****************************************************
//**                    main code
//***************************************************** 

assign clk_10bit = 10'b1111100000;

//异步复位，同步释放
asyn_rst_syn reset_syn(
    .reset_n    (reset_n),
    .clk        (pclk),
    
    .syn_reset  (reset)    //高有效
    );
  
//对三个颜色通道进行编码
dvi_encoder encoder_b (
    .clkin      (pclk),
    .rstin	    (reset),
    
    .din        (video_din[7:0]),
    .c0			(video_hsync),
    .c1			(video_vsync),
    .de			(video_de),
    .dout		(blue_10bit)
    ) ;

dvi_encoder encoder_g (
    .clkin      (pclk),
    .rstin	    (reset),
    
    .din		(video_din[15:8]),
    .c0			(1'b0),
    .c1			(1'b0),
    .de			(video_de),
    .dout		(green_10bit)
    ) ;
    
dvi_encoder encoder_r (
    .clkin      (pclk),
    .rstin	    (reset),
    
    .din		(video_din[23:16]),
    .c0			(1'b0),
    .c1			(1'b0),
    .de			(video_de),
    .dout		(red_10bit)
    ) ;
    
//对编码后的数据进行并串转换
serializer_10_to_1 serializer_b(
    .serial_clk_5x      (pclk_x5),              // 输入串行数据时钟
    .paralell_data      (blue_10bit),           // 输入并行数据

    .serial_data_p      (tmds_data_p[0]),       // 输出串行数据P
    .serial_data_n      (tmds_data_n[0])        // 输出串行数据N
    );    
    
serializer_10_to_1 serializer_g(
    .serial_clk_5x      (pclk_x5),              // 输入串行数据时钟
    .paralell_data      (green_10bit),          // 输入并行数据

    .serial_data_p      (tmds_data_p[1]),       // 输出串行数据P
    .serial_data_n      (tmds_data_n[1])        // 输出串行数据N
    ); 
    
serializer_10_to_1 serializer_r(
    .serial_clk_5x      (pclk_x5),              // 输入串行数据时钟
    .paralell_data      (red_10bit),            // 输入并行数据

    .serial_data_p      (tmds_data_p[2]),       // 输出串行数据P
    .serial_data_n      (tmds_data_n[2])        // 输出串行数据N
    ); 
            
serializer_10_to_1 serializer_clk(
    .serial_clk_5x      (pclk_x5),
    .paralell_data      (clk_10bit),

    .serial_data_p      (tmds_clk_p),           // 输出串行时钟P
    .serial_data_n      (tmds_clk_n)            // 输出串行时钟N
    );

endmodule
