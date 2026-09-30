interface dec_if #(parameter int WIDTH = 32);
logic regwrite;
logic memread;
logic memwrite;
logic alusrc;
logic branch;
logic jump;
logic [3:0] aluop;
modport dec(
output regwrite, memread, memwrite, alusrc, branch, jump,aluop);
 modport ctrl(
        input regwrite,
        input memread,
        input memwrite,
        input alusrc,
        input branch,
        input jump,
        input aluop
    );
endinterface

module decoder(
immgen_if.in_dec inp,
dec_if.dec dc,
regmem.dec rdc);
logic [6:0] opcode;
logic [2:0] funct3;
logic [6:0] funct7;
always_comb begin
 rdc.rs1 = inp.instr[19:15];
 rdc.rs2 = inp.instr[24:20];
 rdc.rd = inp.instr[11:7];
 opcode = inp.instr[6:0];
 funct3 = inp.instr[14:12];
 funct7 = inp.instr[31:25];
case(opcode)
'0010011 : begin
               if(funct3 == '0)begin
               dc.regwrite = '1;
               dc.memread = '0;
               dc.memwrite = '0;
               dc.alusrc = '1;
               dc.branch = '0;
               dc.jump = '0;
               dc.aluop = '0000;
               end
               else if(funct3 == '111)begin 
               dc.regwrite = '1;
               dc.memread = '0;
               dc.memwrite = '0;
               dc.alusrc = '1;
               dc.branch = '0;
               dc.jump = '0;
               dc.aluop = '0010;
               end
            else if(funct3 == '110)begin
               dc.regwrite = '1;
               dc.memread = '0;
               dc.memwrite = '0;
               dc.alusrc = '1;
               dc.branch = '0;
               dc.jump = '0;
               dc.aluop = '0011;
            end
           else if(funct3 == '100)begin
               dc.regwrite = '1;
               dc.memread = '0;
               dc.memwrite = '0;
               dc.alusrc = '1;
               dc.branch = '0;
               dc.jump = '0;
               dc.aluop = '0100;
               end  
       end 



'0110011 : begin
           if(funct3 == '000 && funct7 == '0000000)begin 
               dc.regwrite = '1;
               dc.memread = '0;
               dc.memwrite = '0;
               dc.alusrc = '0;
               dc.branch = '0;
               dc.jump = '0;
               dc.aluop = '0000;
               end
              else if(funct3 == '000 && funct7 == '0100000)begin 
               dc.regwrite = '1;
               dc.memread = '0;
               dc.memwrite = '0;
               dc.alusrc = '0;
               dc.branch = '0;
               dc.jump = '0;
               dc.aluop = '0001;
               end
              else if(funct3 == '111)begin 
               dc.regwrite = '1;
               dc.memread = '0;
               dc.memwrite = '0;
               dc.alusrc = '0;
               dc.branch = '0;
               dc.jump = '0;
               dc.aluop = '0010;
               end
              else if(funct3 == '110)begin 
               dc.regwrite = '1;
               dc.memread = '0;
               dc.memwrite = '0;
               dc.alusrc = '0;
               dc.branch = '0;
               dc.jump = '0;
               dc.aluop = '0011;
               end
              else if(funct3 == '100)begin 
               dc.regwrite = '1;
               dc.memread = '0;
               dc.memwrite = '0;
               dc.alusrc = '0;
               dc.branch = '0;
               dc.jump = '0;
               dc.aluop = '0100;
               end
              else if(funct3 == '001)begin 
               dc.regwrite = '1;
               dc.memread = '0;
               dc.memwrite = '0;
               dc.alusrc = '0;
               dc.branch = '0;
               dc.jump = '0;
               dc.aluop = '0101;
               end
              else if(funct3 == '101 && funct7 == '0000000)begin 
               dc.regwrite = '1;
               dc.memread = '0;
               dc.memwrite = '0;
               dc.alusrc = '0;
               dc.branch = '0;
               dc.jump = '0;
               dc.aluop = '0110;
               end
              else if(funct3 == '101 && funct7 == '0100000)begin 
               dc.regwrite = '1;
               dc.memread = '0;
               dc.memwrite = '0;
               dc.alusrc = '0;
               dc.branch = '0;
               dc.jump = '0;
               dc.aluop = '0111;
               end

end

 default : begin
               dc.regwrite = '0;
               dc.memread = '0;
               dc.memwrite = '0;
               dc.alusrc = '0;
               dc.branch = '0;
               dc.jump = '0;
               dc.aluop = '0000;
               end  
endcase


end
endmodule


