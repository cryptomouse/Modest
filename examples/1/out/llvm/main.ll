
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
@.str1 = private constant [4 x i8] [i8 97, i8 98, i8 99, i8 0]
@.str2 = private constant [4 x i8] [i8 100, i8 101, i8 102, i8 0]
@.str3 = private constant [4 x i8] [i8 122, i8 121, i8 120, i8 0]
@.str4 = private constant [4 x i8] [i8 49, i8 50, i8 51, i8 0]
@.str5 = private constant [4 x i8] [i8 52, i8 53, i8 54, i8 0]
@.str6 = private constant [4 x i8] [i8 55, i8 56, i8 48, i8 0]
@.str7 = private constant [2 x i8] [i8 48, i8 0]
@.str8 = private constant [4 x i8] [i8 37, i8 115, i8 10, i8 0]
; -- endstrings --

;include "./lib"
%SDL_Window = type opaque;
@cmd = internal global [7 x %Str8*] [
	%Str8* bitcast ([4 x i8]* @.str1 to [0 x i8]*),
	%Str8* bitcast ([4 x i8]* @.str2 to [0 x i8]*),
	%Str8* bitcast ([4 x i8]* @.str3 to [0 x i8]*),
	%Str8* bitcast ([4 x i8]* @.str4 to [0 x i8]*),
	%Str8* bitcast ([4 x i8]* @.str5 to [0 x i8]*),
	%Str8* bitcast ([4 x i8]* @.str6 to [0 x i8]*),
	%Str8* bitcast ([2 x i8]* @.str7 to [0 x i8]*)
]
define %Int32 @main() {
	%i = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %i
	%1 = mul %Int32 1, 1
	%2 = load %Nat32, %Nat32* %i
	%3 = sub %Nat32 7, %2
	%4 = mul %Nat32 %3, 1
	%5 = mul %Nat32 %3, 8
	%6 = alloca [0 x %Str8*]*, %Int32 1, align 8
	%7 = load %Nat32, %Nat32* %i
	%8 = bitcast %Nat32 %7 to %Nat32
	%9 = getelementptr [7 x %Str8*], [7 x %Str8*]* @cmd, %Int32 0, %Nat32 %8
	%10 = bitcast %Str8** %9 to [0 x %Str8*]*
	store [0 x %Str8*]* %10, [0 x %Str8*]** %6
	%11 = load [0 x %Str8*]*, [0 x %Str8*]** %6
	%12 = mul %Int32 0, 1
	%13 = add %Int32 0, %12
	%14 = getelementptr %Str8*, [0 x %Str8*]* %11, %Int32 %13
	%15 = load %Str8*, %Str8** %14
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @.str8 to [0 x i8]*), %Str8* %15)
	ret %Int32 0
}


