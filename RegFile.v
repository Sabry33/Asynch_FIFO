
module RegFile #(parameter DATA_WIDTH = 8, PTR_SIZE = 4 ) 

(
input wire                  wclk,
input wire                  wrst_n,
input wire                  wrclken,
input reg [PTR_SIZE-2:0]   waddr,
input reg [PTR_SIZE-2:0]   raddr,
input wire [DATA_WIDTH-1:0] WrData,
output  wire [DATA_WIDTH-1:0] RdData
);

integer I ; 
localparam mem_depth = 1<<(PTR_SIZE-1);
  

reg [DATA_WIDTH-1:0] regArr [mem_depth-1:0] ;    

always @(posedge wclk or negedge wrst_n)
 begin
   if(!wrst_n)  
    begin
      for (I=0 ; I < mem_depth ; I = I +1)
        begin
          regArr[I] <= 0 ;
        end
     end
   else if (wrclken) 
     begin
      regArr[waddr] <= WrData ;
     end       
  end

assign RdData = regArr[raddr];



endmodule


