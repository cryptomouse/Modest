
INDIR=./src
OUTDIR=./out

# output dir prefix
MODESTPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


.PHONY: all, clean, Modest, LLVM, C


test: Modest LLVM C


Modest:
	modest -o $(MODESTPREFIX)/main -mbackend=modest $(INDIR)/main.modest
	modest -o $(MODESTPREFIX)/lib -mbackend=modest $(INDIR)/lib.modest


LLVM:
	modest -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.modest
	modest -o $(LLVMPREFIX)/lib -mbackend=llvm $(INDIR)/lib.modest
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/lib.ll


C:
	modest -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.modest
	modest -o $(CPREFIX)/lib -mbackend=c11 $(INDIR)/lib.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/lib.c


clean:
	rm *.o

