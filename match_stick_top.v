module match_stick_top (
						input clk,
						input [3:0] dipswitchess,
						input [1:0] pushbuttons,
						output [6:0] display,
						output [3:0] grounds
						);
						
reg [15:0] total;
reg [1:0] state;

wire [1:0] pbs;
assign pbs=pushbuttons;

wire [3:0] ds;
assign ds=dipswitchess;

reg playerNum= 1'd1;

sevensegment ss(.datain(total), .grounds(grounds), .display(display), .clk(clk));

always @(posedge clk)
	begin
		case (state)
			2'b00:
				begin
					if(pbs == 2'b01)
						begin
							state <= 2'b01;
							if(ds > 4'b0000 & ds <  4'b1011)
								begin
									total <= total - ds;
									if(playerNum == 1'd1)
										playerNum <= playerNum+1;
									else
										playerNum <= playerNum+1;
									// total ve player ı yazdır
								end
							else
								begin
									//bu aralıkta değilse ekrana "-" ve player bas
								end
						end
					else if(pbs == 2'b10)
						begin
							state <= 2'b10;
							total <= 16'b0000000001100100;
						end
					else
						begin
							state <= 2'b00;
						end
				end
			2'b01:
				begin
					if(pbs == 2'b10)
						begin
							state <= 2'b10;
						end
					else
						begin
							state <= 2'b01;
						end
				end
			2'b10:
				begin
					state <= 2'b00;		
				end
		endcase
	end

initial
	begin
		total=16'b0000000001100100;
		state=2'b00;
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

