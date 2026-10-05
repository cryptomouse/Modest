
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



define internal %Fixed32 @__fixed32_mul(%Fixed32 %a, %Fixed32 %b, i8 %f) {
	%1 = sext %Fixed32 %a to i64
	%2 = sext %Fixed32 %b to i64
	%3 = mul i64 %1, %2
	%4 = zext i8 %f to i64
	%5 = shl i64 1, %4
	%6 = lshr i64 %5, 1
	%7 = icmp slt i64 %3, 0
	%8 = sub i64 %3, %6
	%9 = add i64 %3, %6
	%10 = select i1 %7, i64 %8, i64 %9
	%11 = sdiv i64 %10, %5
	%12 = trunc i64 %11 to %Fixed32
	ret %Fixed32 %12
}

define internal %Fixed32 @__fixed32_div(%Fixed32 %a, %Fixed32 %b, i8 %f) {
	%1 = sext %Fixed32 %a to i64
	%2 = sext %Fixed32 %b to i64
	%3 = zext i8 %f to i64
	%4 = shl i64 1, %3
	%5 = mul i64 %1, %4
	%6 = sdiv i64 %2, 2
	%7 = icmp slt i64 %1, 0
	%8 = icmp slt i64 %2, 0
	%9 = icmp eq i1 %7, %8
	%10 = add i64 %5, %6
	%11 = sub i64 %5, %6
	%12 = select i1 %9, i64 %10, i64 %11
	%13 = sdiv i64 %12, %2
	%14 = trunc i64 %13 to %Fixed32
	ret %Fixed32 %14
}

define internal %Fixed64 @__fixed64_mul(%Fixed64 %a, %Fixed64 %b, i8 %f) {
	%1 = sext %Fixed64 %a to i128
	%2 = sext %Fixed64 %b to i128
	%3 = mul i128 %1, %2
	%4 = zext i8 %f to i128
	%5 = shl i128 1, %4
	%6 = lshr i128 %5, 1
	%7 = icmp slt i128 %3, 0
	%8 = sub i128 %3, %6
	%9 = add i128 %3, %6
	%10 = select i1 %7, i128 %8, i128 %9
	%11 = sdiv i128 %10, %5
	%12 = trunc i128 %11 to %Fixed64
	ret %Fixed64 %12
}

