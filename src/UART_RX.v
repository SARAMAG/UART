
/* 
   UART RECIEVER 
   
  
   */
   module UART_RX 
    #(parameter CLKS_PER_BIT=4 )
	(clk,rst, Rx,R_rdy,data);
   
   
   input   clk,rst;	   						// reset is active low or high ??? ...
   input   Rx;        //SERIAL DATA *START  DATA  STOP * 
   output  R_rdy;    //STOP BIT *DATA IS VALID *
   output  [7:0] data;
     
	parameter STATE_IDLE  = 3'b000;	
    parameter STATE_START = 3'b001;
    parameter STATE_DATA  = 3'b010;
	parameter STATE_STOP  = 3'b011;
	parameter STATE_CLEAN = 3'b100;
	
   
	reg  rdy    ;
    reg [2:0] Next_state;	
    reg [2:0] Bit_POS ;    //DATA INDEX 
	reg [7:0] Clock_Count ; 
    reg [7:0] Rx_data ;
    
   
  always @(posedge clk  )
   begin 
   if (rst) Next_state<=STATE_IDLE;
   else  
   begin
    case (Next_state)
 //***********IDLE***************
       STATE_IDLE:
          begin
                rdy  <= 1'b0;
                Clock_Count <= 0;
                Bit_POS<= 0;
             if (Rx == 1'b0)          //CHECK FOR START BIT 
                Next_state <= STATE_START;  //START BIT IS DETECTED 
            else
               Next_state <= STATE_IDLE;
				
         end
 //*************START********
         STATE_START:
	       begin
	 	rdy  <= 1'b0;
                Bit_POS<= 0;
        	if (Clock_Count == (CLKS_PER_BIT-1))     //MID OF START BIT  
              begin
		Clock_Count <= Clock_Count;
                if (Rx == 1'b0) //CHECK STATR BIT IS LOW 
                    Next_state<= STATE_DATA ;
                 else
                  Next_state <= STATE_IDLE; 
               end
            	else
              begin
                Clock_Count <= Clock_Count + 1;
				Next_state <= STATE_START;
              
               end
          end 
 //***************DATA *************
			   
	  STATE_DATA:
	    begin	
		//rdy <= 1'b0;   
		  // WAIT CLKS_PER_BIT-1 TO SAMPLE THE SERIAL INCOM 
		   if (Clock_Count < (CLKS_PER_BIT-1)/2)
              begin
                Clock_Count <= Clock_Count + 1;
	 	Next_state<= STATE_DATA ;
               end
           else
              begin
                Clock_Count <= 0;
              	Rx_data[Bit_POS] <= Rx; 	// this statment is placed in a vague place ...???
               
                if (Bit_POS< 7)             //RECEVIED ALL?
                   begin
                   Bit_POS <= Bit_POS+ 1;
	    
                   Next_state<= STATE_DATA ;
				
                   end
               else
                  begin
                     Bit_POS  <= 0;
                     Next_state <= STATE_STOP;
                  end
            end
       end 
	   
	  		
 //***************STOP*********************
       STATE_STOP:
      	  begin
		//Bit_POS <= Bit_POS;
		      // WAIT CLKS_PER_BIT-1 CLK CYCLE FOR STOP BIT TO FINISH  
            if (Clock_Count < CLKS_PER_BIT-1)
              begin
                Clock_Count <= Clock_Count + 1;
				Next_state<= STATE_STOP;
			//rdy <= rdy;
                end
            else
              begin
                 rdy <= 1'b1;  //STOP BIT 1
		Clock_Count <= 0;
               Next_state<=STATE_CLEAN;
              end
          end 
 //*****CLEAN RECEVIER ************
       STATE_CLEAN :
          begin
             rdy <= 1'b0; 
			Next_state <= STATE_IDLE;
          end
         
       default :
            Next_state<= STATE_IDLE;
    endcase
	end
   end    
   
   assign  R_rdy = rdy;
   assign data = Rx_data;
   
endmodule // UART_RX
   