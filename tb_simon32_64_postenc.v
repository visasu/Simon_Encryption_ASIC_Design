// simon32_64 testbench

`timescale 1ns/1ps

module tb_simon32_64();

// Modify params.vh based on Your design and point to Your local directory below
`include "/afs/asu.edu/users/v/s/r/vsriva10/asap7_rundir/Lab5/params.vh"  
  
reg clk_tb, reset_tb;
reg [31:0] plaintext;
reg [63:0] key;
wire [31:0] ciphertext;
integer fh_in, fh_out, index;

simon32_64 dut (
  .plaintext(plaintext),
  .key(key),
  .clk(clk_tb),
  .reset(reset_tb),
  .ciphertext(ciphertext)
);
  
 
initial begin
  fh_in  = $fopen("/afs/asu.edu/class/e/e/e/eee525b/lab5_fall16/simon32_64.inputs", "r");
  fh_out = $fopen("./simon32_64.outputs","w");
end 

// Set intial values and reset the module
initial begin
  clk_tb = 0;
    index = 0;
    reset_tb = 1'b1;
    #20 reset_tb = 1'b0;
end

// skip invalid cycles and start writing outputs
// assumes input and outputs are flopped
always @(negedge clk_tb) begin
	if(index > (2+NumStages)) begin
		$fwrite(fh_out,"%h\n", ciphertext);
	end
end
  
  
// toggle clk at ClkPeriod/2
always #(ClkPeriod/2) clk_tb = ~clk_tb;


always @(posedge clk_tb) begin
	if (reset_tb == 1'b0) begin
		$fscanf(fh_in,"%h %h \n",plaintext, key);
    	
      	index = index+1;
        
    	// ### Added Numstages for the pipelined design ###
      	if ($feof(fh_in) && index==1003+NumStages) begin
        	$fclose(fh_out);
            $fclose(fh_in);
            $finish;
        end
      
	end
end  
 

//##### For generating .vcd.gz for primetime ##########
initial
   begin
     $dumpfile("simon32_64.vcd");
     $dumpvars(0,tb_simon32_64);
   end

endmodule