define internal %Fixed64 @__fixed64_div(%Fixed64 %a, %Fixed64 %b, i8 %f) {
	%1 = sext %Fixed64 %a to i128
	%2 = sext %Fixed64 %b to i128
	%3 = zext i8 %f to i128
	%4 = shl i128 1, %3
	%5 = mul i128 %1, %4
	%6 = sdiv i128 %2, 2
	%7 = icmp slt i128 %1, 0
	%8 = icmp slt i128 %2, 0
	%9 = icmp eq i1 %7, %8
	%10 = add i128 %5, %6
	%11 = sub i128 %5, %6
	%12 = select i1 %9, i128 %10, i128 %11
	%13 = sdiv i128 %12, %2
	%14 = trunc i128 %13 to %Fixed64
	ret %Fixed64 %14
}

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
@.str1 = private constant [14 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 32, i8 87, i8 111, i8 114, i8 108, i8 100, i8 33, i8 10, i8 0]
@.str2 = private constant [15 x i8] [i8 102, i8 120, i8 51, i8 50, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@.str3 = private constant [18 x i8] [i8 102, i8 120, i8 54, i8 52, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 49, i8 54, i8 108, i8 108, i8 120, i8 10, i8 0]
@.str4 = private constant [15 x i8] [i8 102, i8 120, i8 51, i8 50, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@.str5 = private constant [18 x i8] [i8 102, i8 120, i8 54, i8 52, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 49, i8 54, i8 108, i8 108, i8 120, i8 10, i8 0]
@.str6 = private constant [13 x i8] [i8 99, i8 51, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@.str7 = private constant [10 x i8] [i8 99, i8 51, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str8 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str9 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str10 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str11 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str12 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str13 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str14 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str15 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str16 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str17 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str18 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str19 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str20 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str21 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str22 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str23 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str24 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str25 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str26 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str27 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
@.str28 = private constant [10 x i8] [i8 118, i8 49, i8 32, i8 61, i8 32, i8 37, i8 108, i8 102, i8 10, i8 0]
; -- endstrings --
@f32 = internal global %Float32 0.0
@f64 = internal global %Float64 0.0
@fx32 = internal global %Fixed32 0
@fx64 = internal global %Fixed64 0
@arr = internal global [10 x %Fixed64] [
	%Fixed64 6442450944,
	%Fixed64 10737418240,
	%Fixed64 0,
	%Fixed64 0,
	%Fixed64 0,
	%Fixed64 0,
	%Fixed64 0,
	%Fixed64 0,
	%Fixed64 0,
	%Fixed64 0
]
define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str1 to [0 x i8]*))
	store %Float32 1.0, %Float32* @f32
	store %Float64 1.0, %Float64* @f64
	store %Fixed32 65536, %Fixed32* @fx32
	store %Fixed64 4294967296, %Fixed64* @fx64
	%2 = load %Fixed32, %Fixed32* @fx32
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str2 to [0 x i8]*), %Fixed32 %2)
	%4 = load %Fixed64, %Fixed64* @fx64
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str3 to [0 x i8]*), %Fixed64 %4)
	store %Fixed32 98304, %Fixed32* @fx32
	store %Fixed64 6442450944, %Fixed64* @fx64
	%6 = load %Fixed32, %Fixed32* @fx32
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str4 to [0 x i8]*), %Fixed32 %6)
	%8 = load %Fixed64, %Fixed64* @fx64
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str5 to [0 x i8]*), %Fixed64 %8)
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str6 to [0 x i8]*), %Fixed32 49152)
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str7 to [0 x i8]*), %Float64 0.75)
	%12 = alloca %Fixed32, align 4
	store %Fixed32 49152, %Fixed32* %12
	%13 = load %Fixed32, %Fixed32* %12
	%14 = sitofp %Fixed32 %13 to %Float64
	%15 = fdiv %Float64 %14, 65536.0
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str8 to [0 x i8]*), %Float64 %15)
	%17 = load %Fixed32, %Fixed32* %12
	%18 = add %Fixed32 %17, 65536
	%19 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %18, %Fixed32 131072, i8 16)
	store %Fixed32 %19, %Fixed32* %12
	%20 = load %Fixed32, %Fixed32* %12
	%21 = sitofp %Fixed32 %20 to %Float64
	%22 = fdiv %Float64 %21, 65536.0
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str9 to [0 x i8]*), %Float64 %22)
	%24 = load %Fixed32, %Fixed32* %12
	%25 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %24, %Fixed32 131072, i8 16)
	store %Fixed32 %25, %Fixed32* %12
	%26 = load %Fixed32, %Fixed32* %12
	%27 = sitofp %Fixed32 %26 to %Float64
	%28 = fdiv %Float64 %27, 65536.0
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str10 to [0 x i8]*), %Float64 %28)
	%30 = load %Fixed32, %Fixed32* %12
	%31 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %30, %Fixed32 131072, i8 16)
	store %Fixed32 %31, %Fixed32* %12
	%32 = load %Fixed32, %Fixed32* %12
	%33 = sitofp %Fixed32 %32 to %Float64
	%34 = fdiv %Float64 %33, 65536.0
	%35 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str11 to [0 x i8]*), %Float64 %34)
	%36 = load %Fixed32, %Fixed32* %12
	%37 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %36, %Fixed32 131072, i8 16)
	store %Fixed32 %37, %Fixed32* %12
	%38 = load %Fixed32, %Fixed32* %12
	%39 = sitofp %Fixed32 %38 to %Float64
	%40 = fdiv %Float64 %39, 65536.0
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str12 to [0 x i8]*), %Float64 %40)
	%42 = load %Fixed32, %Fixed32* %12
	%43 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %42, %Fixed32 131072, i8 16)
	store %Fixed32 %43, %Fixed32* %12
	%44 = load %Fixed32, %Fixed32* %12
	%45 = sitofp %Fixed32 %44 to %Float64
	%46 = fdiv %Float64 %45, 65536.0
	%47 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str13 to [0 x i8]*), %Float64 %46)
	%48 = load %Fixed32, %Fixed32* %12
	%49 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %48, %Fixed32 131072, i8 16)
	store %Fixed32 %49, %Fixed32* %12
	%50 = load %Fixed32, %Fixed32* %12
	%51 = sitofp %Fixed32 %50 to %Float64
	%52 = fdiv %Float64 %51, 65536.0
	%53 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str14 to [0 x i8]*), %Float64 %52)
	%54 = load %Fixed32, %Fixed32* %12
	%55 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %54, %Fixed32 131072, i8 16)
	store %Fixed32 %55, %Fixed32* %12
	%56 = load %Fixed32, %Fixed32* %12
	%57 = sitofp %Fixed32 %56 to %Float64
	%58 = fdiv %Float64 %57, 65536.0
	%59 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str15 to [0 x i8]*), %Float64 %58)
	%60 = load %Fixed32, %Fixed32* %12
	%61 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %60, %Fixed32 131072, i8 16)
	store %Fixed32 %61, %Fixed32* %12
	%62 = load %Fixed32, %Fixed32* %12
	%63 = sitofp %Fixed32 %62 to %Float64
	%64 = fdiv %Float64 %63, 65536.0
	%65 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str16 to [0 x i8]*), %Float64 %64)
	%66 = load %Fixed32, %Fixed32* %12
	%67 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %66, %Fixed32 131072, i8 16)
	store %Fixed32 %67, %Fixed32* %12
	%68 = load %Fixed32, %Fixed32* %12
	%69 = sitofp %Fixed32 %68 to %Float64
	%70 = fdiv %Float64 %69, 65536.0
	%71 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str17 to [0 x i8]*), %Float64 %70)
	%72 = load %Fixed32, %Fixed32* %12
	%73 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %72, %Fixed32 131072, i8 16)
	store %Fixed32 %73, %Fixed32* %12
	%74 = load %Fixed32, %Fixed32* %12
	%75 = sitofp %Fixed32 %74 to %Float64
	%76 = fdiv %Float64 %75, 65536.0
	%77 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str18 to [0 x i8]*), %Float64 %76)
	%78 = load %Fixed32, %Fixed32* %12
	%79 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %78, %Fixed32 131072, i8 16)
	store %Fixed32 %79, %Fixed32* %12
	%80 = load %Fixed32, %Fixed32* %12
	%81 = sitofp %Fixed32 %80 to %Float64
	%82 = fdiv %Float64 %81, 65536.0
	%83 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str19 to [0 x i8]*), %Float64 %82)
	%84 = load %Fixed32, %Fixed32* %12
	%85 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %84, %Fixed32 131072, i8 16)
	store %Fixed32 %85, %Fixed32* %12
	%86 = load %Fixed32, %Fixed32* %12
	%87 = sitofp %Fixed32 %86 to %Float64
	%88 = fdiv %Float64 %87, 65536.0
	%89 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str20 to [0 x i8]*), %Float64 %88)
	%90 = load %Fixed32, %Fixed32* %12
	%91 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %90, %Fixed32 131072, i8 16)
	store %Fixed32 %91, %Fixed32* %12
	%92 = load %Fixed32, %Fixed32* %12
	%93 = sitofp %Fixed32 %92 to %Float64
	%94 = fdiv %Float64 %93, 65536.0
	%95 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str21 to [0 x i8]*), %Float64 %94)
	%96 = load %Fixed32, %Fixed32* %12
	%97 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %96, %Fixed32 131072, i8 16)
	store %Fixed32 %97, %Fixed32* %12
	%98 = load %Fixed32, %Fixed32* %12
	%99 = sitofp %Fixed32 %98 to %Float64
	%100 = fdiv %Float64 %99, 65536.0
	%101 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str22 to [0 x i8]*), %Float64 %100)
	%102 = load %Fixed32, %Fixed32* %12
	%103 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %102, %Fixed32 131072, i8 16)
	store %Fixed32 %103, %Fixed32* %12
	%104 = load %Fixed32, %Fixed32* %12
	%105 = sitofp %Fixed32 %104 to %Float64
	%106 = fdiv %Float64 %105, 65536.0
	%107 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str23 to [0 x i8]*), %Float64 %106)
	%108 = load %Fixed32, %Fixed32* %12
	%109 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %108, %Fixed32 131072, i8 16)
	store %Fixed32 %109, %Fixed32* %12
	%110 = load %Fixed32, %Fixed32* %12
	%111 = sitofp %Fixed32 %110 to %Float64
	%112 = fdiv %Float64 %111, 65536.0
	%113 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str24 to [0 x i8]*), %Float64 %112)
	%114 = load %Fixed32, %Fixed32* %12
	%115 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %114, %Fixed32 131072, i8 16)
	store %Fixed32 %115, %Fixed32* %12
	%116 = load %Fixed32, %Fixed32* %12
	%117 = sitofp %Fixed32 %116 to %Float64
	%118 = fdiv %Float64 %117, 65536.0
	%119 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str25 to [0 x i8]*), %Float64 %118)
	%120 = load %Fixed32, %Fixed32* %12
	%121 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %120, %Fixed32 131072, i8 16)
	store %Fixed32 %121, %Fixed32* %12
	%122 = load %Fixed32, %Fixed32* %12
	%123 = sitofp %Fixed32 %122 to %Float64
	%124 = fdiv %Float64 %123, 65536.0
	%125 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str26 to [0 x i8]*), %Float64 %124)
	%126 = load %Fixed32, %Fixed32* %12
	%127 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %126, %Fixed32 131072, i8 16)
	store %Fixed32 %127, %Fixed32* %12
	%128 = load %Fixed32, %Fixed32* %12
	%129 = sitofp %Fixed32 %128 to %Float64
	%130 = fdiv %Float64 %129, 65536.0
	%131 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str27 to [0 x i8]*), %Float64 %130)
	%132 = load %Fixed32, %Fixed32* %12
	%133 = call %Fixed32 (%Fixed32, %Fixed32, i8) @__fixed32_div(%Fixed32 %132, %Fixed32 131072, i8 16)
	store %Fixed32 %133, %Fixed32* %12
	%134 = load %Fixed32, %Fixed32* %12
	%135 = sitofp %Fixed32 %134 to %Float64
	%136 = fdiv %Float64 %135, 65536.0
	%137 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str28 to [0 x i8]*), %Float64 %136)
	ret %Int 0
}


