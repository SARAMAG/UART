/*
    UART TESTBENCH 
	THIS UART WORKS ON: 
	                  /BAUD RATE 115200
					  /CLK RATE  50MHZ 
					  /NO.OF CLKS PER 1BIT IS 435 
	
*/

 //`timescale 1ns/10ps
 
 `include "UART.v"
 `include "UART_TX.v"
 `include "UART_RX.v"
 module UART_TB ();
 
  parameter clks_PERIOD = 100;
  parameter clk_BIT     = 4;
  parameter BIT_PERIOD  = 43400;
   
  reg  clk ;
  reg  rst ;
  reg  TxEn ; //DATA VALID 
  reg  Rx; //SERIAL 
  wire Tx_Done; //STOP BIT 
  reg [7:0] in_data ;
  wire[7:0]  data ;
  wire      r_Tx;
  wire      RxEn;
  //****************UART TOP******************************************
  UART UART_SIM ( .clk(clk) ,
				  .rst(rst),
				  .TxEn(TxEn),
				  .Rx(Rx)   ,
				  .Tx()   ,
				  .RxEn(RxEn ) ,  
				  .data( data )
				);
  
  
  
  
   //*************** UART TRANSMITTER ********************************
   
  
  UART_TX  
            #( .CLKS_PER_BIT(clk_BIT )) 
    TX_TB (
                  .clk(clk) ,
				  .rst(rst) ,
    	          .Tx()   ,
    	  	  	  .wr_en(TxEn),
    	    	  .TX_Done(TX_Done),
       	    	  .in_data(in_data)
        	                       );
   
   
   
 //***************   UART RECIEVER  ********************************
 
 
 UART_RX 
           #( .CLKS_PER_BIT(clk_BIT )) 
    RX_TB(
               .clk(clk) ,
			   .rst(rst) ,
               .Rx(Rx)   ,
               .R_rdy(RxEn ) ,
               .data( data )
               );
			  
  // GET 1BYTE &SERIALIZE TO OUT PUT 
  task UART_WRITE_BYTE;
    input [7:0]in_data;
    integer    i, K ;
    begin
       
      // SEND START BIT 
      Rx <= 1'b0;
	
    #500;
       
       
      // SEND DATA 
      for (i=0; i<8;i=i+1)
        begin
		
         Rx<= in_data[i];
	     #(clk_BIT );
		 #200;
         
        end
       
      // STOP BIT 
      Rx <= 1'b1;
         #100;
     end
  endtask // UART_WRITE_BYTE
   
     
 //************TEST*********************  
   initial
   begin
      clk=1'b1;  rst=1'b1;  // RESET
      #(clks_PERIOD)  rst=1'b0; 
  end
  
     always
   #(clks_PERIOD/2) clk=~clk;
   
	initial 
	begin 
	            TxEn<=1'b0;  in_data<= 8'b1010_0000;  Rx = 1;//NONE 
//#400	        TxEn<=1'b1;  in_data<= 8'b1010_0000;  Rx = 1;//TRANSMITTER
//#800	        TxEn<=1'b0;  in_data<= 8'b1010_0001;  Rx = 0;//RECIEVER 
//#800	        TxEn<=1'b1;  in_data<= 8'b1010_0001;  Rx = 0;//TRANSMITTER &RECIEVER 

#100	        TxEn<=1'b1;  UART_WRITE_BYTE ( 8'b1010_1001); 
	
	
      
      // CHECK FOR THE CORRECT DATA *BYTE* RECEIVED 
	 
      if (data==in_data )
        $display("Test Passed - Correct Byte Received");
      else
        $display("Test Failed - Incorrect Byte Received");
       
    end
	
	
   
   
endmodule   

   