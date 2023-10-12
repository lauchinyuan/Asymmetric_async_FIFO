`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/10/09 20:53:03
// Module Name: ram
// Description: 简单双端口RAM, 用作FIFO的缓存器, 支持非对称读写(读写端口位宽不一致)操作

// 参数依赖说明:
// RAM_ADDR_WIDTH = log2(RAM_DEPTH)
// WR_IND = WR_WIDTH/RAM_WIDTH
// RD_IND = RD_WIDTH/RAM_WIDTH
//////////////////////////////////////////////////////////////////////////////////


module ram
#(parameter RAM_DEPTH       = 'd32                  , //存储器深度
            RAM_ADDR_WIDTH  = 'd5                   , //读写地址宽度, 需与RAM_DEPTH匹配
            WR_WIDTH        = 'd8                   , //写数据位宽
            RD_WIDTH        = 'd32                  , //读数据位宽
            RAM_WIDTH       = WR_WIDTH              , //RAM存储器的位宽
            WR_IND          = 'd1                   , //单次写操作访问的ram_mem单元个数
            RD_IND          = 'd4                     //单次读操作访问的ram_mem单元个数  
)
(
        //写端口
        input   wire                        wr_clk      ,
        input   wire                        wr_en       , //写使能
        input   wire [RAM_ADDR_WIDTH-1:0]   wr_addr     , //写地址
        input   wire [WR_WIDTH-1:0]         wr_data     , //写数据
        
        //读端口
        input   wire                        rd_clk      ,
        input   wire [RAM_ADDR_WIDTH-1:0]   rd_addr     , //读地址
        output  reg [RD_WIDTH-1:0]          rd_data       //读数据        
    );
    
    //映射到FPGA BRAM存储单元
    (*ram_style="block"*)reg [RAM_WIDTH-1:0] ram_mem[RAM_DEPTH-1:0];
    
    //写过程,单次写操作写WR_IND个地址连续的ram_mem存储单元
    //高地址存放低字节数据
    genvar i;
    generate
        for(i=0;i<WR_IND;i=i+1) begin: ram_write
            //写入的每个存储单元
            always@(posedge wr_clk) begin
                if(wr_en) begin
                    ram_mem[wr_addr+i] <= wr_data[WR_WIDTH-1-RAM_WIDTH*i : WR_WIDTH-RAM_WIDTH-RAM_WIDTH*i];
                end else begin
                    ram_mem[wr_addr+i] <= ram_mem[wr_addr+i];
                end
            end   
            
        end
    endgenerate
    
    //读过程,读地址的数据立即给出,单次读操作获取RD_IND个地址连续的ram_mem存储单元的值
    //高地址存放低字节数据
    genvar j;
    generate
        for(j=0;j<RD_IND;j=j+1) begin: ram_read
            //读取的每个存储单元
            always@(posedge rd_clk) begin
                rd_data[RD_WIDTH-1-RAM_WIDTH*j: RD_WIDTH-RAM_WIDTH-RAM_WIDTH*j] = ram_mem[rd_addr+j];
            end
        end
    endgenerate
    
endmodule
