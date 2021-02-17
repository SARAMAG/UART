
/* 
   UART TRANSMITTER 
   
   */
   module UART_TX
     #(parameter CLKS_PER_BIT=4) 
   (clk, rst,wr_en, in_data, Tx, TX_Done  );
   
        input clk;
		input rst;
		input wr_en;            //DATA IS VALID ACTIVATE TRANSMITTER 
		input [7:0] in_data;   // INCOME DATA 
		output reg  Tx;       //SERIAL DATA  
		output      TX_Done; //STOP BIT 
   
	parameter STATE_IDLE  = 3'b000;	
    parameter STATE_START = 3'b001;
    parameter STATE_DATA  = 3'b010;
	parameter STATE_STOP  = 3'b011;
	 
	 
	 reg [2:0]  Next_state;
	 reg [2:0] Bit_pos;     //INDEX 
	 reg [7:0] Tx_Data ;
	 reg [7:0] Clock_Count; //BAUD RATE 
     reg       Tx_Done  ;
	
	
 always @(posedge clk )

    begin
	 if (rst) Next_state<=STATE_IDLE;
    else 

     case (Next_state)
  //*************IDLE ******
	      STATE_IDLE:
    		   begin
		        Tx <= 1'b1;   // Drive Line High for Idle      
                Tx_Done <= 1'b0;
                Clock_Count <= 0;
                Bit_pos <= 0;
				
		     if ( wr_en) // CHECK FOR RECEVING DATA FOR TX IS active ?
              begin
             
              Tx_Data   <= in_data;
              Next_state<= STATE_START;
              end
            else
             Next_state <= STATE_IDLE;	
	       end
   //*************START********
         STATE_START:
	       begin
		     Tx <= 1'b0;  //SEND START BIT 0
			  Bit_pos <= 0;
		      // WAIT CLKS_PER_BIT-1 CLK CYCLE FOR START BIT TO FINISH 
            if (Clock_Count < CLKS_PER_BIT-1)
              begin
               Clock_Count <= Clock_Count + 1;
			   Next_state <= STATE_START;
              end
		    else
			  	Next_state <= STATE_DATA;
               
          end
	//***************DATA *************
			   
	   STATE_DATA:
	      begin	 
		
		     Tx <= Tx_Data[Bit_pos];
			  // WAIT CLKS_PER_BIT-1 CLK CYCLE FOR DATA BITS TO FINISH 
			 if (Clock_Count < (CLKS_PER_BIT-1))
              begin
                Clock_Count <= Clock_Count + 1;
			   Next_state <= STATE_DATA;
              end
		     else
              begin
               
                if (Bit_pos < 7) // CHECK FOR ALL DATA TRANSMITTED ?
                  begin
                   Bit_pos <= Bit_pos + 1;
				 Next_state <= STATE_DATA;
                   end
                else
                  begin
                    Bit_pos <= 0;
                    Next_state <= STATE_STOP;
                  end
              end
			 
		end 
		
 //***************STOP*********************
       STATE_STOP:
      	  begin
		   Tx<= 1'b1;
           // WAIT CLKS_PER_BIT-1 CLK CYCLE FOR STOP BIT TO FINISH  
            if (Clock_Count < CLKS_PER_BIT-1)
              begin
                Clock_Count <= Clock_Count + 1;
				 Next_state <= STATE_STOP;
              end
             else
              begin
               Tx_Done <= 1'b1;
      
               Next_state <= STATE_IDLE;
            
               end
          end 
      default :
            Next_state <= STATE_IDLE;
      endcase
      end  

   assign TX_Done = Tx_Done;
   
endmodule //UART_TX