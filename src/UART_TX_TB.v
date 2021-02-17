
/*


    TRANSMITTER TESTBENCH  */
	`include "UART_TX.v" 
	   module UART_TX_TB();
	    reg clk;
		reg rst;
		reg wr_en;            //DATA IS VALID ACTIVATE TRANSMITTER 
		reg [7:0] in_data;   // INCOME DATA 
		wire  Tx;       //SERIAL DATA  
		wire    TX_Done; //STOP BIT 
     
  parameter clks_PERIOD = 100;
  parameter clk_BIT     = 4;
  parameter BIT_PERIOD  = 43400;
  
  UART_TX  
            #( .CLKS_PER_BIT(clk_BIT )) 
    TX_TB (
                  .clk(clk) ,
				  .rst(rst) ,
    	          .Tx(Tx)   ,
    	  	  	  .wr_en(wr_en),
    	    	  .TX_Done(TX_Done),
       	    	  .in_data(in_data)
        	                       );
								   
 initial
   begin
                clk=1'b0; rst=1'b1; wr_en<=1'b1; in_data<= 8'b1010_0001;  // RESET
#70  rst=1'b0; 
	  
#4200                                  in_data<= 8'b1010_0000;
	  
  end
    always
   #(clks_PERIOD/2) clk=~clk;

	
	
	
   
    endmodule 
	

