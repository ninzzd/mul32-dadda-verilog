# anchor everything to the directory containing this TCL script
set cwd [file normalize [file join [file dirname [info script]] ".."]]
cd $cwd
# puts "Current working directory: $cwd"
# exit
# Set project variables
set proj_name "mul32-dadda-verilog"
set proj_dir  [file normalize [file join $cwd "${proj_name}-vivado"]]
set proj_xpr  [file normalize [file join $proj_dir "${proj_name}.xpr"]]

if {[file exists $proj_xpr]} {
    open_project $proj_xpr
} else {
    file mkdir $proj_dir
    cd $proj_dir
    exec git clone https://github.com/Digilent/vivado-boards
    create_project $proj_name $proj_dir -part xc7a100tcsg324-1

    # Add design sources from the src/ directory (relative to script)
    set src_dir [file join $cwd "src"]
    foreach f [glob -nocomplain -directory $src_dir *.v] {
        add_files -fileset sources_1 $f
    }

    # Add simulation sources from the tb/ directory (relative to script)
    set tb_dir [file join $cwd "tb"]
    foreach f [glob -nocomplain -directory $tb_dir *.v] {
        add_files -fileset sim_1 $f
    }

    # Set the target board to Nexys A7
    # Platform: Nexys A7
    set bd_path [file normalize [file join $proj_dir "vivado-boards" "new" "board_files"]]
    set_property board.repo_paths [list $bd_path] [current_project]
    set_property board_part xilinx.com:nexys-a7-100:part0:1.0 [current_project]

    # Save the project
    save_project
}

start_gui
