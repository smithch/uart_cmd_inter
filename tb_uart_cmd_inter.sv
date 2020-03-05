`timescale 1ps / 1ps

module tb_uart_cmd_inter (); 

  parameter CLOCK_PERIOD_PS = 40000;
  parameter CLKS_PER_BIT    = 434;
  parameter BIT_PERIOD      = 17360000;

    reg clk; 
    reg tx_dv; 
    reg [7:0] tx_byte = 'b0;
    reg cmd_clear = 'b0; 
    wire tx_done;
    wire iData; 
    wire [15:0] mgu_cmd;
    wire [15:0] gnu_cmd; 
    wire cmd_set; 

    uart_cmd_inter dut(.clk(clk), 
                       .iData(iData),
                       .tx_dv(tx_dv),
                       .cmd_clear(cmd_clear),
                       .mgu_cmd(mgu_cmd),
                       .gnu_cmd(gnu_cmd),
                       .cmd_set(cmd_set));

    uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT))
           tx(.i_Clock(clk), 
              .i_Tx_DV(tx_dv),
              .i_Tx_Byte(tx_byte), 
              .o_Tx_Active(), 
              .o_Tx_Serial(iData),
              .o_Tx_Done(tx_done)); 

    always 
        #20000 clk = ~clk; 

    initial begin 
       #0 clk = 0;
        @(posedge clk);
        tx_dv <= 'b1;
        @(negedge clk); 
        
        tx_byte = 'h21;
        @(negedge clk); 
        tx_dv = 'b0; 
       
        @(posedge tx_done);
        @(posedge clk); 
        @(posedge clk); 
        tx_dv = 'b1; 
        @(negedge clk); 
        tx_byte = 'h4D;
        @(posedge clk);
        @(posedge clk);
        tx_dv = 'b0; 
        @(posedge tx_done);
        tx_dv = 'b1; 
        @(posedge clk); 
        @(posedge clk); 
        @(negedge clk); 
        tx_byte = 'hF1; 
        @(posedge clk); 
        @(posedge clk); 
        tx_dv = 'b0; 
        @(posedge tx_done);
        tx_dv = 'b1; 
        @(posedge clk); 
        @(posedge clk);
        @(negedge clk); 
        tx_byte = 'h28; 
         @(posedge clk);
        tx_dv = 'b0;
        @(posedge tx_done);

        #1000 cmd_clear = 'b1;
        #40000 cmd_clear = 'b0;

    end

endmodule
       

