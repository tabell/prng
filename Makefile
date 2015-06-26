SRC=*.v
SIMFLAGS=-c -do sim.do

all: $(SRC)
	vlog $(SRC)
mult: all
	vsim $(SIMFLAGS) $(TB)
top: all
	vsim $(SIMFLAGS) tb_prng

