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
    output [2:0] oCmd
);
    reg [7:0] cmd_buff [3:0];  
    wire dv; 

    uart_rx rx(.i_Clock(), 
               .i_Rx_Serial(),
               .o_Rx_DV(),
               .o_Rx_Byte()); 

    //Shift register
    always @ (posedge clk) begin 
        if(dv)
            cmd_buff <= {cmd_buff[2:0], rxByte}; 
    end

endmodule 

    
