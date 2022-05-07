//create module 
module Brobot(input wire clk, input wire KEY0, input wire ADC_SDO, 
			     output wire H3D0, output wire H3D5, output wire H3D4, output wire H3D6, 
				  output wire H2D5, output wire H2D4, output wire H1D2, output wire H1D1, 
				  output wire H1D0, output wire H1D5, output wire H1D4,
				  output wire GPIO0, output wire GPIO1, output wire GPIO2, output wire GPIO3,
				  output reg ADC_CONVST, output reg ADC_SDI, output wire ADC_SCK);
				  
	//count for ADC clock
	reg [3:0] ADC_CNT;
	
	//count for general clock
	reg [64:0] cnt;
	
	//motor direction flags
	reg start_motors;
	reg forward;
	wire is_turning;
	
	//virtual sensor data to demonstrate motor outputs
	reg sensor_data_inches;
	
	//analog port to be read
	reg ADD0;
	reg ADD1;
	reg ADD2;
	
	//data read from ADC port
	reg [11:0] analog_data;
	reg [11:0] temp_analog_data;
	
	initial begin
		ADC_CNT <= 4'd0;
		ADC_CONVST <= 1;
		cnt <= 64'h0000000000000000;
		start_motors <= 1'b0;
		forward <= 1'b1;
		is_turning <= 1'b1;
		
		ADD0 <= 0;
		ADD1 <= 2;
		ADD2 <= 0;
		
		clock_out <= 0;
		analog_data <= 12'd0;
		temp_analog_data <= 12'd0;
		
		sensor_data_inches <= 12;
	end
	
	always @(posedge KEY0) begin
		start_motors <= !start_motors;
	end
	
	always @(posedge clk) begin
		cnt <= cnt + 1;
		
		//this block should not be here if read sensor data is functional
		if(sensor_data_inches == 12) begin
			if(cnt[26:0] == 27'b000000000000000000000000000) begin
				sensor_data_inches <= 6;
			end
		end
		else begin
			if(cnt[24:0] == 25'b0000000000000000000000000) begin
				sensor_data_inches <= 12;
			end
		end
	end
	
	always @(negedge clk) begin
		ADC_CNT <= ADC_CNT + 4'd1;
		
		//start the conversion at one clock cycle (CONVST is low triggered)
		if(ADC_CNT == 1) begin
			ADC_CONVST <= 0;
		end
	end
	
	//set input signal with channel number
	always @(posedge clk) begin
		if(ADC_CNT == 3) begin
			ADC_SDI <= ADD2;
		end
		else if(ADC_CNT == 4) begin
			ADC_SDI <= ADD1;
		end
		else if(ADC_CNT == 5) begin
			ADC_SDI <= ADD0;
		end
	end
	
	//collect output signal (which is the port's data)
	always @(posedge clk) begin
		if(ADC_CNT == 4) begin analog_data <= temp_analog_data; end
		if(ADC_CNT == 5) begin temp_analog_data[11] <= ADC_SDO; end
		if(ADC_CNT == 6) begin temp_analog_data[10] <= ADC_SDO; end
		if(ADC_CNT == 7) begin temp_analog_data[9] <= ADC_SDO; end
		if(ADC_CNT == 8) begin temp_analog_data[8] <= ADC_SDO; end
		if(ADC_CNT == 9) begin temp_analog_data[7] <= ADC_SDO; end
		if(ADC_CNT == 10) begin temp_analog_data[6] <= ADC_SDO; end
		if(ADC_CNT == 11) begin temp_analog_data[5] <= ADC_SDO; end
		if(ADC_CNT == 12) begin temp_analog_data[4] <= ADC_SDO; end
		if(ADC_CNT == 13) begin temp_analog_data[3] <= ADC_SDO; end
		if(ADC_CNT == 14) begin temp_analog_data[2] <= ADC_SDO; end
		if(ADC_CNT == 15) begin temp_analog_data[1] <= ADC_SDO; end
		if(ADC_CNT == 16) begin temp_analog_data[0] <= ADC_SDO; end
	end
	
	//start the clock once conversion starts
	assign ADC_SCK = (ADC_CONVST)? 1 : clk;
	
	//assign motor control signals
	assign GPIO0 = start_motors & forward;
	assign GPIO1 = start_motors & (!forward);
	assign GPIO2 = (is_turning)? (0) : (start_motors & forward);
	assign GPIO3 = (is_turning)? (0) : (start_motors & (!forward));
	assign is_turning = sensor_data_inches <= 6;
	//assign is_turning = analog_data <= 6;
	
	//FIN
	assign H3D0 = 0;
	assign H3D5 = 0;
	assign H3D4 = 0;
	assign H3D6 = 0;
	assign H2D5 = 0;
	assign H2D4 = 0;
	assign H1D2 = 0;
	assign H1D1 = 0;
	assign H1D0 = 0;
	assign H1D5 = 0;
	assign H1D4 = 0;
endmodule
