module mc14500 (
    input clk, 
    input rst, 
    input [3:0] i,
    inout io_d,
    output write, 
    output jmp, 
    output rtn, 
    output flg0, 
    output flgf);
    
    wire masked_data;
    reg [3:0] ir; // Input registers. 
    reg ien; 
    reg oen;
    reg skip;
    reg rr;

    // ir == 4'b0000 NOPO: No change in registers. Flag O 
    assign flg0 = (i==4'b0000) ? 1 : 0;
    // ir == 4'b1111 NOPF: No Change in registers. Flag F
    assign flgf = (i==4'b1111) ? 1 : 0;
    // ir == 4'b1101 RTN: Return. RTN FLG, skip instruction. 
    assign rtn = (i==4'b1101) ? 1 : 0;
    // ir == 4'b1100 JMP: Jump. JMP FLG.
    assign jmp = (i==4'b1100) ? 1 : 0;
    // 1000 / 1001: Store, write flag. 
    assign write = (skip==0 && oen==1 && (i==4'b1000 || i==4'b1001)) ? 1 : 0;
    assign io_d = (i == 4'b1000) ? rr:
                  (i == 4'b1001) ? ~rr:
                  1'bz;
    assign masked_data = io_d & ien;

    always@(posedge clk) begin
      // When in rising edge, do calculation. 
      // if rst is on, reset the enviroment. 
      if (rst) begin
          ien <= 0;
          oen <= 0;
          skip <= 0;
          rr <= 0;
      end
      // Input Enable, Read Data. 
      else if (!skip) begin
            case (i)
                // LD
                4'b0001:
                  rr <= masked_data;
                // LDC
                4'b0010:
                  rr <= ~masked_data;
                // AND
                4'b0011:
                  rr <= rr & masked_data;
                // ANDC
                4'b0100:
                  rr <= rr & (~masked_data);
                // OR
                4'b0101:
                  rr <= rr | masked_data;
                // ORC
                4'b0110: 
                  rr <= rr | (~masked_data);
                // XNOR
                4'b0111:
                  rr <= rr ^ masked_data;
                // IEN
                4'b1010:
                  ien <= masked_data;
                // OEN
                4'b1011:
                  oen <= masked_data;
                // SKZ
                4'b1110:
                  skip <= ~(|rr);
            endcase
      end
      else 
        skip <= 0;
    end 
endmodule