CC = iverilog 

library_input: mc14500.v mc14500_tb.v
	$(CC) -o test mc14500.v mc14500_tb.v 
	vvp test
	gtkwave my_dumpfile.vcd config.gtkw
