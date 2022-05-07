create_clock -name clk -period "50MHz" [get_ports clk]

set_false_path -from * -to [get_ports H3D0]
set_false_path -from * -to [get_ports H3D5]
set_false_path -from * -to [get_ports H3D4]
set_false_path -from * -to [get_ports H3D6]

set_false_path -from * -to [get_ports H2D5]
set_false_path -from * -to [get_ports H2D4]

set_false_path -from * -to [get_ports H1D2]
set_false_path -from * -to [get_ports H1D1]
set_false_path -from * -to [get_ports H1D0]
set_false_path -from * -to [get_ports H1D5]
set_false_path -from * -to [get_ports H1D4]

set_false_path -from * -to [get_ports GPIO0]
set_false_path -from * -to [get_ports GPIO1]

set_false_path -from * -to [get_ports GPIO2]
set_false_path -from * -to [get_ports GPIO3]

set_false_path -from * -to [get_ports KEY0]
