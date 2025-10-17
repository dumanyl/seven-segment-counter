`timescale 1ns / 1ps
module seven_segment_controller(
    input wire CLK100MHZ,
    input wire BTNU,   // Increment
    input wire BTND,   // Decrement
    input wire BTNR,   // Reset
    input wire BTNL,   // Load
    input [15:0] SW,   // Switches
    output CA, CB, CC, CD, CE, CF, CG,
    output [7:0] AN
);

    reg [7:0]  segment_state;
    reg [31:0] segment_counter;
    reg [3:0]  routed_vals;
    reg [3:0]  registers [0:3];
    wire [6:0] cat_out;
    reg slowCLK;
    reg [25:0] count = 0;

    always @(posedge CLK100MHZ) begin
        count <= count + 1;
        if (count == 50_000_000) begin
            count <= 0;
            slowCLK <= ~slowCLK;
        end
    end

    binary_to_seven_segment my_converter(
        .bin_in(routed_vals),
        .hex_out(cat_out)
    );

    assign {CA, CB, CC, CD, CE, CF, CG} = cat_out;
    assign AN = ~segment_state;

    initial begin
        segment_state = 8'b00000001;
        segment_counter = 0;
        registers[0] = 0; registers[1] = 0; registers[2] = 0; registers[3] = 0;
    end

    always @(posedge CLK100MHZ) begin
        if (segment_counter >= 100_000) begin
            segment_counter <= 0;
            segment_state <= {segment_state[6:0], segment_state[7]};
        end else segment_counter <= segment_counter + 1;
    end

    always @(posedge slowCLK) begin
        if (BTNR) begin
            registers[0] <= 0; registers[1] <= 0; registers[2] <= 0; registers[3] <= 0;
        end else if (BTNL) begin
            {registers[3], registers[2], registers[1], registers[0]} <= SW;
        end else if (BTNU) begin
            if (registers[0] < 4'hF) registers[0] <= registers[0] + 1;
            else begin
                registers[0] <= 0;
                if (registers[1] < 4'hF) registers[1] <= registers[1] + 1;
                else begin
                    registers[1] <= 0;
                    if (registers[2] < 4'hF) registers[2] <= registers[2] + 1;
                    else begin
                        registers[2] <= 0;
                        if (registers[3] < 4'hF) registers[3] <= registers[3] + 1;
                        else registers[3] <= 0;
                    end
                end
            end
        end else if (BTND) begin
            if (registers[0] > 0) registers[0] <= registers[0] - 1;
            else begin
                registers[0] <= 4'hF;
                if (registers[1] > 0) registers[1] <= registers[1] - 1;
                else begin
                    registers[1] <= 4'hF;
                    if (registers[2] > 0) registers[2] <= registers[2] - 1;
                    else begin
                        registers[2] <= 4'hF;
                        if (registers[3] > 0) registers[3] <= registers[3] - 1;
                        else registers[3] <= 4'hF;
                    end
                end
            end
        end
    end

    always @(posedge CLK100MHZ) begin
        case (segment_state)
            8'b00000001: routed_vals = registers[0];
            8'b00000010: routed_vals = registers[1];
            8'b00000100: routed_vals = registers[2];
            8'b00001000: routed_vals = registers[3];
            default:      routed_vals = 0;
        endcase
    end
endmodule
