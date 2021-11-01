//2021-11-1 Yue H
//Bus handshake

module handshake(
input                       clk,             
input                       rstn, 
          
input                       valid_i,
output                      ready_o,
input[3:0]                  data_i,  
             
output                      valid_o,
output reg[3:0]             data_o,              
input                       ready_i       
);

reg full;
wire wr_en;

always @(posedge clk or negedge rstn) begin
  if(~rstn) begin
    data_o<=0;full<=0;
  end
  else if (wr_en == 1'b1) begin
    if (valid_i == 1'b1) begin
     full <= 1 ;
	 data_o <= data_i;
    end
	else begin
	 full<=0;
	 data_o<=data_o;
	end
  end
  else begin
    full <= full;
	data_o<=data_o;
  end
end
  
assign wr_en=~full|ready_i;
assign valid_o=full;
assign ready_o=wr_en;

endmodule






module handshake_tb;
reg clk,rstn,valid_i,ready_i;
reg[3:0] data_i;
wire[3:0] data_o;
wire valid_o,ready_o;

handshake handshake(
                            .clk(clk),
			    .rstn(rstn), 
                            .valid_i(valid_i),
                            .ready_o(ready_o),
                            .data_i(data_i),  
                            .valid_o(valid_o),
                            .data_o(data_o),              
                            .ready_i(ready_i)
							);
							
initial begin
  clk<=0;rstn<=0;
  valid_i<=0;ready_i<=0;
  data_i<=0;
  #17 rstn<=1;
  
  #2000 $stop;
end

always #5 clk=~clk;
always #10 valid_i<=~valid_i;
always #50 data_i<=data_i+1;
always #30 ready_i<=~ready_i;


endmodule