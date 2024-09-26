`timescale 1ns/1ps
module ASYNCH_FIFO_TB ();


parameter PTR_WIDTH_TB=4;
parameter WIDTH_TB=8;
parameter reading_clk_period=25;
parameter writing_clk_period=10;
parameter burst_length=10;
parameter FIFO_MIN_DEPTH=6;



reg                    W_CLK_TB;
reg                    W_RST_TB;
reg                    W_INC_TB;
reg                    R_CLK_TB;
reg                    R_RST_TB;
reg                    R_INC_TB;
reg    [WIDTH_TB-1:0]  WR_DATA_TB;
wire   [WIDTH_TB-1:0]  RD_DATA_TB;
wire                   FULL_TB;
wire                   EMPTY_TB;

//top module instantiation 

ASYNCH_FIFO DUT 
(
.W_CLK(W_CLK_TB),
.W_RST(W_RST_TB),
.W_INC(W_INC_TB),
.R_CLK(R_CLK_TB),
.R_RST(R_RST_TB),
.R_INC(R_INC_TB),
.WR_DATA(WR_DATA_TB),
.RD_DATA(RD_DATA_TB),
.FULL(FULL_TB),
.EMPTY(EMPTY_TB)
);

/*
task set_fifo depth;

begin

end

 endtask
*/

//reading clock generation//
always #(reading_clk_period/2) R_CLK_TB=~R_CLK_TB;
//writing clock generation//
always #(writing_clk_period/2) W_CLK_TB=~W_CLK_TB;

// tasks

task reset_write;
begin 
#(writing_clk_period)
W_RST_TB='b0;
#(writing_clk_period)
W_RST_TB='b1;
#(writing_clk_period);
end
endtask


task reset_read;
begin 
#(reading_clk_period)
R_RST_TB='b0;
#(reading_clk_period)
R_RST_TB='b1;
#(reading_clk_period);
end
endtask


task intialize ;
begin
W_CLK_TB=1'b0;
W_RST_TB=1'b1;
W_INC_TB=1'b0;    //only intializing the inputs
R_CLK_TB=1'b0;
R_RST_TB=1'b1;
R_INC_TB=1'b0;
WR_DATA_TB=8'h00;
end
endtask


task data_writing ;
input  [WIDTH_TB-1:0] data_in; 
begin 
    WR_DATA_TB = data_in;
    W_INC_TB=1'b1;
    #(writing_clk_period)
    W_INC_TB=1'b0;
end
endtask

task data_reading;
begin 
    R_INC_TB=1'b1;
    #(reading_clk_period)
    R_INC_TB=1'b0;
end
endtask


initial
begin 


    intialize (); //intialize the inputs

    reset_write();  //reset the write operation
    reset_read();//reset the write operation

    data_writing(8'hA3);
    data_writing(8'hB4);
    data_writing(8'h1D);
    data_writing(8'hA3);

    // Check for FULL flag
    if (FULL_TB) $display("Test failed: FULL flag should not be set.");
    else $display("Test passed: FULL flag is not set.");

    //reading the inserted data
    repeat (4) begin
        data_reading();
        $display("Read Data: %h", RD_DATA_TB);
    end
    // Check for EMPTY flag
    if (EMPTY_TB) $display("Test passed: EMPTY flag is set after reading all data.");
    else $display("Test failed: EMPTY flag should be set after reading all data.");

    //inserting new data
    data_writing(8'h3A);
    data_writing(8'h2D);
    data_writing(8'h4B);
    data_writing(8'hA5);
    data_writing(8'h22);
    data_writing(8'h3F);
    data_writing(8'h45);
    data_writing(8'h35);
    data_writing(8'h55);

    // Check if FULL flag is set
    if (FULL_TB) $display("Test passed: FULL flag is set on overflow.");
    else $display("Test failed: FULL flag should be set on overflow.");

    reset_write();
    reset_read();

    if (EMPTY_TB) $display("Test passed: FIFO reset correctly, EMPTY flag is set.");
    else $display("Test failed: FIFO reset did not clear correctly.");

    $stop;

end
   
endmodule