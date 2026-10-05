
INDIR=./src
OUTDIR=./out

# output dir prefix
MODESTPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: Modest LLVM C


Modest:
	modest -o $(MODESTPREFIX)/main -funsafe -mbackend=modest $(INDIR)/main.modest


LLVM:
	modest -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.modest
	clang $(LLVMPREFIX)/main.ll


C:
	modest -o $(CPREFIX)/main -mbackend=c11 -funsafe $(INDIR)/main.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c


clean:
	rm *.o

