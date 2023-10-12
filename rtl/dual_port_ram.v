`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/10/12 15:38:30
// Module Name: dual_port_ram
// Description: 简单双端口RAM, 作为FIFO的内部存储器, 读写位宽一致, 读写时钟不同
// 使用(*ram_style="block"*)标记, 可指导Vivado综合工具生成BRAM
//////////////////////////////////////////////////////////////////////////////////


module dual_port_ram
#(parameter RAM_DEPTH       = 'd32     , //RAM深度
            RAM_ADDR_WIDTH  = 'd5      , //读写地址宽度, 需与RAM_DEPTH匹配
            RAM_DATA_WIDTH  = 'd8      , //写数据位宽
            RAM_DATA_WIDTH  = 'd32       //读数据位宽
)
    (
        //写端口
        input   wire                        wr_clk          , //写时钟
        input   wire                        wr_port_ena     , //写端口使能, 高有效
        input   wire                        wr_en           , //写数据使能
        input   wire [RAM_DATA_WIDTH-1:0]   wr_data         , //写数据位宽
        
        //读端口
        input   wire                        rd_clk          , //读时钟
        input   wire                        rd_port_ena     , //读端口使能, 高有效
        output  reg  [RAM_DATA_WIDTH-1:0]   rd_data           //读数据位宽
                                                              

    );
    
    
    
endmodule
