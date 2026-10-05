
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
	modest -o $(MODESTPREFIX)/table -funsafe -mbackend=modest $(INDIR)/table.modest


LLVM:
	modest -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.modest
	modest -o $(LLVMPREFIX)/table -mbackend=llvm -funsafe $(INDIR)/table.modest
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/table.ll


C:
	modest -o $(CPREFIX)/main -mbackend=c11 -funsafe $(INDIR)/main.modest
	modest -o $(CPREFIX)/table -mbackend=c11 -funsafe $(INDIR)/table.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/table.c


clean:
	rm *.o

