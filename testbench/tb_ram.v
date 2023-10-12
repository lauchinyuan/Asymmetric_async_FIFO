`timescale 1ps / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Engineer: lauchinyuan
// Email: lauchinyuan@yeah.net
// Create Date: 2023/10/09 21:52:08
// Module Name: tb_ram
// Description: Testbench for ram module 
// Note: 此处时间单位是ps
//////////////////////////////////////////////////////////////////////////////////


module tb_ram(

    );
    
    //参数定义
    parameter   RAM_DEPTH       = 'd32                  , //存储器深度
                RAM_ADDR_WIDTH  = 'd5                   , //读写地址宽度, 需与RAM_DEPTH匹配
                WR_WIDTH        = 'd8                   , //写数据位宽
                RD_WIDTH        = 'd32                  , //读数据位宽
                RAM_WIDTH       = WR_WIDTH              , //RAM存储器的位宽
                WR_IND          = 'd1                   , //单次写操作访问的ram_mem单元个数
                RD_IND          = 'd4                   ; //单次读操作访问的ram_mem单元个数
 
    
    //DUT输入输出变量
    //写端口
    reg                        wr_clk      ;
    reg                        wr_en       ; //写使能
    reg [RAM_ADDR_WIDTH-1:0]   wr_addr     ; //写地址
    reg [WR_WIDTH-1:0]         wr_data     ; //写数据
    
    //读端口
    wire                       rd_clk      ;
    reg [RAM_ADDR_WIDTH-1:0]   rd_addr     ; //读地址
    wire[RD_WIDTH-1:0]         rd_data     ; //读数据   
    
    //辅助变量
    reg                        clk_non_shift; //辅助产生相位偏移时钟
    reg                        init         ; //初始化标记
    reg                        rd_en        ; //读标记,实际上RAM并没有读使能信号,使用该信号是为了控制读地址自增
    
    
    
    initial begin
        wr_clk = 1'b1;
        clk_non_shift = 1'b1;
        wr_en <= 1'b0;
        rd_en <= 1'b0;
        init <= 1'b1;
    #20000
        init <= 1'b0;
    #35000
        wr_en <= 1'b1;  //开始写
    #(6250*28)
        rd_en <= 1'b1;  
    #(6250*4)
        wr_en <= 1'b0;
    #(5000*19)
        rd_en <= 1'b0;
    end
    
    //wr_clk
    //160MHz
    always#3125 wr_clk = ~wr_clk;  
    
    //clk_non_shift
    //100MHz
    always#5000 clk_non_shift = ~clk_non_shift;
    
    
    //rd_clk是clk_non_shift的相移, 100MHz
    assign #2500 rd_clk = clk_non_shift;
    
    //wr_data从0开始自增
    always@(posedge wr_clk) begin
        if(init) begin
            wr_data <= 'd0;
        end else if(wr_en) begin
            wr_data <= wr_data + 'd1;
        end else begin
            wr_data <= wr_data;
        end
    end
    
    //每进行一次写,地址自增WR_IND
    //wr_addr
    always@(posedge wr_clk) begin
        if(init) begin
            wr_addr <= 'd0;
        end else if(wr_en) begin
            wr_addr <= wr_addr + WR_IND;
        end else begin
            wr_addr <= wr_addr;
        end
    end
  
    //每进行一次读,地址自增RD_IND
    //rd_addr
    always@(posedge rd_clk) begin
        if(init) begin
            rd_addr <= 'd0;
        end else if(rd_en) begin
            rd_addr <= rd_addr + RD_IND;
        end else begin
            rd_addr <= rd_addr;
        end
    end  
    
    ram
    #(.RAM_DEPTH      (RAM_DEPTH      ), 
      .RAM_ADDR_WIDTH (RAM_ADDR_WIDTH ), 
      .WR_WIDTH       (WR_WIDTH       ), 
      .RD_WIDTH       (RD_WIDTH       ), 
      .RAM_WIDTH      (RAM_WIDTH      ), 
      .WR_IND         (WR_IND         ), 
      .RD_IND         (RD_IND         )    
    )
    ram_inst
    (
        //写端口
        .wr_clk      (wr_clk      ),
        .wr_en       (wr_en       ), 
        .wr_addr     (wr_addr     ), 
        .wr_data     (wr_data     ), 
        
        //读端口
        .rd_clk      (rd_clk      ),
        .rd_addr     (rd_addr     ), 
        .rd_data     (rd_data     )         
    );
endmodule
