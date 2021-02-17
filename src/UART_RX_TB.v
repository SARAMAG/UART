
/* 
   UART RECIEVER _TESTBENCH
   
  
   */
   `include "UART_RX.v"
   module UART_RX_TB();
   
  parameter clks_PERIOD = 100;
  parameter clk_BIT     = 4;
  parameter BIT_PERIOD  = 43400;
     reg clk,rst;
     reg   Rx;        //SERIAL DATA *START BIT TO STOP * 
    wire   R_rdy;    //STOP BIT *DATA VALID *
    wire   [7:0] data;
   
   
 UART_RX  
           #( .CLKS_PER_BIT(clk_BIT )) 
    RX_TB(
               .clk(clk) ,
			   .rst(rst) ,
               .Rx(Rx)   ,
               .R_rdy(R_rdy ) ,
               .data(data)
                );
   
 initial
   begin
  
                clk =1'b0; rst=1'b1;  Rx=1'b0;  
#70  rst=1'b0; 
#420                                  Rx=1'b1; //STOP WORKING 
#400                                   Rx=1'b0; //RECEIVE 
	end             
		
  
    always
   #(clks_PERIOD/2) clk=~clk;
   
   endmodule 