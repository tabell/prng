DUT=mult
TB=$(DUT)_tb
SRC=*.sv
SIMFLAGS=-c -do sim.do

simulate: $(SRC)
	vlog $(SRC)
	vsim $(SIMFLAGS) $(TB)

