module flip_flop(input clock, input reset, input data_write, input data_init, input data_in, output reg data_out);
	always @ (negedge clock) begin
		if(reset == 1'b1) begin
			data_out = data_init;
		end else if(data_write == 1'b1) begin 
			data_out = data_in; 
		end
	end
endmodule

module register_8bit(input clock, input reset, input data_write, input [7:0] data_init, input [7:0] data_in, output [7:0] data_out);
	genvar i;
	generate 
		for (i = 0; i < 8; i = i + 1) begin : flip_flop
			flip_flop ins(clock, reset, data_write, data_init[i], data_in[i], data_out[i]);
		end
	endgenerate
endmodule

module register_32bit(input clock, input reset, input data_write, input [31:0] data_init, input [31:0] data_in, output [31:0] data_out);
	genvar i;
	generate 
		for (i = 0; i < 32; i = i + 1) begin : flip_flop
			flip_flop ins(clock, reset, data_write, data_init[i], data_in[i], data_out[i]);
		end
	endgenerate
endmodule

module register_48bit(input clock, input reset, input data_write, input [47:0] data_init, input [47:0] data_in, output [47:0] data_out);
	genvar i;
	generate 
		for (i = 0; i < 48; i = i + 1) begin : flip_flop
			flip_flop ins(clock, reset, data_write, data_init[i], data_in[i], data_out[i]);
		end
	endgenerate
endmodule

module register_64bit(input clock, input reset, input data_write, input [63:0] data_init, input [63:0] data_in, output [63:0] data_out);
	genvar i;
	generate 
		for (i = 0; i < 64; i = i + 1) begin : flip_flop
			flip_flop ins(clock, reset, data_write, data_init[i], data_in[i], data_out[i]);
		end
	endgenerate
endmodule

module register_82bit(input clock, input reset, input data_write, input [81:0] data_init, input [81:0] data_in, output [81:0] data_out);
	genvar i;
	generate 
		for (i = 0; i < 82; i = i + 1) begin : flip_flop
			flip_flop ins(clock, reset, data_write, data_init[i], data_in[i], data_out[i]);
		end
	endgenerate
endmodule

module register_216bit(input clock, input reset, input data_write, input [215:0] data_init, input [215:0] data_in, output [215:0] data_out);
	genvar i;
	generate 
		for (i = 0; i < 216; i = i + 1) begin : flip_flop
			flip_flop ins(clock, reset, data_write, data_init[i], data_in[i], data_out[i]);
		end
	endgenerate
endmodule

module mux_2to1_3bits(input selector, input [2:0] mux_in_0, mux_in_1, output reg [2:0] mux_out);
	always @ (selector or mux_in_0 or mux_in_1) begin
		case(selector)
			1'b0: mux_out = mux_in_0;
			1'b1: mux_out = mux_in_1;
		endcase
	end
endmodule

module mux_2to1_32bits(input selector, input [31:0] mux_in_0, mux_in_1, output reg [31:0] mux_out);
	always @ (selector or mux_in_0 or mux_in_1) begin
		case(selector)
			1'b0: mux_out = mux_in_0;
			1'b1: mux_out = mux_in_1;
		endcase
	end
endmodule

module mux_4to1_32bits(input [1:0] selector, input [31:0] mux_in_0, mux_in_1, mux_in_2, mux_in_3, output reg [31:0] mux_out);
	always @ (selector or mux_in_0 or mux_in_1 or mux_in_2 or mux_in_3) begin
		case(selector)
			2'b00: mux_out = mux_in_0;
			2'b01: mux_out = mux_in_1;
			2'b10: mux_out = mux_in_2;
			2'b11: mux_out = mux_in_3;
		endcase
	end
endmodule

module mux_8to1_8bits(input [2:0] selector, input [7:0] mux_in_0, mux_in_1, mux_in_2, mux_in_3, mux_in_4, mux_in_5, mux_in_6, mux_in_7, output reg [7:0] mux_out);
	always @ (selector or mux_in_0 or mux_in_1 or mux_in_2 or mux_in_3, mux_in_4, mux_in_5, mux_in_6, mux_in_7) begin
		case(selector)
			3'b000: mux_out = mux_in_0;
			3'b001: mux_out = mux_in_1;
			3'b010: mux_out = mux_in_2;
			3'b011: mux_out = mux_in_3;
			3'b100: mux_out = mux_in_4;
			3'b101: mux_out = mux_in_5;
			3'b110: mux_out = mux_in_6;
			3'b111: mux_out = mux_in_7;
		endcase
	end
endmodule

module register_file(input clock, input reset, input [1:0] data_write, input [5:0] destination, input [11:0] source, input [63:0] data_in, output [127:0] actual_data_out);
	wire [7:0] destination_bitmap [1:0];
	wire [31:0] data_out [7:0], actual_data_in [7:0];
	reg [31:0] cycle_count;
	initial begin
		cycle_count = 0;
		$monitor("Cycle #%d: RegFile[0-7]: %d %d %d %d %d %d %d %d", cycle_count, data_out[0], data_out[1], data_out[2], data_out[3], data_out[4], data_out[5], data_out[6], data_out[7]);
	end
	always @(negedge clock) begin
		cycle_count = cycle_count + 1;
	end
	assign destination_bitmap[1] = 1 << destination[5:3];
	assign destination_bitmap[0] = 1 << destination[2:0];
	assign actual_data_out = {data_out[source[11:9]], data_out[source[8:6]], data_out[source[5:3]], data_out[source[2:0]]};
	genvar i;
	generate 
		for (i = 0; i < 8; i = i + 1) begin : register_32bit
			mux_2to1_32bits mux_ins(destination_bitmap[1][i], data_in[31:0], data_in[63:32], actual_data_in[i]); // 5:3 or 2:0 based on preference order during same destination
			register_32bit reg_ins(clock, reset, (data_write[0] & destination_bitmap[0][i]) | (data_write[1] & destination_bitmap[1][i]), 32'b0, actual_data_in[i], data_out[i]);
		end
	endgenerate		
endmodule

module adder(input [31:0] a, b, output [31:0] c); assign c = a + b; endmodule
module zero_extender_5to32(input [4:0] in, output [31:0] out); assign out = {27'b0, in}; endmodule
module zero_extender_8to32(input [7:0] in, output [31:0] out); assign out = {24'b0, in}; endmodule
module sign_extender_11to32(input [10:0] in, output [31:0] out); assign out = {{19{in[10]}}, in, 2'b0}; endmodule
module sign_extender_8to32(input [7:0] in, output [31:0] out); assign out = {{22{in[7]}}, in, 2'b0}; endmodule

module control_circuit(input [4:0] op_code_1, op_code_0, output reg mem_read, mem_write, output reg [1:0] reg_write, output reg branch, jump, instr_invalid);
	always @ (op_code_0, op_code_1) begin
	  	case(op_code_1)
	  		5'b00011: begin reg_write[1] = 1'b1; instr_invalid = 1'b0; end
			5'b01000: begin reg_write[1] = 1'b1; instr_invalid = 1'b0; end
	  		5'b00000: begin reg_write[1] = 1'b0; instr_invalid = 1'b0; end
	  		default: begin instr_invalid = 1'b1; end
	  	endcase	
	  	case(op_code_0)
	  		5'b01101: begin mem_read = 1'b1; mem_write = 1'b0; reg_write[0] = 1'b1; branch = 1'b0; jump = 1'b0; instr_invalid = 1'b0; end
	  		5'b01100: begin mem_read = 1'b0; mem_write = 1'b1; reg_write[0] = 1'b0; branch = 1'b0; jump = 1'b0; instr_invalid = 1'b0; end
	  		5'b11100: begin mem_read = 1'b0; mem_write = 1'b0; reg_write[0] = 1'b0; branch = 1'b0; jump = 1'b1; instr_invalid = 1'b0; end
	  		5'b11011: begin mem_read = 1'b0; mem_write = 1'b0; reg_write[0] = 1'b0; branch = 1'b1; jump = 1'b0; instr_invalid = 1'b0; end
	  		5'b00000: begin mem_read = 1'b0; mem_write = 1'b0; reg_write[0] = 1'b0; branch = 1'b0; jump = 1'b0; instr_invalid = 1'b0; end
	  		default: begin instr_invalid = 1'b1; end
	  	endcase	
	end
endmodule

module alu(input [31:0] data_in_1, data_in_0, input [1:0] alu_op, output reg [31:0] data_out, output reg N, Z, C, V);
	initial begin
		N = 1'b0;
		Z = 1'b0;
		C = 1'b0;
		V = 1'b0;
	end
	reg [31:0] data_in_1_neg;
	reg [4:0] bit_out;
	always @ (data_in_0 or data_in_1 or alu_op)
	begin
		case(alu_op)
			2'b00: begin
				{C, data_out} = {1'b0, data_in_0} + {1'b0, data_in_1};
				Z = (data_out == 32'b0);
				V = (data_in_0[31] == data_in_1[31] && data_out[31] != data_in_0[31]);
				N = data_out[31];
			end 2'b01: begin
				{C, data_out} = {1'b0, data_in_0} - {1'b0, data_in_1};
				Z = (data_out == 32'b0);
				N = data_out[31];
				V = (data_in_0[31] < data_in_1[31] && data_out[31] != 1'b0) || (data_in_0[31] > data_in_1[31] && data_out[31] != 1'b1);
			end 2'b10: begin
				data_out = data_in_0 | data_in_1;
				Z = (data_out == 32'b0);
				N = data_out[31];
			end 2'b11: begin
				data_out = {data_in_0, data_in_0} >> data_in_1[4:0];
				if(data_in_1[4:0] > 5'b0) begin
					bit_out = data_in_1[4:0] - 5'b1;
					C = data_in_0[bit_out];
				end
				Z = (data_out == 32'b0);
				N = data_out[31];
			end
		endcase
	end
endmodule

module cache_memory(input clock, input reset, input data_write, input [31:0] address, input [7:0] data_in, output [7:0] data_mux_out);
	wire [7:0] data_out [1023:0];
	wire [1023:0] write_bitmap;
	assign write_bitmap = 1 << address;
	genvar i;
	generate 
		for (i = 0; i < 1024; i = i + 1) begin : register_8bit
			register_8bit ins(clock, reset, data_write & write_bitmap[i], i * 2, data_in, data_out[i]);
		end
	endgenerate
	assign data_mux_out = data_out[address];
endmodule

module cache_block(input clock, input reset, input data_write, input [4:0] offset, input [7:0] data_in, output [7:0] actual_data_out);
	wire [31:0] offset_bitmap;
	wire [7:0] data_out [31:0];
	assign offset_bitmap = 1 << offset; // decoder
	assign actual_data_out = data_out[offset]; // mux
	genvar i;
	generate 
		for (i = 0; i < 32; i = i + 1) begin : register_8bit
			register_8bit ins(clock, reset, data_write & offset_bitmap[i], 8'b0, data_in, data_out[i]);
		end
	endgenerate
endmodule

module cache(input clock, input reset, input active_flag, input data_write, input [31:0] address, input [7:0] data_in, output [7:0] actual_data_out, output reg busy);
	wire [7:0] data_out [15:0], data_mem_out; 
	wire [15:0] active_block_bitmap;
	reg [23:0] tag [15:0];
	reg [15:0] valid;
	reg [7:0] mru, first_in;
	reg [7:0] actual_data_in;
	reg [1:0] state;
	reg [4:0] offset_out;
	reg [3:0] active_block;
	reg [5:0] transferred_count;
	reg [31:0] mem_address;
	//initial $monitor("%d %d %d %d", tag[0], tag[1], tag[2], tag[3]);
	assign actual_data_out = data_out[active_block];
	assign active_block_bitmap = 1 << active_block;
	always @ (address, mru, first_in, state) begin
		if(state == 2'b00)
			active_block = {address[7:5], mru[address[7:5]]};
		else if(state == 2'b01)
			active_block = {address[7:5], ~mru[address[7:5]]};
		else if(state == 2'b10)
			active_block = {address[7:5], first_in[address[7:5]]};
	end
	always @ (state, data_mem_out, transferred_count, address) begin
		if(state == 2'b10) begin
			actual_data_in = data_mem_out;
			offset_out = transferred_count;
			mem_address = {address[31:5], transferred_count[4:0]};
		end else begin
			offset_out = address[4:0];
			actual_data_in = data_in;
			mem_address = address;
		end
	end
	genvar i;
	generate 
		for (i = 0; i < 16; i = i + 1) begin : cache_block
			cache_block ins(clock, reset, (active_flag & (data_write | (state == 2'b10))) & active_block_bitmap[i], offset_out, actual_data_in, data_out[i]);
		end
	endgenerate
	initial begin 
		state = 2'b00;
		mru = 8'b0;
		first_in = 8'b0;
		valid = 16'b0;
		transferred_count = 5'b0;
		busy = 1'b0;
	end
	always @ (negedge clock) begin
		if(active_flag == 1'b1) begin
			case(state)
				2'b00: begin // first check, mru
					transferred_count = 5'b0;
					busy = 1'b1;
					if(valid[active_block] == 1'b0) begin // invalid, first access, mru, therefore: the other is invalid too, insta-fetch
						state = 2'b10;
						transferred_count = 5'b0;
					end else begin
						if(address[31:8] == tag[active_block]) begin // found
							busy = 1'b0;
						end else begin // tag mismatch, check other
							state = 2'b01; 
						end
					end
				end
				2'b01: begin // second check, ~mru
					if(valid[active_block] == 1'b0) begin // miss, switch to first_in and fetch data
						state = 2'b10; 
					end else begin
						if(address[31:8] == tag[active_block]) begin // found
							state = 2'b00;
							mru[active_block[3:1]] <= ~mru[active_block[3:1]];
							busy = 1'b0;
							state = 2'b00;
						end else begin // miss, fetch data
							state = 2'b10; 
						end
					end
				end
				2'b10: begin // fetch time, first_in
					transferred_count = transferred_count + 1;
					if(transferred_count == 6'b100000) begin
						valid[active_block] = 1'b1;
						state = 2'b00;
						mru[active_block[3:1]] = first_in[active_block[3:1]];
						first_in[active_block[3:1]] = ~first_in[active_block[3:1]];
						tag[active_block] = address[31:8];
						busy = 1'b0;
					end
				end
			endcase
		end
	end
	cache_memory mem(clock, reset, data_write & active_flag, mem_address, data_in, data_mem_out);
endmodule

module forwarding(input [3:0] reg_write, input [2:0] source_3, source_2, source_1, source_0, destination_3, destination_2, destination_1, destination_0, output reg [1:0] selector_3, selector_2, selector_1, output reg [2:0] selector_0);
	always @(reg_write, source_3, source_2, source_1, source_0, destination_3, destination_2, destination_1, destination_0) begin
		if (destination_3 == source_2 && reg_write[2])
			selector_3 = 2'b11;
		else if (destination_3 == source_1 && reg_write[1])
			selector_3 = 2'b10;
		else if (destination_3 == source_0 && reg_write[0])
			selector_3 = 2'b01;
		else
			selector_3 = 2'b00;

		if (destination_2 == source_2 && reg_write[2])
			selector_2 = 2'b11;
		else if (destination_2 == source_1 && reg_write[1])
			selector_2 = 2'b10;
		else if (destination_2 == source_0 && reg_write[0])
			selector_2 = 2'b01;
		else
			selector_2 = 2'b00;

		if (destination_1 == source_2 && reg_write[2])
			selector_1 = 2'b11;
		else if (destination_1 == source_1 && reg_write[1])
			selector_1 = 2'b10;
		else if (destination_1 == source_0 && reg_write[0])
			selector_1 = 2'b01;
		else
			selector_1 = 2'b00;

		if (destination_0 == source_3 && reg_write[3])
			selector_0 = 3'b100;
		else if (destination_0 == source_2 && reg_write[2])
			selector_0 = 3'b011;
		else if (destination_0 == source_1 && reg_write[1])
			selector_0 = 3'b010;
		else if (destination_0 == source_0 && reg_write[0])
			selector_0 = 3'b001;
		else
			selector_0 = 3'b000;
	end
endmodule

module hazard_management(input reg_write, input [2:0] source, destination_2, destination_1, destination_0, output reg hazard_flag);
	initial hazard_flag = 1'b0;
	always @ (reg_write, source, destination_2, destination_1, destination_0) 
		if (reg_write && (source == destination_2 || source == destination_1 || source == destination_0))
			hazard_flag = 1'b1;
		else
			hazard_flag = 1'b0;
endmodule

module datapath (input clock, input reset, output [7:0] result_mem, output [31:0] result_alu);
	wire [31:0] if_pc_in, if_pc_out, if_inst_out, if_pc_mux_out, if_pc_adder_out, if_epc_mux_out, if_epc_out;
	wire if_cause_out;

	wire [31:0] id_reg_file_data_out [3:0], id_ls_offset, id_jump_offset, id_branch_offset, id_inst_out, id_pc_out;
	wire [4:0] id_op_code [1:0];
	wire [2:0] id_source [3:0], id_destination [1:0];
	wire [1:0] id_reg_write, ex_reg_write, ex_alu_op;
	wire id_mem_read, id_mem_write, id_branch, id_jump, id_instr_invalid;

	wire [31:0] ex_adder_out, ex_alu_out, ex_data_memory_out, ex_reg_file_data_out [3:0], ex_ls_offset, ex_alu_data_in_1, ex_alu_data_in_0, ex_adder_data_in, ex_pc_out;
	wire [7:0] ex_mem_data_in;
	wire [2:0] ex_destination [1:0], ex_source [3:0], ex_mem_data_in_selector;
	wire [1:0] ex_alu_data_in_0_selector, ex_alu_data_in_1_selector, adder_data_in_selector;
	wire ex_N, ex_Z, ex_C, ex_V, ex_mem_read, ex_mem_write, ex_hazard_flag;

	wire [31:0] mem_alu_out, mem_adder_out;
	wire [7:0] mem_writedata_out, mem_data_memory_out;
	wire [2:0] mem_destination [1:0];
	wire [1:0] mem_reg_write;
	wire mem_mem_read, mem_mem_write, mem_cache_busy;

	wire [31:0] wb_alu_out;
	wire [7:0] wb_data_memory_out;
	wire [2:0] wb_destination [1:0];
	wire [1:0] wb_reg_write;

	assign result_mem = wb_data_memory_out;
	assign result_alu = wb_alu_out;

	register_32bit pc(clock, reset, ~((ex_hazard_flag & ~mem_cache_busy) | mem_cache_busy), 32'b0, if_pc_in, if_pc_out);
	register_32bit epc(clock, reset, id_instr_invalid | ex_V, 32'b0, if_epc_mux_out, if_epc_out);
	mux_2to1_32bits epc_mux(id_instr_invalid, ex_pc_out, id_pc_out, if_epc_mux_out);
	flip_flop cause(clock, reset, id_instr_invalid | ex_V, 1'b0, ~id_instr_invalid, if_cause_out);
	adder pc_adder(if_pc_out, if_pc_mux_out, if_pc_adder_out);
	mux_4to1_32bits pc_mux({(id_branch & ex_alu_out[31]), id_jump}, 32'b100, id_jump_offset, id_branch_offset, 32'b0, if_pc_mux_out);
	mux_2to1_32bits pc_mux_2(id_instr_invalid | ex_V, if_pc_adder_out, 32'b1101100, if_pc_in);
	memory inst_memory(clock, reset, 1'b0, if_pc_out, 32'b0, if_inst_out);
	
	register_64bit IF_ID(clock, id_jump | (id_branch & ex_alu_out[31]) | reset, ~((ex_hazard_flag & ~mem_cache_busy) | mem_cache_busy), 64'b0, {if_inst_out, if_pc_out}, {id_inst_out, id_pc_out});

	assign id_source[3] = id_inst_out[31:29];
	assign id_source[2] = id_inst_out[28:26];
	assign id_source[1] = id_inst_out[15:13];
	assign id_source[0] = id_inst_out[12:10];
	assign id_destination[0] = id_inst_out[12:10];
	assign id_op_code[1] = id_inst_out[20:16];
	assign id_op_code[0] = id_inst_out[4:0];

	mux_2to1_3bits destination_0_mux(id_inst_out[17], id_inst_out[28:26], id_inst_out[25:23], id_destination[1]);
	register_file reg_file(~clock, reset, wb_reg_write, {wb_destination[1], wb_destination[0]}, {id_source[3], id_source[2], id_source[1], id_source[0]}, {wb_alu_out, ex_data_memory_out}, {id_reg_file_data_out[3], id_reg_file_data_out[2], id_reg_file_data_out[1], id_reg_file_data_out[0]});
	zero_extender_5to32 id_ls_offset_extender(id_inst_out[9:5], id_ls_offset);
	zero_extender_8to32 wb_data_memory_out_extender(wb_data_memory_out, ex_data_memory_out);
	sign_extender_11to32 id_jump_offset_extender(id_inst_out[15:5], id_jump_offset);
	sign_extender_8to32 id_branch_offset_extender(id_inst_out[15:8], id_branch_offset);
	control_circuit control(id_op_code[1], id_op_code[0], id_mem_read, id_mem_write, id_reg_write, id_branch, id_jump, id_instr_invalid);
	
	register_216bit ID_EX(clock, reset | ex_V | id_instr_invalid, ~((ex_hazard_flag & ~mem_cache_busy) | mem_cache_busy), 216'b0, {id_reg_file_data_out[3], id_reg_file_data_out[2], id_reg_file_data_out[1], id_reg_file_data_out[0], id_ls_offset, id_inst_out[22:21], id_reg_write, id_mem_read, id_mem_write, id_destination[1], id_destination[0], id_source[3], id_source[2], id_source[1], id_source[0], id_pc_out}, {ex_reg_file_data_out[3], ex_reg_file_data_out[2], ex_reg_file_data_out[1], ex_reg_file_data_out[0], ex_ls_offset, ex_alu_op, ex_reg_write, ex_mem_read, ex_mem_write, ex_destination[1], ex_destination[0], ex_source[3], ex_source[2], ex_source[1], ex_source[0], ex_pc_out});

	forwarding forward({mem_reg_write[0], mem_reg_write[1], wb_reg_write[0], wb_reg_write[1]}, mem_destination[0], mem_destination[1], wb_destination[0], wb_destination[1], ex_source[3], ex_source[2], ex_source[1], ex_source[0], ex_alu_data_in_1_selector, ex_alu_data_in_0_selector, adder_data_in_selector, ex_mem_data_in_selector);

	hazard_management hazard(mem_reg_write[0], mem_destination[0], ex_source[3], ex_source[2], ex_source[1], ex_hazard_flag);

	mux_4to1_32bits alu_data_in_1_mux(ex_alu_data_in_1_selector, ex_reg_file_data_out[3], wb_alu_out, ex_data_memory_out, mem_alu_out, ex_alu_data_in_1);
	mux_4to1_32bits alu_data_in_0_mux(ex_alu_data_in_0_selector, ex_reg_file_data_out[2], wb_alu_out, ex_data_memory_out, mem_alu_out, ex_alu_data_in_0);
	mux_4to1_32bits adder_data_in_mux(adder_data_in_selector, ex_reg_file_data_out[1], wb_alu_out, ex_data_memory_out, mem_alu_out, ex_adder_data_in);
	alu alu_ins(ex_alu_data_in_1, ex_alu_data_in_0, ex_alu_op, ex_alu_out, ex_N, ex_Z, ex_C, ex_V);
	adder adder_ins(ex_adder_data_in, ex_ls_offset, ex_adder_out);
	mux_8to1_8bits ex_mem_data_in_mux(ex_mem_data_in_selector, ex_reg_file_data_out[0][7:0], wb_alu_out[7:0], wb_data_memory_out, mem_alu_out[7:0], mem_data_memory_out, 8'b0, 8'b0, 8'b0, ex_mem_data_in);

	register_82bit EX_MEM(clock, (ex_hazard_flag & ~mem_cache_busy) | ex_V, ~mem_cache_busy, 82'b0, {ex_alu_out, ex_adder_out, ex_reg_write, ex_mem_read, ex_mem_write, ex_destination[1], ex_destination[0], ex_mem_data_in}, {mem_alu_out, mem_adder_out, mem_reg_write, mem_mem_read, mem_mem_write, mem_destination[1], mem_destination[0], mem_writedata_out});
	
	cache cac(~clock, reset, mem_mem_write | mem_mem_read, mem_mem_write, mem_adder_out, mem_writedata_out, mem_data_memory_out, mem_cache_busy);

	register_48bit MEM_WB(clock, mem_cache_busy, 1'b1, 48'b0, {mem_alu_out, mem_data_memory_out, mem_reg_write, mem_destination[1], mem_destination[0]}, {wb_alu_out, wb_data_memory_out, wb_reg_write, wb_destination[1], wb_destination[0]});

endmodule

module memory(input clock, input reset, input data_write, input [31:0] address, input [31:0] data_in, output [31:0] actual_data_out);
	wire [31:0] data_out [63:0];
	wire [31:0] write_bitmap;
	wire [31:0] instruction [63:0];
	assign actual_data_out = data_out[address[6:2]];
	assign write_bitmap = 1 << address[31:2];
	// PRE-LOADED WITH TEST_01
assign instruction[0] = 32'b000_000_110_0000011__000_001_00001_01101; // R[1] = Mem[1]; COLD MISS, 32 cycle stall || R[6] = R[0] + R[0]
assign instruction[1] = 32'b001_010_110_0000011__000_001_00010_01100; // Mem[2] = R[1];	|| R[6] = R[1] + R[2]
assign instruction[2] = 32'b001_000_110_0000011__000_010_00010_01101; // R[2] = Mem[2];	|| R[6] = R[1] + R[0]
assign instruction[3] = 32'b001_010_110_0000011__000_010_00011_01100; // Mem[3] = R[2];	|| R[6] = R[1] + R[2]
assign instruction[4] = 32'b001_010_110_0000011__000_011_00011_01101; // R[3] = Mem[3];	|| R[6] = R[1] + R[2]
assign instruction[5] = 32'b011_010_100_00_00011__000_110_00001_01101; // R[4] = R[2] + R[3]; || R[6] = Mem[1];
assign instruction[6] = 32'b100_010_100_00_00011__000_110_00010_01101; // R[4] = R[2] + R[4]; || R[6] = Mem[2];
assign instruction[7] = 32'b100_100_100_00_00011__000_110_00011_01101; // R[4] = R[4] + R[4]; || R[6] = Mem[3];
assign instruction[8] = 32'b0000000000000000__11111110_000_11011; // branch back 1 instruction
assign instruction[9] = 32'b0000000000000000__0000000000000000;
assign instruction[10] = 32'b0000000000000000__0000000000000000;
assign instruction[11] = 32'b0000000000000000__0000000000000000;
assign instruction[12] = 32'b0000000000000000__0000000000000000;
assign instruction[13] = 32'b0000000000000000__0000000000000000;
assign instruction[14] = 32'b0000000000000000__0000000000000000;
assign instruction[15] = 32'b0000000000000000__0000000000000000;
assign instruction[16] = 32'b0000000000000000__0000000000000000;
assign instruction[17] = 32'b0000000000000000__0000000000000000;
assign instruction[18] = 32'b0000000000000000__0000000000000000;
assign instruction[19] = 32'b0000000000000000__0000000000000000;
assign instruction[20] = 32'b0000000000000000__0000000000000000;
assign instruction[21] = 32'b0000000000000000__0000000000000000;
assign instruction[22] = 32'b0000000000000000__0000000000000000;
assign instruction[23] = 32'b0000000000000000__0000000000000000;
assign instruction[24] = 32'b0000000000000000__0000000000000000;
assign instruction[25] = 32'b0000000000000000__0000000000000000;
assign instruction[26] = 32'b0000000000000000__0000000000000000;
assign instruction[27] = 32'b0000000000000000__000_111_11011_01101; // R[7] = Mem[27]
assign instruction[28] = 32'b0000000000000000__0000000000000000; // R[6] = Mem[54 + 27] COLD MISS! 32 cycle stall
	assign instruction[29] = 32'b0000000000000000__0000000000000000;
	assign instruction[30] = 32'b0000000000000000__0000000000000000;
	assign instruction[31] = 32'b0000000000000000__0000000000000000;
	assign instruction[32] = 32'b0000000000000000__0000000000000000;
	assign instruction[33] = 32'b0000000000000000__0000000000000000;
	assign instruction[34] = 32'b0000000000000000__0000000000000000;
	assign instruction[35] = 32'b0000000000000000__0000000000000000;
	assign instruction[36] = 32'b0000000000000000__0000000000000000;
	assign instruction[37] = 32'b0000000000000000__0000000000000000;
	assign instruction[38] = 32'b0000000000000000__0000000000000000;
	assign instruction[39] = 32'b0000000000000000__0000000000000000;
	assign instruction[40] = 32'b0000000000000000__0000000000000000;
	assign instruction[41] = 32'b0000000000000000__0000000000000000;
	assign instruction[42] = 32'b0000000000000000__0000000000000000;
	assign instruction[43] = 32'b0000000000000000__0000000000000000;
	assign instruction[44] = 32'b0000000000000000__0000000000000000;
	assign instruction[45] = 32'b0000000000000000__0000000000000000;
	assign instruction[46] = 32'b0000000000000000__0000000000000000;
	assign instruction[47] = 32'b0000000000000000__0000000000000000;
	assign instruction[48] = 32'b0000000000000000__0000000000000000;
	assign instruction[49] = 32'b0000000000000000__0000000000000000;
	assign instruction[50] = 32'b0000000000000000__0000000000000000;
	assign instruction[51] = 32'b0000000000000000__0000000000000000;
	assign instruction[52] = 32'b0000000000000000__0000000000000000;
	assign instruction[53] = 32'b0000000000000000__0000000000000000;
	assign instruction[54] = 32'b0000000000000000__0000000000000000;
	assign instruction[55] = 32'b0000000000000000__0000000000000000;
	assign instruction[56] = 32'b0000000000000000__0000000000000000;
	assign instruction[57] = 32'b0000000000000000__0000000000000000;
	assign instruction[58] = 32'b0000000000000000__0000000000000000;
	assign instruction[59] = 32'b0000000000000000__0000000000000000;
	assign instruction[60] = 32'b0000000000000000__0000000000000000;
	assign instruction[61] = 32'b0000000000000000__0000000000000000;
	assign instruction[62] = 32'b0000000000000000__0000000000000000;
	assign instruction[63] = 32'b0000000000000000__0000000000000000;
	genvar i;
	generate 
		for (i = 0; i < 64; i = i + 1) begin : register_32bit
			register_32bit ins(clock, reset, data_write & write_bitmap[i], instruction[i], data_in, data_out[i]);
		end
	endgenerate
endmodule

module datapath_tester();
	reg clock, reset;
	wire [7:0] result_mem;
	wire [31:0] result_alu;
	initial begin
		clock = 1'b0;
		reset = 1'b1;
		#20
		reset = 1'b0;
	end
	datapath greb(clock, reset, result_mem, result_alu);
	always #10 clock <= ~clock;
endmodule

module cache_tester();
	reg clock, reset, active_flag, data_write;
	reg [31:0] address;
	reg [7:0] data_in;
	wire [7:0] data_out;
	wire busy;
	cache greb(clock, reset, active_flag, data_write, address, data_in, data_out, busy);
	initial begin
		clock = 0;
		reset = 1;
		active_flag = 0;
		data_write = 0;
		address = 0;
		data_in = 0;
		#40 
		reset = 0;
		address = 259;
		data_in = 20;
		active_flag = 1;
		#800 
		active_flag = 1;
		address = 10;
		#800 
		active_flag = 1;
		address = 11;
		#20
		active_flag = 1;
		address = 12;
		#20
		active_flag = 1;
		data_write = 1;
		address = 13;
		data_in = 14;
		#20
		active_flag = 1;
		data_write = 1;
		address = 14;
		data_in = 15;
		#20
		active_flag = 1;
		data_write = 0;
		address = 13;
		#20
		active_flag = 1;
		data_write = 0;
		address = 14;
		#20
		active_flag = 1;
		data_write = 1;
		address = 259;
		data_in = 19;
		#40
		active_flag = 1;
		address = 18;
		data_in = 20;
		#40
		active_flag = 1;
		data_write = 0;
		address = 259;
		data_in = 19;
		#40
		active_flag = 1;
		address = 18;
		data_in = 20;
		#40
		active_flag = 1;
		data_write = 1;
		address = 517;
		data_in = 13;
		#800
		active_flag = 1;
		data_write = 0;
		address = 517;
		data_in = 13;
	end
	always #10 clock <= ~clock;
endmodule
