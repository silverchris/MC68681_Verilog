#/bin/bash
verilator --trace -Wno-UNOPTFLAT -Wno-WIDTH --relative-includes -I.. -cc ../test.v
cwd=$(pwd)
cd obj_dir
make -f Vtest.mk
cd ..
g++ -I obj_dir obj_dir/Vtest__ALL.o -I/home/silverchris/oss-cad-suite/share/verilator/include module.cpp /home/silverchris/oss-cad-suite/share/verilator/include/verilated.cpp /home/silverchris/oss-cad-suite/share/verilator/include/verilated_vcd_c.cpp -o module
g++ -I obj_dir obj_dir/Vtest__ALL.o -I/home/silverchris/oss-cad-suite/share/verilator/include test_int.cpp /home/silverchris/oss-cad-suite/share/verilator/include/verilated.cpp /home/silverchris/oss-cad-suite/share/verilator/include/verilated_vcd_c.cpp -o test_int