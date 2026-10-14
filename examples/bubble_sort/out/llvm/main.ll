
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
%FILE = type opaque;
%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(%FILE* %f)
declare %Int @feof(%FILE* %f)
declare %Int @ferror(%FILE* %f)
declare %Int @fflush(%FILE* %f)
declare %Int @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, %FILE* %f)
declare %Int @fseek(%FILE* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%FILE* %f, %FposT* %pos)
declare %LongInt @ftell(%FILE* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buf)
declare %Int @setvbuf(%FILE* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(%FILE* %f, %Str* %format, ...)
declare %Int @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%FILE* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(%FILE* %f)
declare %Int @fputc(%Int %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %FILE* %f)
declare %Int @fputs(%ConstCharStr* %str, %FILE* %f)
declare %Int @getc(%FILE* %f)
declare %Int @getchar()
declare %Int @putc(%Int %char, %FILE* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %FILE* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [15 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 98, i8 101, i8 102, i8 111, i8 114, i8 101, i8 58, i8 10, i8 0]
@.str2 = private constant [2 x i8] [i8 10, i8 0]
@.str3 = private constant [14 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 97, i8 102, i8 116, i8 101, i8 114, i8 58, i8 10, i8 0]
@.str4 = private constant [2 x i8] [i8 10, i8 0]
@.str5 = private constant [2 x i8] [i8 10, i8 0]
@.str6 = private constant [16 x i8] [i8 97, i8 114, i8 114, i8 97, i8 121, i8 91, i8 37, i8 105, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
; -- endstrings --
@testArray = internal global [23 x %Int32] [
	%Int32 -3,
	%Int32 -5,
	%Int32 2,
	%Int32 -11,
	%Int32 1,
	%Int32 -1,
	%Int32 0,
	%Int32 -2,
	%Int32 3,
	%Int32 -4,
	%Int32 4,
	%Int32 11,
	%Int32 -10,
	%Int32 9,
	%Int32 6,
	%Int32 -7,
	%Int32 -8,
	%Int32 5,
	%Int32 7,
	%Int32 10,
	%Int32 8,
	%Int32 -6,
	%Int32 -9
]
define internal %Bool @bubble_sort32_iter([0 x %Int32]* %array, %Nat32 %len) {
	%wasSwap = alloca %Bool, align 1
	%i = alloca %Nat32, align 4
	store %Bool 0, %Bool* %wasSwap
	store %Nat32 0, %Nat32* %i
; while_1
	br label %again_1
again_1:
	%1 = sub %Nat32 %len, 1
	%2 = load %Nat32, %Nat32* %i
	%3 = icmp ult %Nat32 %2, %1
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Nat32, %Nat32* %i
	%5 = bitcast %Nat32 %4 to %Nat32
	%6 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %5
	%7 = load %Int32, %Int32* %6
	%8 = load %Nat32, %Nat32* %i
	%9 = add %Nat32 %8, 1
	%10 = bitcast %Nat32 %9 to %Nat32
	%11 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %10
	%12 = load %Int32, %Int32* %11
; if_0
	%13 = icmp sgt %Int32 %7, %12
	br %Bool %13 , label %then_0, label %endif_0
then_0:
	%14 = load %Nat32, %Nat32* %i
	%15 = bitcast %Nat32 %14 to %Nat32
	%16 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %15
	store %Int32 %12, %Int32* %16
	%17 = load %Nat32, %Nat32* %i
	%18 = add %Nat32 %17, 1
	%19 = bitcast %Nat32 %18 to %Nat32
	%20 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %19
	store %Int32 %7, %Int32* %20
	store %Bool 1, %Bool* %wasSwap
	br label %endif_0
endif_0:
	%21 = load %Nat32, %Nat32* %i
	%22 = add %Nat32 %21, 1
	store %Nat32 %22, %Nat32* %i
	br label %again_1
break_1:
	%23 = load %Bool, %Bool* %wasSwap
	ret %Bool %23
}

define internal void @bubble_sort32([0 x %Int32]* %array, %Nat32 %len) {
; while_1
	br label %again_1
again_1:
	%1 = call %Bool @bubble_sort32_iter([0 x %Int32]* %array, %Nat32 %len)
	br %Bool %1 , label %body_1, label %break_1
body_1:
	br label %again_1
break_1:
	ret void
}

define %Int32 @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str1 to [0 x i8]*))
	%2 = bitcast [23 x %Int32]* @testArray to [0 x %Int32]*
	call void @print_array([0 x %Int32]* %2, %Nat32 23)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str2 to [0 x i8]*))
	%4 = bitcast [23 x %Int32]* @testArray to [0 x %Int32]*
	call void @bubble_sort32([0 x %Int32]* %4, %Nat32 23)
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str3 to [0 x i8]*))
	%6 = bitcast [23 x %Int32]* @testArray to [0 x %Int32]*
	call void @print_array([0 x %Int32]* %6, %Nat32 23)
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str4 to [0 x i8]*))
	ret %Int32 0
}

define internal void @print_array([0 x %Int32]* %array, %Nat32 %len) {
	%i = alloca %Nat32, align 4
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str5 to [0 x i8]*))
	store %Nat32 0, %Nat32* %i
; while_1
	br label %again_1
again_1:
	%2 = load %Nat32, %Nat32* %i
	%3 = icmp ult %Nat32 %2, %len
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Nat32, %Nat32* %i
	%5 = load %Nat32, %Nat32* %i
	%6 = bitcast %Nat32 %5 to %Nat32
	%7 = getelementptr [0 x %Int32], [0 x %Int32]* %array, %Int32 0, %Nat32 %6
	%8 = load %Int32, %Int32* %7
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str6 to [0 x i8]*), %Nat32 %4, %Int32 %8)
	%10 = load %Nat32, %Nat32* %i
	%11 = add %Nat32 %10, 1
	store %Nat32 %11, %Nat32* %i
	br label %again_1
break_1:
	ret void
}


