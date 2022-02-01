IVERILOG:=iverilog
VVP:=vvp

SV_FILES:=alu_tb.sv alu.sv

.SUFFIXES:
.PHONY: test secret

test: PROG_SELECT=TEST
test: test.output
	diff -u $< test_reference.output

secret: PROG_SELECT=SECRET
secret: secret.output

.PRECIOUS: %.log

%.output: %.log
	grep "ALU:" $< | sed 's/ALU: \(.*\)/\1/' > $@

%.log: alu_%.vvp
	$(VVP) $< -fst | tee $@

alu_%.vvp: $(SV_FILES)
	$(IVERILOG) -g2012 -DPROGRAM_$(PROG_SELECT) $^ -s alu_tb -o $@
