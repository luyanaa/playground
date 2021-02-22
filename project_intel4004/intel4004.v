module intel4004 (
    inout [3:0] D,
    output [3:0] CM_RAM,
    output CM_ROM, 
    input TEST,
    input RESET,
    input SYNC, 
    input [2:1] CLOCK
);

reg [3:0] dataBuffer;


endmodule