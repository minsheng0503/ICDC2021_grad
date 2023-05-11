`define CLK clk
`define RST reset

//synopsys translate_off
`include "DW_sqrt.v"
//synopsys translate_on

module geofence ( clk,reset,X,Y,R,valid,is_inside);
input clk;
input reset;
input [9:0] X;
input [9:0] Y;
input [10:0] R;
output reg valid;
output reg is_inside;

reg [4:0] cs , ns;
reg [2:0] counter;
reg signed [10:0] X_reg [5:0];
reg signed [10:0] Y_reg [5:0];
reg signed [10:0] R_reg [5:0];
reg signed [23:0] global_a;
reg signed [11:0] global_r;
reg signed [23:0] a_temp1;
reg signed [11:0] a_temp2;
reg signed [11:0] a;
reg signed [11:0] s;
wire signed [23:0] tri_area_mul1;
reg signed [23:0] tri_area_mul2;
reg signed [11:0] tri_area_sqrt1;
wire signed [11:0] tri_area_sqrt2;
reg signed [26:0] tri_area;
reg signed [26:0] hex_area_temp1;
reg signed [26:0] hex_area_temp2;
reg signed [26:0] hex_area_temp3;
reg signed [26:0] hex_area_temp4;
reg signed [26:0] hex_area_temp5;
reg signed [26:0] hex_area_temp6;
reg signed [26:0] hex_area;

localparam start = 0 , store = 1 , sort1 = 2 , sort2 = 3 , sort3 = 4 , sort4 = 5 , sort5 = 6 , count_s1 = 7 , count_s1_area = 8;
localparam count_s2 = 9 , count_s2_area = 10 , count_s3 = 11 , count_s3_area = 12 , count_s4 = 13 , count_s4_area = 14 , count_s5 = 15 , count_s5_area = 16 , count_s6 = 17 , count_s6_area = 18;
localparam finish = 19 , sort1_1 = 20 , sort2_2 = 21 , sort3_3 = 22 , sort4_4 = 23 , sort5_5 = 24;


DW_sqrt #(24, 1) U1 (.a(global_a), .root(global_r));
DW_sqrt #(24, 1) U2 (.a(tri_area_mul2), .root(tri_area_sqrt2));

always @(*) begin
    case (ns) //synopsys parallel_case
        count_s1 : global_a = a_temp1;
        count_s2 : global_a = a_temp1;
        count_s3 : global_a = a_temp1;
        count_s4 : global_a = a_temp1;
        count_s5 : global_a = a_temp1;
        count_s6 : global_a = a_temp1;
        count_s1_area : global_a = tri_area_mul1;
        count_s2_area : global_a = tri_area_mul1;
        count_s3_area : global_a = tri_area_mul1;
        count_s4_area : global_a = tri_area_mul1;
        count_s5_area : global_a = tri_area_mul1;
        count_s6_area : global_a = tri_area_mul1;
        default : global_a = 24'dx;
    endcase
end

always @(*) begin
    case (ns) //synopsys parallel_case
        count_s1 : a_temp2 = global_r;
        count_s2 : a_temp2 = global_r;
        count_s3 : a_temp2 = global_r;
        count_s4 : a_temp2 = global_r;
        count_s5 : a_temp2 = global_r;
        count_s6 : a_temp2 = global_r;
        default : a_temp2 = 12'dx;
    endcase
end

always @(*) begin
    case (ns)
        count_s1_area : tri_area_sqrt1 = global_r;
        count_s2_area : tri_area_sqrt1 = global_r;
        count_s3_area : tri_area_sqrt1 = global_r;
        count_s4_area : tri_area_sqrt1 = global_r;
        count_s5_area : tri_area_sqrt1 = global_r;
        count_s6_area : tri_area_sqrt1 = global_r;
        default : tri_area_sqrt1 = 12'dx;
    endcase
end

always @(posedge `CLK or posedge `RST) begin
    if (reset) begin
        cs <= 5'd0;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs) //synopsys parallel_case
        start : ns = store;
        store : ns = counter == 3'd6 ? sort1 : store;
        sort1 : ns = sort1_1;
        sort1_1 : ns = sort2;
        sort2 : ns = sort2_2;
        sort2_2 : ns = sort3;
        sort3 : ns = sort3_3;
        sort3_3 : ns = sort4;
        sort4 : ns = sort4_4;
        sort4_4 : ns = sort5;
        sort5 : ns = sort5_5;
        sort5_5 : ns = count_s1;
        count_s1 : ns = count_s1_area;
        count_s1_area : ns = count_s2;
        count_s2 : ns = count_s2_area;
        count_s2_area : ns = count_s3;
        count_s3 : ns = count_s3_area;
        count_s3_area : ns = count_s4;
        count_s4 : ns = count_s4_area;
        count_s4_area : ns = count_s5;
        count_s5 : ns = count_s5_area;
        count_s5_area : ns = count_s6;
        count_s6 : ns = count_s6_area;
        count_s6_area : ns = finish;
        finish : ns = start;
        default : ns = 5'dx;
    endcase
end

always @(posedge `CLK or posedge `RST) begin
    if (reset) begin
        counter <= 3'd0;
    end
    else if (ns == start) begin
        counter <= 3'd0;
    end
    else if (ns == store) begin
        counter <= counter + 1'b1;
    end
end

always @(posedge `CLK or posedge `RST) begin
    if (reset) begin
        {R_reg[0] , Y_reg[0] , X_reg[0]} <= 22'd0;
        {R_reg[1] , Y_reg[1] , X_reg[1]} <= 22'd0;
        {R_reg[2] , Y_reg[2] , X_reg[2]} <= 22'd0;
        {R_reg[3] , Y_reg[3] , X_reg[3]} <= 22'd0;
        {R_reg[4] , Y_reg[4] , X_reg[4]} <= 22'd0;
        {R_reg[5] , Y_reg[5] , X_reg[5]} <= 22'd0;
    end
    else if (ns == store) begin
        {R_reg[0] , Y_reg[0] , X_reg[0]} <= {R , 1'b0 , Y , 1'b0 , X};
        {R_reg[1] , Y_reg[1] , X_reg[1]} <= {R_reg[0] , Y_reg[0] , X_reg[0]};
        {R_reg[2] , Y_reg[2] , X_reg[2]} <= {R_reg[1] , Y_reg[1] , X_reg[1]};
        {R_reg[3] , Y_reg[3] , X_reg[3]} <= {R_reg[2] , Y_reg[2] , X_reg[2]};
        {R_reg[4] , Y_reg[4] , X_reg[4]} <= {R_reg[3] , Y_reg[3] , X_reg[3]};
        {R_reg[5] , Y_reg[5] , X_reg[5]} <= {R_reg[4] , Y_reg[4] , X_reg[4]};
    end
    else if (ns == sort1 || ns == sort3 || ns == sort5) begin
        {R_reg[1] , Y_reg[1] , X_reg[1]} <= ((X_reg[1] - X_reg[0]) * (Y_reg[2] - Y_reg[0]) - (X_reg[2] - X_reg[0]) * (Y_reg[1] - Y_reg[0])) < 0 ? {R_reg[2] , Y_reg[2] , X_reg[2]} : {R_reg[1] , Y_reg[1] , X_reg[1]};
        {R_reg[2] , Y_reg[2] , X_reg[2]} <= ((X_reg[1] - X_reg[0]) * (Y_reg[2] - Y_reg[0]) - (X_reg[2] - X_reg[0]) * (Y_reg[1] - Y_reg[0])) < 0 ? {R_reg[1] , Y_reg[1] , X_reg[1]} : {R_reg[2] , Y_reg[2] , X_reg[2]};
    end
    else if (ns == sort1_1 || ns == sort3_3 || ns == sort5_5) begin
        {R_reg[3] , Y_reg[3] , X_reg[3]} <= ((X_reg[3] - X_reg[0]) * (Y_reg[4] - Y_reg[0]) - (X_reg[4] - X_reg[0]) * (Y_reg[3] - Y_reg[0])) < 0 ? {R_reg[4] , Y_reg[4] , X_reg[4]} : {R_reg[3] , Y_reg[3] , X_reg[3]};
        {R_reg[4] , Y_reg[4] , X_reg[4]} <= ((X_reg[3] - X_reg[0]) * (Y_reg[4] - Y_reg[0]) - (X_reg[4] - X_reg[0]) * (Y_reg[3] - Y_reg[0])) < 0 ? {R_reg[3] , Y_reg[3] , X_reg[3]} : {R_reg[4] , Y_reg[4] , X_reg[4]};
    end
    else if (ns == sort2 || ns == sort4) begin
        {R_reg[2] , Y_reg[2] , X_reg[2]} <= ((X_reg[2] - X_reg[0]) * (Y_reg[3] - Y_reg[0]) - (X_reg[3] - X_reg[0]) * (Y_reg[2] - Y_reg[0])) < 0 ? {R_reg[3] , Y_reg[3] , X_reg[3]} : {R_reg[2] , Y_reg[2] , X_reg[2]};
        {R_reg[3] , Y_reg[3] , X_reg[3]} <= ((X_reg[2] - X_reg[0]) * (Y_reg[3] - Y_reg[0]) - (X_reg[3] - X_reg[0]) * (Y_reg[2] - Y_reg[0])) < 0 ? {R_reg[2] , Y_reg[2] , X_reg[2]} : {R_reg[3] , Y_reg[3] , X_reg[3]};
    end
    else if (ns == sort2_2 || ns == sort4_4) begin
        {R_reg[4] , Y_reg[4] , X_reg[4]} <= ((X_reg[4] - X_reg[0]) * (Y_reg[5] - Y_reg[0]) - (X_reg[5] - X_reg[0]) * (Y_reg[4] - Y_reg[0])) < 0 ? {R_reg[5] , Y_reg[5] , X_reg[5]} : {R_reg[4] , Y_reg[4] , X_reg[4]};
        {R_reg[5] , Y_reg[5] , X_reg[5]} <= ((X_reg[4] - X_reg[0]) * (Y_reg[5] - Y_reg[0]) - (X_reg[5] - X_reg[0]) * (Y_reg[4] - Y_reg[0])) < 0 ? {R_reg[4] , Y_reg[4] , X_reg[4]} : {R_reg[5] , Y_reg[5] , X_reg[5]};
    end
end

always @(*) begin
    case (ns) //synopsys parallel_case
        count_s1 : a_temp1 = (X_reg[1] - X_reg[0]) ** 2 + (Y_reg[1] - Y_reg[0]) ** 2;
        count_s2 : a_temp1 = (X_reg[2] - X_reg[1]) ** 2 + (Y_reg[2] - Y_reg[1]) ** 2;
        count_s3 : a_temp1 = (X_reg[3] - X_reg[2]) ** 2 + (Y_reg[3] - Y_reg[2]) ** 2;
        count_s4 : a_temp1 = (X_reg[4] - X_reg[3]) ** 2 + (Y_reg[4] - Y_reg[3]) ** 2;
        count_s5 : a_temp1 = (X_reg[5] - X_reg[4]) ** 2 + (Y_reg[5] - Y_reg[4]) ** 2;
        count_s6 : a_temp1 = (X_reg[0] - X_reg[5]) ** 2 + (Y_reg[0] - Y_reg[5]) ** 2;
        default : a_temp1 = 23'dx;
    endcase
end

always @(posedge `CLK or posedge `RST) begin
    if (reset) begin
        a <= 12'd0;
    end
    else begin
        a <= a_temp2;
    end
end

always @(posedge `CLK or posedge `RST) begin
    if (reset) begin
        s <= 12'd0;
    end
    else begin
        case (ns) //synopsys parallel_case
            count_s1 : s <= (a_temp2 + R_reg[0] + R_reg[1]) >> 1;
            count_s2 : s <= (a_temp2 + R_reg[1] + R_reg[2]) >> 1;
            count_s3 : s <= (a_temp2 + R_reg[2] + R_reg[3]) >> 1;
            count_s4 : s <= (a_temp2 + R_reg[3] + R_reg[4]) >> 1;
            count_s5 : s <= (a_temp2 + R_reg[4] + R_reg[5]) >> 1;
            count_s6 : s <= (a_temp2 + R_reg[5] + R_reg[0]) >> 1;
        endcase
    end
end

assign tri_area_mul1 = s * (s - a);

always @(*) begin
    case (ns) //synopsys parallel_case
        count_s1_area : tri_area_mul2 <= (s - R_reg[1]) * (s - R_reg[0]);
        count_s2_area : tri_area_mul2 <= (s - R_reg[2]) * (s - R_reg[1]);
        count_s3_area : tri_area_mul2 <= (s - R_reg[3]) * (s - R_reg[2]);
        count_s4_area : tri_area_mul2 <= (s - R_reg[4]) * (s - R_reg[3]);
        count_s5_area : tri_area_mul2 <= (s - R_reg[5]) * (s - R_reg[4]);
        count_s6_area : tri_area_mul2 <= (s - R_reg[0]) * (s - R_reg[5]);
        // default : tri_area_mul2 = 24'dx;
    endcase
end

always @(posedge `CLK or posedge `RST) begin
    if (reset) begin
        tri_area <= 27'd0;
    end
    // else if (ns == start) begin
    //     tri_area <= 27'd0;
    // end
    else begin
        case (ns) //synopsys parallel_case
            count_s1_area : tri_area <= tri_area_sqrt1 * tri_area_sqrt2;
            count_s2_area : tri_area <= tri_area_sqrt1 * tri_area_sqrt2 + tri_area;
            count_s3_area : tri_area <= tri_area_sqrt1 * tri_area_sqrt2 + tri_area;
            count_s4_area : tri_area <= tri_area_sqrt1 * tri_area_sqrt2 + tri_area;
            count_s5_area : tri_area <= tri_area_sqrt1 * tri_area_sqrt2 + tri_area;
            count_s6_area : tri_area <= tri_area_sqrt1 * tri_area_sqrt2 + tri_area;
            default : tri_area <= tri_area;
        endcase
    end
end

wire signed [22:0] hex_area_1temp;
wire signed [22:0] hex_area_2temp;
wire signed [22:0] hex_area_3temp;
wire signed [22:0] hex_area_4temp;
wire signed [22:0] hex_area_5temp;
wire signed [22:0] hex_area_6temp;

assign hex_area_1temp = X_reg[0] * Y_reg[1] - Y_reg[0] * X_reg[1];
assign hex_area_2temp = X_reg[1] * Y_reg[2] - Y_reg[1] * X_reg[2];
assign hex_area_3temp = X_reg[2] * Y_reg[3] - Y_reg[2] * X_reg[3];
assign hex_area_4temp = X_reg[3] * Y_reg[4] - Y_reg[3] * X_reg[4];
assign hex_area_5temp = X_reg[4] * Y_reg[5] - Y_reg[4] * X_reg[5];
assign hex_area_6temp = X_reg[5] * Y_reg[0] - Y_reg[5] * X_reg[0];

always @(posedge `CLK or posedge `RST) begin
    if (reset) begin
        hex_area <= 27'd0;
    end
    else begin
        case (ns) //synopsys parallel_case
            count_s1 : hex_area <= hex_area_1temp;
            count_s2 : hex_area <= hex_area_2temp + hex_area;
            count_s3 : hex_area <= hex_area_3temp + hex_area;
            count_s4 : hex_area <= hex_area_4temp + hex_area;
            count_s5 : hex_area <= hex_area_5temp + hex_area;
            count_s6 : hex_area <= hex_area_6temp + hex_area;
            count_s6_area : hex_area <= hex_area >> 1;
        endcase
    end
end

always @(posedge `CLK or posedge `RST) begin
    if (reset) begin
        valid <= 1'd0;
        is_inside <= 1'd0;
    end
    else if (ns == finish) begin
        valid <= 1'd1;
        is_inside <= ~($unsigned(tri_area) > $unsigned(hex_area));
    end 
    else begin
       valid <= 1'd0; 
    end
end

endmodule