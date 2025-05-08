module filt (
  input Clock, Reset,  //system clock and reset
  input FILTER,		   // FILTER signal
  input BitIn,		   // whenever this is high , there is a bit which goes to the buffer
  output logic [15:0] Dout, //output 16 bit filtered 
  output logic Push   //Flag when the output is valid
);
  
  
//Internal registers
  logic [511:0] buffer_1_q, buffer_2_q;
  
  
//Next state registers
  logic [511:0] buffer_1_d, buffer_2_d;
  

//combinational block
  always_comb begin
    buffer_1_d = {BitIn, buffer_1_q[511:1]};
    buffer_2_d = {FILTER ? buffer_1_q : buffer_2_q};    
  end
  
//Sequential block
  always@(posedge Clock or negedge Reset)begin
    if (Reset) begin
      buffer_1_q <= 512'd0;		//on reset 0
      buffer_2_q <= 512'd0;		// ----
    end
    else
      begin
      buffer_1_q <= buffer_1_d;  //update the register with latest value
      buffer_2_q <= buffer_2_d;	 //update the register with latest value
        
      end
  end
endmodule
  
  
