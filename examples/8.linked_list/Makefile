
OUTDIR=./out
INDIR=./src

# output dir prefix
MODESTPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: Modest LLVM C


Modest:
	modest -o $(MODESTPREFIX)/main -mbackend=modest -funsafe -mint=64 $(INDIR)/main.modest
	modest -o $(MODESTPREFIX)/list -mbackend=modest -mint=64 $(INDIR)/list.modest


LLVM:
  # 1. CM -> LLVM/IR
	modest -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe -mint=64 $(INDIR)/main.modest
	modest -o $(LLVMPREFIX)/list -mbackend=llvm -mint=64 $(INDIR)/list.modest

	# 2. LLVM/IR -> *.o
	#clang -c $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/linked_list.ll

	# 3. *.o -> a.out
	#clang $(C_OPTIONS) main.o linked_list.o -o a.out

	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/list.ll


C:
	modest -o $(CPREFIX)/main -mbackend=c11 -funsafe -mint=64 $(INDIR)/main.modest
	modest -o $(CPREFIX)/list -mbackend=c11 -mint=64 $(INDIR)/list.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/list.c


clean:
	rm *.o

