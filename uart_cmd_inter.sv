//---------------------------------------------------------------------------//
// File:	tm_frame_rx.sv           										 //	
// Author:	Christopher Smith		    									 //
// Date:	November  2019													 //
// Brief:   Receives generic TM frame and buffer in fifo                     //
//          Assumes: 24 bit sync patter for a subframes and 8 bit words      //
//                                                   						 //
//---------------------------------------------------------------------------//

module uart_cmd_inter (
    input clk, 
    input iData,
    input tx_dv,
    input cmd_clear,
    output reg [15:0] mgu_cmd = 'b0, 
    output reg [15:0] gnu_cmd = 'b0,
    output reg cmd_set = 'b0
);
    reg [7:0] cmd_buff [3:0];

    wire dv;
    wire [7:0] rxByte;
 
    uart_rx #(.CLKS_PER_BIT(434)) //50 Mhz input clk .3% error
            rx(.i_Clock(clk), 
               .i_Rx_Serial(iData),
               .o_Rx_DV(dv),
               .o_Rx_Byte(rxByte)); 

    reg strobe = 'b0; 
    //Shift register
    always @(posedge clk) begin 
         
        if(dv == 'b1) begin
            cmd_buff[3] <= cmd_buff[2]; 
            cmd_buff[2] <= cmd_buff[1]; 
            cmd_buff[1] <= cmd_buff[0]; 
            cmd_buff[0] <= rxByte;     
        end
        else begin
            if(cmd_buff[3] == 'h21) begin 
                 cmd_set <= (cmd_clear) ? 'b0 : 'b1;
                cmd_buff[3] <= (cmd_clear) ? 'b0 : cmd_buff[3];
                if(cmd_buff[2] == 'h4D)   //M for mgu
                    mgu_cmd <= {cmd_buff[1] - 'd30, cmd_buff[0] - 'd30};
                else if(cmd_buff[2] == 'h47) //G for gnu
                    gnu_cmd <= {cmd_buff[1] - 'd30, cmd_buff[0] - 'd30};
                else if(cmd_buff[2] == 'h42)begin //B for both 
                    mgu_cmd <= {cmd_buff[1] - 'd30, cmd_buff[0] - 'd30};
                    gnu_cmd <= {cmd_buff[1] - 'd30, cmd_buff[0] - 'd30};
                end
            end
        end
    end
endmodule 

    
