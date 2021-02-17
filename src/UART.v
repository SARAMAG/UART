/*
    UART TOP MODULE 
	*/
	
	
  module UART(clk,rst,TxEn,Rx,Tx,RxEn, data );
  
     input  clk;  //CLOCK 
	 input  rst;  //RESET
	 input  TxEn; //DATA IS VALID *ACTIVATE TRANSMITTER * //OUTCOME INTERRUPT// 
     input  Rx;   //SERIAL INPUT FOR RECIEVER 
	 output Tx;   //SERIAL OUT OF TRANSMITER
	 output RxEn; //RECIEVER IS DONE AND DATA VALID //SEND INTERRUPT //
     output  [7:0] data; //RECEIVED DATA 
	 
	 
		
   
      wire [7:0]  Tx_Data;   //DATA TO TRANSMIT
      wire        TxDone ;   //STOP BIT *TRANSMISION IS DONE *
	 
	  

	  
   
   
   //*************** UART TRANSMITTER ********************************
   
   
  UART_TX  TX(
                  .clk(clk) ,
				  .rst(rst) ,
    	          .Tx(Tx)   ,
    	  	  	  .wr_en(TxEn),
    	    	  .TX_Done(TxDone),
       	    	  .in_data(Tx_Data)
        	   	
         
                      );
  //***************   UART RECIEVER  ********************************
 
 
 UART_RX  RX(
               .clk(clk) ,
			   .rst(rst) ,
               .Rx(Rx)   ,
               .R_rdy(RxEn) ,
               .data(data )
                );
   
   
endmodule
   
	