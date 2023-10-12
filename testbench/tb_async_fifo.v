`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/10/11 14:18:39
// Module Name: tb_async_fifo
// Description: testbench for async_fifo module 
//////////////////////////////////////////////////////////////////////////////////


module tb_async_fifo(

    );
    
    //参数
    parameter RAM_DEPTH       = 'd32                          , //内部RAM存储器深度
              RAM_ADDR_WIDTH  = 'd5                           , //内部RAM读写地址宽度, 需与RAM_DEPTH匹配
              WR_WIDTH        = 'd8                           , //写数据位宽
              RD_WIDTH        = 'd32                          , //读数据位宽
              WR_IND          = 'd1                           , //单次写操作访问的ram_mem单元个数
              RD_IND          = 'd4                           , //单次读操作访问的ram_mem单元个数         
              RAM_WIDTH       = WR_WIDTH                      , //写端口数据位宽更小,使用写数据位宽作为RAM存储器的位宽
              WR_CNT_WIDTH    = RAM_ADDR_WIDTH + 'd1          , //FIFO写端口计数器的位宽
              RD_CNT_WIDTH    = RAM_ADDR_WIDTH + 'd1 - 'd2    , //FIFO读端口计数器的位宽
              WR_RTR_ZERO_BIT = 'd0                           , //写指针低位补零个数, 值为log2(WR_IND)
              RD_PTR_ZERO_BIT = 'd2                           ; //读指针低位补零个数, 值为log2(RD_IND)   
    //连线
    //写相关
    reg                        wr_clk          ; //写端口时钟
    reg                        wr_rst_n        ; //写地址复位
    reg                        wr_en           ; //写使能
    reg [WR_WIDTH-1:0]         wr_data         ; //写数据
    wire                       fifo_full       ; //FIFO写满
    wire[WR_CNT_WIDTH-1:0]     wr_data_count   ; //写端口数据个数,按写端口数据位宽计算
    //读相关                                            
    reg                        rd_clk          ; //读端口时钟
    reg                        rd_rst_n        ; //读地址复位 
    reg                        rd_en           ; //读使能
    wire[RD_WIDTH-1:0]         rd_data         ; //读数据
    wire                       fifo_empty      ; //FIFO读空
    wire[RD_CNT_WIDTH-1:0]     rd_data_count   ; //读端口数据个数,按读端口数据位宽计算
    
    initial begin
        wr_clk = 1'b1;
        rd_clk = 1'b1;
        wr_rst_n <= 1'b0;
        rd_rst_n <= 1'b0;
        wr_en <= 1'b0;
        rd_en <= 1'b0;
    #20
        wr_rst_n <= 1'b1;
        rd_rst_n <= 1'b1;

        //读写同时进行的仿真
/*      wr_en <= 1'b1; 
    wait(wr_data_count >= 'd28); //数据量满足一定条件开始读
        rd_en <= 1'b1;
    wait(fifo_empty);
        rd_en <= 1'b0;  //读空后停止读
    wait(fifo_full);    //写满后停止写
        wr_en <= 1'b0;
        rd_en <= 1'b1;  //开始将FIFO读出 */
        
        //先写满, 再读取
        wr_en <= 1'b1;
        wait(fifo_full);
        wr_en <= 1'b0;
        rd_en <= 1'b1;
        wait(fifo_empty);
        rd_en <= 1'b0;
        
    end
    
    //wr_data
    always@(posedge wr_clk or negedge wr_rst_n) begin
        if(~wr_rst_n) begin
            wr_data <= 'd0;
        end else if(wr_en) begin
            wr_data <= wr_data + 'd1;
        end else begin
            wr_data <= wr_data;
        end
    end
    
    always#5    wr_clk = ~wr_clk; //写时钟100MHz
    always#10   rd_clk = ~rd_clk; //读时钟50MHz

    
    async_fifo
    #(.RAM_DEPTH       (RAM_DEPTH       ), //内部RAM存储器深度
      .RAM_ADDR_WIDTH  (RAM_ADDR_WIDTH  ), //内部RAM读写地址宽度, 需与RAM_DEPTH匹配
      .WR_WIDTH        (WR_WIDTH        ), //写数据位宽
      .RD_WIDTH        (RD_WIDTH        ), //读数据位宽
      .WR_IND          (WR_IND          ), //单次写操作访问的ram_mem单元个数
      .RD_IND          (RD_IND          ), //单次读操作访问的ram_mem单元个数         
      .RAM_WIDTH       (RAM_WIDTH       ), //写端口数据位宽更小,使用写数据位宽作为RAM存储器的位宽
      .WR_CNT_WIDTH    (WR_CNT_WIDTH    ), //FIFO写端口计数器的位宽
      .RD_CNT_WIDTH    (RD_CNT_WIDTH    ), //FIFO读端口计数器的位宽
      .WR_RTR_ZERO_BIT (WR_RTR_ZERO_BIT ), //写指针低位补零个数, 值为log2(WR_IND)
      .RD_PTR_ZERO_BIT (RD_PTR_ZERO_BIT )  //读指针低位补零个数, 值为log2(RD_IND)   
     )
    async_fifo_inst
    (
        //写相关
        .wr_clk          (wr_clk          ), //写端口时钟
        .wr_rst_n        (wr_rst_n        ), //写地址复位
        .wr_en           (wr_en           ), //写使能
        .wr_data         (wr_data         ), //写数据
        .fifo_full       (fifo_full       ), //FIFO写满
        .wr_data_count   (wr_data_count   ), //写端口数据个数,按写端口数据位宽计算
        //读相关
        .rd_clk          (rd_clk          ), //读端口时钟
        .rd_rst_n        (rd_rst_n        ), //读地址复位 
        .rd_en           (rd_en           ), //读使能
        .rd_data         (rd_data         ), //读数据
        .fifo_empty      (fifo_empty      ), //FIFO读空
        .rd_data_count   (rd_data_count   )  //读端口数据个数,按读端口数据位宽计算
    );
endmodule
