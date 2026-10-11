
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx27.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
%Word256 = type i256
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Int256 = type i256
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Nat256 = type i256
%Float16 = type half
%Float32 = type float
%Float64 = type double
%Fixed32 = type i32
%Fixed64 = type i64
%Size = type i64
%Pointer = type i8*
%Str8 = type [0 x %Char8]
%Str16 = type [0 x %Char16]
%Str32 = type [0 x %Char32]
%__VA_List = type i8*
declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

declare i8* @llvm.stacksave()

declare void @llvm.stackrestore(i8*)


; MODULE: main

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Nat8;
%Short = type %Int16;
%UnsignedShort = type %Nat16;
%Int = type %Int32;
%UnsignedInt = type %Nat32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Nat64;
%Long = type %Int64;
%UnsignedLong = type %Nat64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Nat64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Nat64;
%Float = type %Float32;
%Double = type %Float64;
%LongDouble = type %Float64;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Nat64;
%PtrDiffT = type %Int64;
%OffT = type %Int64;
%USecondsT = type %Nat32;
%PIDT = type %Int32;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
; from included stdio
%File = type {
};

%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(i8* %f)
declare %Int @feof(i8* %f)
declare %Int @ferror(i8* %f)
declare %Int @fflush(i8* %f)
declare %Int @fgetpos(i8* %f, %FposT* %pos)
declare i8* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare i8* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, i8* %f)
declare %Int @fseek(i8* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(i8* %f, %FposT* %pos)
declare %LongInt @ftell(i8* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(i8* %f)
declare void @setbuf(i8* %f, %CharStr* %buf)
declare %Int @setvbuf(i8* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare i8* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(i8* %f, %Str* %format, ...)
declare %Int @fscanf(i8* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(i8* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(i8* %f)
declare %Int @fputc(%Int %char, i8* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, i8* %f)
declare %Int @fputs(%ConstCharStr* %str, i8* %f)
declare %Int @getc(i8* %f)
declare %Int @getchar()
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [18 x i8] [i8 99, i8 104, i8 101, i8 99, i8 107, i8 65, i8 114, i8 103, i8 115, i8 40, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str2 = private constant [19 x i8] [i8 99, i8 104, i8 101, i8 99, i8 107, i8 65, i8 114, i8 114, i8 97, i8 121, i8 40, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str3 = private constant [20 x i8] [i8 99, i8 104, i8 101, i8 99, i8 107, i8 82, i8 101, i8 99, i8 111, i8 114, i8 100, i8 40, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str4 = private constant [28 x i8] [i8 99, i8 104, i8 101, i8 99, i8 107, i8 82, i8 101, i8 99, i8 111, i8 114, i8 100, i8 40, i8 114, i8 101, i8 118, i8 101, i8 114, i8 115, i8 101, i8 100, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --

;include "./lib"
%Aligned = type {
	%Word8
};

@num = internal global %Nat32 0
define internal %Nat32 @getnum() {
	%1 = load %Nat32, %Nat32* @num
	%2 = load %Nat32, %Nat32* @num
	%3 = add %Nat32 %2, 1
	store %Nat32 %3, %Nat32* @num
	ret %Nat32 %1
}

define internal %Bool @checkArgs(%Nat32 %a, %Nat32 %b, %Nat32 %c) {
	%1 = icmp ult %Nat32 %a, %b
	%2 = icmp ult %Nat32 %b, %c
	%3 = and %Bool %1, %2
	ret %Bool %3
}

define internal %Bool @checkArray([3 x %Nat32] %__a) {
	%a = alloca [3 x %Nat32]
	%1 = zext i8 3 to %Nat32
	store [3 x %Nat32] %__a, [3 x %Nat32]* %a
	%2 = getelementptr [3 x %Nat32], [3 x %Nat32]* %a, %Int32 0, %Int32 0
	%3 = getelementptr [3 x %Nat32], [3 x %Nat32]* %a, %Int32 0, %Int32 1
	%4 = load %Nat32, %Nat32* %2
	%5 = load %Nat32, %Nat32* %3
	%6 = icmp ult %Nat32 %4, %5
	%7 = getelementptr [3 x %Nat32], [3 x %Nat32]* %a, %Int32 0, %Int32 1
	%8 = getelementptr [3 x %Nat32], [3 x %Nat32]* %a, %Int32 0, %Int32 2
	%9 = load %Nat32, %Nat32* %7
	%10 = load %Nat32, %Nat32* %8
	%11 = icmp ult %Nat32 %9, %10
	%12 = and %Bool %6, %11
	ret %Bool %12
}

%Triple = type {
	%Nat32,
	%Nat32,
	%Nat32
};

define internal %Bool @checkRecord(%Triple %__r) {
	%r = alloca %Triple
	store %Triple %__r, %Triple* %r
	%1 = getelementptr %Triple, %Triple* %r, %Int32 0, %Int32 0
	%2 = getelementptr %Triple, %Triple* %r, %Int32 0, %Int32 1
	%3 = load %Nat32, %Nat32* %1
	%4 = load %Nat32, %Nat32* %2
	%5 = icmp ult %Nat32 %3, %4
	%6 = getelementptr %Triple, %Triple* %r, %Int32 0, %Int32 1
	%7 = getelementptr %Triple, %Triple* %r, %Int32 0, %Int32 2
	%8 = load %Nat32, %Nat32* %6
	%9 = load %Nat32, %Nat32* %7
	%10 = icmp ult %Nat32 %8, %9
	%11 = and %Bool %5, %10
	ret %Bool %11
}

define %Int32 @main() {
	%1 = call %Nat32 @getnum()
	%2 = call %Nat32 @getnum()
	%3 = call %Nat32 @getnum()
	%4 = call %Bool @checkArgs(%Nat32 %1, %Nat32 %2, %Nat32 %3)
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str1 to [0 x i8]*), %Bool %4)
	%6 = call %Nat32 @getnum()
	%7 = insertvalue [3 x %Nat32] zeroinitializer, %Nat32 %6, 0
	%8 = call %Nat32 @getnum()
	%9 = insertvalue [3 x %Nat32] %7, %Nat32 %8, 1
	%10 = call %Nat32 @getnum()
	%11 = insertvalue [3 x %Nat32] %9, %Nat32 %10, 2
	%12 = call %Bool @checkArray([3 x %Nat32] %11)
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @.str2 to [0 x i8]*), %Bool %12)
	%14 = call %Nat32 @getnum()
	%15 = insertvalue %Triple zeroinitializer, %Nat32 %14, 0
	%16 = call %Nat32 @getnum()
	%17 = insertvalue %Triple %15, %Nat32 %16, 1
	%18 = call %Nat32 @getnum()
	%19 = insertvalue %Triple %17, %Nat32 %18, 2
	%20 = call %Bool @checkRecord(%Triple %19)
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @.str3 to [0 x i8]*), %Bool %20)
	%22 = call %Nat32 @getnum()
	%23 = insertvalue %Triple zeroinitializer, %Nat32 %22, 0
	%24 = call %Nat32 @getnum()
	%25 = insertvalue %Triple %23, %Nat32 %24, 1
	%26 = call %Nat32 @getnum()
	%27 = insertvalue %Triple %25, %Nat32 %26, 2
	%28 = call %Bool @checkRecord(%Triple %27)
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @.str4 to [0 x i8]*), %Bool %28)
	ret %Int32 0
}


