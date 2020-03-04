`timescale 1ps / 1ps

module tb_uart_cmd_inter (); 

  parameter CLOCK_PERIOD_PS = 40000;
  parameter CLKS_PER_BIT    = 434;
  parameter BIT_PERIOD      = 17360000;

    reg clk; 
    reg tx_dv; 
    reg [7:0] tx_byte; 
    wire tx_done;
    wire iData; 
    wire [2:0] oCmd; 

    uart_cmd_inter dut(.clk(clk), 
                       .iData(iData),
                       .tx_dv(tx_dv),
                       .oCmd(oCmd));

    uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT))
           tx(.i_Clock(clk), 
              .i_Tx_DV('b1),
              .i_Tx_Byte(8'hA7), 
              .o_Tx_Active(), 
              .o_Tx_Serial(iData),
              .o_Tx_Done(tx_done)); 

    always 
        #20000 clk = ~clk; 

    initial begin 
       #0 clk = 0;
        @(posedge clk);
        @(posedge clk); 
        tx_dv <= 'b1; 
        tx_byte <= 'hA7; 
        @(posedge clk); 
        tx_dv <= 'b0;
        @(posedge tx_done); 

        #1000;
    end

endmodule
       

