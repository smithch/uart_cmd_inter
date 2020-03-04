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
    output [15:0] mgu_cmd; 
    output [15:0] gnu_cmd;
);
    reg [7:0] cmd_buff [3:0];

    wire dv;
    wire [7:0] rxByte;
 
    uart_rx #(.CLKS_PER_BIT(434)) //50 Mhz input clk .3% error
            rx(.i_Clock(clk), 
               .i_Rx_Serial(iData),
               .o_Rx_DV(dv),
               .o_Rx_Byte(rxByte)); 

    //Shift register
    always @(posedge clk) begin 
        if(dv == 'b1) begin
            cmd_buff[3] <= cmd_buff[2]; 
            cmd_buff[2] <= cmd_buff[1]; 
            cmd_buff[1] <= cmd_buff[0]; 
            cmd_buff[0] <= rxByte;

            if(cmd_buff[3] == 'h21)begin
                if(cmd_buff[2] == 'h4D) 
                    mgu_cmd <= {cmd_buff[1] - 'd30, cmd_buff[0] - 'd30};
                else if(cmd_buff[2] == 'h47)
                    gnu_cmd <= {cmd_buff[1] - 'd30, cmd_buff[0] - 'd30};
            end                
        end
    end

endmodule 

    
