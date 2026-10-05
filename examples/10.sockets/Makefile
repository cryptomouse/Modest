


INDIR=./src
OUTDIR=./out

# output dir prefix
MODESTPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: Modest LLVM C


Modest:
	modest -o $(MODESTPREFIX)/client -mbackend=modest $(INDIR)/client.modest
	modest -o $(MODESTPREFIX)/server -mbackend=modest $(INDIR)/server.modest


LLVM:
	modest -o $(LLVMPREFIX)/client -funsafe -mbackend=llvm $(INDIR)/client.modest
	modest -o $(LLVMPREFIX)/server -funsafe -mbackend=llvm $(INDIR)/server.modest
	clang -oclient $(LLVMPREFIX)/client.ll
	clang -oserver $(LLVMPREFIX)/server.ll


C:
	modest -o $(CPREFIX)/client -funsafe -mbackend=c11 $(INDIR)/client.modest
	modest -o $(CPREFIX)/server -funsafe -mbackend=c11 $(INDIR)/server.modest
	clang $(C_OPTIONS) -oclient $(CPREFIX)/client.c
	clang $(C_OPTIONS) -oserver $(CPREFIX)/server.c


clean:
	rm *.o

