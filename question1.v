//Reptile design with 8 Registers. 
// This module also sents register #0 to main module as an output


module reptile (
					input clk,
					input [15:0] data_in,
					output [15:0] data_out,
					output reg [11:0] address,
					output memwt,
					output [15:0] reg0
					);
 
    reg [11:0] pc, ir; //program counter, instruction register
 
    reg [4:0]  state; //FSM
	 reg [15:0] regbank [7:0];//registers 
    reg zeroflag; //zero flag register
	 reg [15:0] result; //output for result
 
 
     localparam   FETCH=4'b0000,
                  LDI=4'b0001, 
                  LD=4'b0010,
                  ST=4'b0011,
                  JZ=4'b0100,
                  JMP=4'b0101,
                  ALU=4'b0111;
 
	 
    wire zeroresult; //zeroflag value 
 
    always @(posedge clk)
        case(state)
 
            FETCH: 
            begin
                if ( data_in[15:12]==JZ) // if instruction is jz  
                    if (zeroflag)  //and if last bit of 7th register is 0 then jump to jump instruction state
                        state <= JMP;
                    else
                        state <= FETCH; //stay here to catch next instruction
                else
                    state <= data_in[15:12]; //read instruction opcode and jump the state of the instruction to be read
                ir<=data_in[11:0]; //read instruction details into instruction register
                pc<=pc+1; //increment program counter
            end
 
            LDI:
            begin
                regbank[ ir[2:0] ] <= data_in; //if inst is LDI get the destination register number from ir and move the data in it.
                pc<=pc+1; //for next instruction (32 bit instruction)  
                state <= FETCH;
            end
 
             LD:
                begin
                    regbank[ir[2:0]] <= data_in;
                    state <= FETCH;  
                end 
 
            ST:
                begin
						  state <= FETCH;  
                end    
 
            JMP:
                begin
                    pc <= pc+ir;
                    state <= FETCH;  
                end          
 
            ALU:
                begin
                    regbank[ir[2:0]]<=result;
                    zeroflag<=zeroresult;
                    state <= FETCH;
                end
 
        endcase
 
 
 
    always @*   
        case (state)
            LD:      address=regbank[ir[5:3]][11:0];
            ST:      address=regbank[ir[5:3]][11:0];
            default: address=pc;
         endcase
 
 
 assign memwt=(state==ST);
 
 assign data_out = regbank[ir[8:6]];
    always @*
        case (ir[11:9])
            3'h0: result = regbank[ir[8:6]]+regbank[ir[5:3]]; //000
            3'h1: result = regbank[ir[8:6]]-regbank[ir[5:3]]; //001
            3'h2: result = regbank[ir[8:6]]&regbank[ir[5:3]]; //010
            3'h3: result = regbank[ir[8:6]]|regbank[ir[5:3]]; //011
            3'h4: result = regbank[ir[8:6]]^regbank[ir[5:3]]; //100
            3'h7: case (ir[8:6])
                        3'h0: result = !regbank[ir[5:3]];
                        3'h1: result = regbank[ir[5:3]];
                        3'h2: result = regbank[ir[5:3]]+1;
                        3'h3: result = regbank[ir[5:3]]-1;
                        default: result=16'h0000;
                    endcase
            default: result=16'h0000;
        endcase
 
   assign zeroresult = ~|result;

	assign reg0=regbank[0];
    initial begin;
            state=FETCH;
				zeroflag=0;
				pc=0;
            end                        
endmodule

module sevensegment(datain, grounds, display, clk);

	input wire [15:0] datain;
	output reg [3:0] grounds;
	output reg [6:0] display;
	input clk;
	
	reg [3:0] data [3:0];
	reg [1:0] count;
	reg [25:0] clk1;
	
	always @(posedge clk1[15])
		begin
			grounds <= {grounds[2:0],grounds[3]};
			count <= count + 1;
		end
	
	always @(posedge clk)
		clk1 <= clk1 + 1;
	
	always @(*)
		case(data[count])	
			0:display=7'b1111110; //starts with a, ends with g
         1:display=7'b0110000;
         2:display=7'b1101101;
         3:display=7'b1111001;
         4:display=7'b0110011;
         5:display=7'b1011011;
         6:display=7'b1011111;
         7:display=7'b1110000;
         8:display=7'b1111111;
         9:display=7'b1111011;
        'ha:display=7'b1110111;
        'hb:display=7'b0011111;
        'hc:display=7'b1001110;
        'hd:display=7'b0111101;
        'he:display=7'b1001111;
        'hf:display=7'b1000111;
        default display=7'b1111111;
		endcase
	
	always @*
		begin
			data[0] = datain[15:12];
			data[1] = datain[11:8];
			data[2] = datain[7:4];
			data[3] = datain[3:0];
		end
	
	initial begin		
		count = 2'b0;
		grounds = 4'b1110;
		clk1 = 0;
	end
endmodule


//This module sents Register #0 to seven segment display 

module question1 (grounds, display, clk, led);
    output  [3:0] grounds;
    output  [6:0] display;
    input   clk; 
    output led;
 
    //  memory chip
    reg     [15:0] memory [0:127]; 
 
    // cpu's input-output pins
    wire     [11:0] pc; //for debugging
    wire     [15:0] data_out;
    wire     [15:0] data_in;
    wire     [11:0] address;
    wire     memwt;
 
    wire     [15:0] reg0;
 
 assign led=memwt; //check memory write signal works or not. For debugging 
 
    //instantiation of cpu
	 reptile rr1 (.data_in(data_in), .data_out(data_out), .clk(clk), .memwt(memwt), .address(address),.reg0(reg0));
	 
	 //instantiation of seven segment
    sevensegment ss1 (.grounds(grounds), .display(display), .clk(clk),  .datain(reg0));
    
 
    assign data_in=memory[address];
    
	 always @(posedge clk)
		if (memwt==1)
			memory[address]<=data_out;
	
	
    initial begin
		$readmemh("ram.dat", memory);
    end
 
endmodule
