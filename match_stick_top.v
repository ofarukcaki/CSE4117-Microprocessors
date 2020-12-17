module match_stick_top (
						input clk,
						input [3:0] dipswitchess,
						input [1:0] pushbuttons,
						output [6:0] display,
						output [3:0] grounds
						);
						
reg [11:0] total;
reg [11:0] minus;
reg [1:0] state;
assign buttons = {~pushbuttons[0],~pushbuttons[1]};


wire [1:0] pbs;
assign pbs=pushbuttons;

wire [3:0] ds;
assign ds=dipswitchess;

reg [3:0] playerNum= 4'b0001;
reg [15:0] dataModule;

reg [11:0] decimal;

BSD bs(.hex(total), .total(decimal));

sevensegment ss(.datain(dataModule), .grounds(grounds), .display(display), .clk(clk));

always @(posedge clk)
	begin
		case (state)
			2'b00:
				begin
					if(pbs == 2'b01)
						begin							
							if(ds > 4'b0000 & ds <  4'b1011)
								begin
									total <= total - ds;
									// dataModule <= {playerNum[3:0],decimal[11:0]};
									dataModule <= {playerNum[3:0],total[11:0]};
									if(playerNum == 4'b0001)
										playerNum <= 4'b0010;
									else
										playerNum <= 4'b0001;
									// total ve player ı yazdır
									state <= 2'b01;
								end
							else
								begin
									minus <= 12'b000001100101;
									dataModule <= {playerNum[3:0],minus[11:0]};
									state <= 2'b01;
								end
						end
					else if(pbs == 2'b10)
						begin
							state <= 2'b10;
							total <= 12'b000001100100;
						end
					else
						begin
							state <= 2'b00;
						end
				end
			2'b01:
				begin
					if(pbs == 2'b00) 		// pushbutton released
						state <= 2'b00;		// go back first state
					else
						state <= 2'b01;		// stay here
				end
			2'b10:
				begin
					if(pbs == 2'b00)		// pb released
						state <= 2'b00;		// else not mandatory
				end
			default: state <= state;
		endcase
	end

initial
	begin
		total=12'b000001100100;
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

module BSD(
	input [11:0] hex,
	output reg [11:0] total
	);


	reg [3:0] Hundreds;
	reg [3:0] Tens;
	reg [3:0] Ones;

	integer i;

	always @(hex)
	begin
		// set 100's, 10's and 1's to 0
		Hundreds = 4'd0;
		Tens = 4'd0;
		Ones = 4'd0;

		for(i=7; i>=0; i=i-1)
		begin
			// add 3 to columns >= 5
			if(Hundreds >= 5)
				Hundreds = Hundreds + 3;
			if(Tens >= 5)
				Tens = Tens + 3;
			if(Ones >= 5)
				Ones = Ones + 3;

			// shift left one
			Hundreds = Hundreds << 3;
			Hundreds[0] = Tens[3];
			Tens = Tens << 1;
			Tens[0] = Ones[3];
			Ones = Ones << 1;
			Ones[0] = hex[i];

			total = {Hundreds[3:0],Tens[3:0], Ones[3:0]};
		end
	end
endmodule