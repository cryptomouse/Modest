
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
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Float16 = type half
%Float32 = type float
%Float64 = type double
%Fixed32 = type i32
%Fixed64 = type i64
%Size = type i64
%Str8 = type [0 x %Char8]
%Str16 = type [0 x %Char16]
%Str32 = type [0 x %Char32]
%__VA_List = type i8*
declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

declare i8* @llvm.stacksave()

declare void @llvm.stackrestore(i8*)



%CPU.Word = type i64
define weak i1 @memeq(i8* %mem0, i8* %mem1, i64 %len) {
	%1 = udiv i64 %len, 8
	%2 = bitcast i8* %mem0 to [0 x %CPU.Word]*
	%3 = bitcast i8* %mem1 to [0 x %CPU.Word]*
	%4 = alloca i64
	store i64 0, i64* %4
	br label %again_1
again_1:
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %1
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i64, i64* %4
	%8 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %7
	%9 = load %CPU.Word, %CPU.Word* %8
	%10 = load i64, i64* %4
	%11 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %10
	%12 = load %CPU.Word, %CPU.Word* %11
	%13 = icmp ne %CPU.Word %9, %12
	br i1 %13 , label %then_0, label %endif_0
then_0:
	ret i1 0
	br label %endif_0
endif_0:
	%15 = load i64, i64* %4
	%16 = add i64 %15, 1
	store i64 %16, i64* %4
	br label %again_1
break_1:
	%17 = urem i64 %len, 8
	%18 = load i64, i64* %4
	%19 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %18
	%20 = bitcast %CPU.Word* %19 to [0 x i8]*
	%21 = load i64, i64* %4
	%22 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %21
	%23 = bitcast %CPU.Word* %22 to [0 x i8]*
	store i64 0, i64* %4
	br label %again_2
again_2:
	%24 = load i64, i64* %4
	%25 = icmp ult i64 %24, %17
	br i1 %25 , label %body_2, label %break_2
body_2:
	%26 = load i64, i64* %4
	%27 = getelementptr inbounds [0 x i8], [0 x i8]* %20, i32 0, i64 %26
	%28 = load i8, i8* %27
	%29 = load i64, i64* %4
	%30 = getelementptr inbounds [0 x i8], [0 x i8]* %23, i32 0, i64 %29
	%31 = load i8, i8* %30
	%32 = icmp ne i8 %28, %31
	br i1 %32 , label %then_1, label %endif_1
then_1:
	ret i1 0
	br label %endif_1
endif_1:
	%34 = load i64, i64* %4
	%35 = add i64 %34, 1
	store i64 %35, i64* %4
	br label %again_2
break_2:
	ret i1 1
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
; from included math
declare %Double @acos(%Double %x)
declare %Double @asin(%Double %x)
declare %Double @atan(%Double %x)
declare %Double @atan2(%Double %a, %Double %b)
declare %Double @cos(%Double %x)
declare %Double @sin(%Double %x)
declare %Double @tan(%Double %x)
declare %Double @cosh(%Double %x)
declare %Double @sinh(%Double %x)
declare %Double @tanh(%Double %x)
declare %Double @exp(%Double %x)
declare %Double @frexp(%Double %a, %Int* %i)
declare %Double @ldexp(%Double %a, %Int %i)
declare %Double @log(%Double %x)
declare %Double @log10(%Double %x)
declare %Double @modf(%Double %a, %Double* %b)
declare %Double @pow(%Double %a, %Double %b)
declare %Double @sqrt(%Double %x)
declare %Double @ceil(%Double %x)
declare %Double @fabs(%Double %x)
declare %Double @floor(%Double %x)
declare %Double @fmod(%Double %a, %Double %b)
declare %LongDouble @acosl(%LongDouble %x)
declare %LongDouble @asinl(%LongDouble %x)
declare %LongDouble @atanl(%LongDouble %x)
declare %LongDouble @atan2l(%LongDouble %a, %LongDouble %b)
declare %LongDouble @cosl(%LongDouble %x)
declare %LongDouble @sinl(%LongDouble %x)
declare %LongDouble @tanl(%LongDouble %x)
declare %LongDouble @acoshl(%LongDouble %x)
declare %LongDouble @asinhl(%LongDouble %x)
declare %LongDouble @atanhl(%LongDouble %x)
declare %LongDouble @coshl(%LongDouble %x)
declare %LongDouble @sinhl(%LongDouble %x)
declare %LongDouble @tanhl(%LongDouble %x)
declare %LongDouble @expl(%LongDouble %x)
declare %LongDouble @exp2l(%LongDouble %x)
declare %LongDouble @expm1l(%LongDouble %x)
declare %LongDouble @frexpl(%LongDouble %a, %Int* %i)
declare %Int @ilogbl(%LongDouble %x)
declare %LongDouble @ldexpl(%LongDouble %a, %Int %i)
declare %LongDouble @logl(%LongDouble %x)
declare %LongDouble @log10l(%LongDouble %x)
declare %LongDouble @log1pl(%LongDouble %x)
declare %LongDouble @log2l(%LongDouble %x)
declare %LongDouble @logbl(%LongDouble %x)
declare %LongDouble @modfl(%LongDouble %a, %LongDouble* %b)
declare %LongDouble @scalbnl(%LongDouble %a, %Int %i)
declare %LongDouble @scalblnl(%LongDouble %a, %LongInt %i)
declare %LongDouble @cbrtl(%LongDouble %x)
declare %LongDouble @fabsl(%LongDouble %x)
declare %LongDouble @hypotl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @powl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @sqrtl(%LongDouble %x)
declare %LongDouble @erfl(%LongDouble %x)
declare %LongDouble @erfcl(%LongDouble %x)
declare %LongDouble @lgammal(%LongDouble %x)
declare %LongDouble @tgammal(%LongDouble %x)
declare %LongDouble @ceill(%LongDouble %x)
declare %LongDouble @floorl(%LongDouble %x)
declare %LongDouble @nearbyintl(%LongDouble %x)
declare %LongDouble @rintl(%LongDouble %x)
declare %LongInt @lrintl(%LongDouble %x)
declare %LongLongInt @llrintl(%LongDouble %x)
declare %LongDouble @roundl(%LongDouble %x)
declare %LongInt @lroundl(%LongDouble %x)
declare %LongLongInt @llroundl(%LongDouble %x)
declare %LongDouble @truncl(%LongDouble %x)
declare %LongDouble @fmodl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @remainderl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @remquol(%LongDouble %a, %LongDouble %b, %Int* %i)
declare %LongDouble @copysignl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @nanl(%ConstChar* %x)
declare %LongDouble @nextafterl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @nexttowardl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @fdiml(%LongDouble %a, %LongDouble %b)
declare %LongDouble @fmaxl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @fminl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @fmal(%LongDouble %a, %LongDouble %b, %LongDouble %c)
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [27 x i8] [i8 109, i8 111, i8 100, i8 101, i8 115, i8 116, i8 32, i8 115, i8 97, i8 121, i8 115, i8 32, i8 104, i8 105, i8 32, i8 40, i8 99, i8 97, i8 108, i8 108, i8 32, i8 35, i8 37, i8 117, i8 41, i8 10, i8 0]
@.str2 = private constant [20 x i8] [i8 105, i8 51, i8 50, i8 32, i8 61, i8 32, i8 37, i8 100, i8 44, i8 32, i8 102, i8 54, i8 52, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@.str3 = private constant [22 x i8] [i8 99, i8 111, i8 117, i8 110, i8 116, i8 101, i8 114, i8 32, i8 43, i8 32, i8 102, i8 105, i8 120, i8 101, i8 100, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str4 = private constant [10 x i8] [i8 99, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@.str5 = private constant [13 x i8] [i8 104, i8 101, i8 105, i8 103, i8 104, i8 116, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@.str6 = private constant [12 x i8] [i8 115, i8 109, i8 97, i8 108, i8 108, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@.str7 = private constant [15 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 44, i8 32, i8 77, i8 111, i8 100, i8 101, i8 115, i8 116, i8 33, i8 0]
@.str8 = private constant [21 x i8] [i8 37, i8 115, i8 32, i8 40, i8 115, i8 116, i8 97, i8 114, i8 116, i8 115, i8 32, i8 119, i8 105, i8 116, i8 104, i8 32, i8 37, i8 99, i8 41, i8 10, i8 0]
@.str9 = private constant [12 x i8] [i8 117, i8 32, i8 124, i8 32, i8 118, i8 32, i8 61, i8 32, i8 37, i8 120, i8 10, i8 0]
@.str10 = private constant [30 x i8] [i8 126, i8 48, i8 120, i8 48, i8 70, i8 32, i8 61, i8 32, i8 37, i8 120, i8 44, i8 32, i8 126, i8 48, i8 120, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 48, i8 70, i8 32, i8 61, i8 32, i8 37, i8 120, i8 10, i8 0]
@.str11 = private constant [26 x i8] [i8 119, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 120, i8 32, i8 45, i8 62, i8 32, i8 97, i8 115, i8 73, i8 110, i8 116, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@.str12 = private constant [27 x i8] [i8 97, i8 114, i8 114, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 44, i8 32, i8 99, i8 111, i8 112, i8 121, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str13 = private constant [4 x i8] [i8 37, i8 100, i8 32, i8 0]
@.str14 = private constant [2 x i8] [i8 10, i8 0]
@.str15 = private constant [15 x i8] [i8 100, i8 105, i8 115, i8 116, i8 97, i8 110, i8 99, i8 101, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@.str16 = private constant [14 x i8] [i8 112, i8 32, i8 61, i8 32, i8 40, i8 37, i8 102, i8 44, i8 32, i8 37, i8 102, i8 41, i8 10, i8 0]
@.str17 = private constant [13 x i8] [i8 110, i8 111, i8 110, i8 101, i8 32, i8 105, i8 115, i8 32, i8 110, i8 105, i8 108, i8 10, i8 0]
@.str18 = private constant [12 x i8] [i8 112, i8 97, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str19 = private constant [5 x i8] [i8 114, i8 101, i8 100, i8 10, i8 0]
@.str20 = private constant [7 x i8] [i8 103, i8 114, i8 101, i8 101, i8 110, i8 10, i8 0]
@.str21 = private constant [6 x i8] [i8 98, i8 108, i8 117, i8 101, i8 10, i8 0]
@.str22 = private constant [8 x i8] [i8 107, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str23 = private constant [8 x i8] [i8 106, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str24 = private constant [13 x i8] [i8 108, i8 111, i8 103, i8 105, i8 99, i8 32, i8 119, i8 111, i8 114, i8 107, i8 115, i8 10, i8 0]
@.str25 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 80, i8 111, i8 105, i8 110, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@.str26 = private constant [16 x i8] [i8 115, i8 117, i8 109, i8 40, i8 48, i8 46, i8 46, i8 53, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --; sqrt

; `include` pastes a module's names directly into scope — used for C
; bindings and library modules. `import "mymodule"` instead requires a
; `mymodule.` prefix on every name it brings in (see docs/lang).; allows unsafe(...) below, from this line to the end of the file


; --- Types ------------------------------------------------------------------
;
; PascalCase for types, camelCase for everything else. Base types: Bool,
; IntX/NatX/WordX (8/16/32/64/128 — signed/unsigned/bitwise), CharX (8/16/32),
; FloatX (32/64), Str8/Str16/Str32 (= []CharX). Int/Nat/Float/... are
; C-named aliases from libc/ctypes64.
%main_Point = type {
	%Float64,
	%Float64
};

%main_Celsius = type %Float64;
%main_Meters = type %Float64;; newtype: distinct, never mixes with Float64
%main_Color = type %Nat8;
%main_Action = type void ();


; --- Globals ----------------------------------------------------------------
@callCount = internal global %Nat32 0; mutable global; `let` is for function bodies only


; --- Functions --------------------------------------------------------------
define internal %Float64 @distance(%main_Point %__a, %main_Point %__b) alwaysinline {
	%a = alloca %main_Point
	store %main_Point %__a, %main_Point* %a
	%b = alloca %main_Point
	store %main_Point %__b, %main_Point* %b
	%1 = getelementptr %main_Point, %main_Point* %a, %Int32 0, %Int32 0
	%2 = getelementptr %main_Point, %main_Point* %b, %Int32 0, %Int32 0
	%3 = load %Float64, %Float64* %1
	%4 = load %Float64, %Float64* %2
	%5 = fsub %Float64 %3, %4
	%6 = getelementptr %main_Point, %main_Point* %a, %Int32 0, %Int32 1
	%7 = getelementptr %main_Point, %main_Point* %b, %Int32 0, %Int32 1
	%8 = load %Float64, %Float64* %6
	%9 = load %Float64, %Float64* %7
	%10 = fsub %Float64 %8, %9
	%11 = fmul %Float64 %5, %5
	%12 = fmul %Float64 %10, %10
	%13 = fadd %Float64 %11, %12
	%14 = call %Double @sqrt(%Float64 %13)
	ret %Double %14
}

define internal %Int32 @sum(%Int32 %n) {
	%total = alloca %Int32, align 4
	%i = alloca %Int32, align 4
	store %Int32 0, %Int32* %total
	store %Int32 0, %Int32* %i
; while_1
	br label %again_1
again_1:
	%1 = load %Int32, %Int32* %i
	%2 = icmp slt %Int32 %1, %n
	br %Bool %2 , label %body_1, label %break_1
body_1:
	%3 = load %Int32, %Int32* %total
	%4 = load %Int32, %Int32* %i
	%5 = add %Int32 %3, %4
	store %Int32 %5, %Int32* %total
	%6 = load %Int32, %Int32* %i
	%7 = add %Int32 %6, 1
	store %Int32 %7, %Int32* %i
	br label %again_1
break_1:
	%8 = load %Int32, %Int32* %total
	ret %Int32 %8
}

define internal void @announce() {
	%1 = load %Nat32, %Nat32* @callCount
	%2 = add %Nat32 %1, 1
	store %Nat32 %2, %Nat32* @callCount
	%3 = load %Nat32, %Nat32* @callCount
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @.str1 to [0 x i8]*), %Nat32 %3)
	ret void
}

define internal void @tourValues() {
	%i32 = alloca %Int32, align 4
	%f64 = alloca %Float64, align 8
	%counter = alloca %Int32, align 4
	store %Int32 42, %Int32* %i32
	store %Float64 3.14159, %Float64* %f64
	%1 = load %Int32, %Int32* %i32
	%2 = load %Float64, %Float64* %f64
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @.str2 to [0 x i8]*), %Int32 %1, %Float64 %2)
	store %Int32 10, %Int32* %counter
	store %Int32 20, %Int32* %counter	; let: immutable
	%4 = load %Int32, %Int32* %counter
	%5 = add %Int32 %4, 30
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str3 to [0 x i8]*), %Int32 %5)
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str4 to [0 x i8]*), %Int64 3)
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str5 to [0 x i8]*), %Float64 1.8)
	%9 = zext %Nat8 200 to %Int32
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str6 to [0 x i8]*), %Int32 %9)
	%11 = zext %Char8 77 to %Int32
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str8 to [0 x i8]*), %Str8* bitcast ([15 x i8]* @.str7 to [0 x i8]*), %Int32 %11)
	ret void
}

define internal void @tourBits() {
	%u = alloca %Word32, align 4
	%v = alloca %Word32, align 4
	%narrow = alloca %Word32, align 4
	%full = alloca %Word32, align 4
	%w = alloca %Word64, align 8
	%asInt = alloca %Int64, align 8
	store %Word32 15, %Word32* %u
	store %Word32 51, %Word32* %v
	%1 = load %Word32, %Word32* %u
	%2 = load %Word32, %Word32* %v
	%3 = or %Word32 %1, %2
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str9 to [0 x i8]*), %Word32 %3)
	store %Word32 240, %Word32* %narrow
	store %Word32 4294967280, %Word32* %full
	%5 = load %Word32, %Word32* %narrow
	%6 = load %Word32, %Word32* %full
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @.str10 to [0 x i8]*), %Word32 %5, %Word32 %6)
	store %Word64 9223372036854775808, %Word64* %w
	%8 = load %Word64, %Word64* %w
	%9 = bitcast %Word64 %8 to %Int64
	store %Int64 %9, %Int64* %asInt
	%10 = load %Word64, %Word64* %w
	%11 = load %Int64, %Int64* %asInt
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str11 to [0 x i8]*), %Word64 %10, %Int64 %11)
	ret void
}

define internal void @tourData() {
	%arr = alloca [5 x %Int32], align 4
	%copy = alloca [5 x %Int32], align 4
	%i = alloca %Nat32, align 4
	%origin = alloca %main_Point
	%corner = alloca %main_Point
	%p = alloca %main_Point, align 8
	%pp = alloca %main_Point*, align 8
	%none = alloca %main_Point*, align 8
	%1 = insertvalue [5 x %Int32] zeroinitializer, %Int32 1, 0
	%2 = insertvalue [5 x %Int32] %1, %Int32 2, 1
	%3 = insertvalue [5 x %Int32] %2, %Int32 3, 2
	%4 = insertvalue [5 x %Int32] %3, %Int32 4, 3
	%5 = insertvalue [5 x %Int32] %4, %Int32 5, 4
	store [5 x %Int32] %5, [5 x %Int32]* %arr
	%6 = load [5 x %Int32], [5 x %Int32]* %arr
	store [5 x %Int32] %6, [5 x %Int32]* %copy
	%7 = getelementptr [5 x %Int32], [5 x %Int32]* %copy, %Int32 0, %Int32 0
	store %Int32 100, %Int32* %7
	%8 = getelementptr [5 x %Int32], [5 x %Int32]* %arr, %Int32 0, %Int32 0
	%9 = load %Int32, %Int32* %8
	%10 = getelementptr [5 x %Int32], [5 x %Int32]* %copy, %Int32 0, %Int32 0
	%11 = load %Int32, %Int32* %10
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @.str12 to [0 x i8]*), %Int32 %9, %Int32 %11)	; 1, 100
	store %Nat32 0, %Nat32* %i
; while_1
	br label %again_1
again_1:
	%13 = load %Nat32, %Nat32* %i
	%14 = icmp ult %Nat32 %13, 5
	br %Bool %14 , label %body_1, label %break_1
body_1:
	%15 = load %Nat32, %Nat32* %i
	%16 = bitcast %Nat32 %15 to %Nat32
	%17 = getelementptr [5 x %Int32], [5 x %Int32]* %arr, %Int32 0, %Nat32 %16
	%18 = load %Int32, %Int32* %17
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @.str13 to [0 x i8]*), %Int32 %18)
	%20 = load %Nat32, %Nat32* %i
	%21 = add %Nat32 %20, 1
	store %Nat32 %21, %Nat32* %i
	br label %again_1
break_1:
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str14 to [0 x i8]*))
	store %main_Point zeroinitializer, %main_Point* %origin
	%23 = insertvalue %main_Point zeroinitializer, %Float64 3.0, 0
	%24 = insertvalue %main_Point %23, %Float64 4.0, 1
	store %main_Point %24, %main_Point* %corner
; if_0
	br %Bool 1 , label %then_0, label %endif_0
then_0:
	%25 = load %main_Point, %main_Point* %origin
	%26 = load %main_Point, %main_Point* %corner
	%27 = call %Float64 @distance(%main_Point %25, %main_Point %26)
	%28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str15 to [0 x i8]*), %Float64 %27)
	br label %endif_0
endif_0:
	%29 = load %main_Point, %main_Point* %corner
	store %main_Point %29, %main_Point* %p
	store %main_Point* %p, %main_Point** %pp
	%30 = load %main_Point*, %main_Point** %pp
	%31 = getelementptr %main_Point, %main_Point* %30, %Int32 0, %Int32 0
	store %Float64 99.0, %Float64* %31
	%32 = load %main_Point*, %main_Point** %pp
	%33 = insertvalue %main_Point zeroinitializer, %Float64 1.0, 0
	%34 = insertvalue %main_Point %33, %Float64 2.0, 1
	store %main_Point %34, %main_Point* %32
	%35 = getelementptr %main_Point, %main_Point* %p, %Int32 0, %Int32 0
	%36 = load %Float64, %Float64* %35
	%37 = getelementptr %main_Point, %main_Point* %p, %Int32 0, %Int32 1
	%38 = load %Float64, %Float64* %37
	%39 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str16 to [0 x i8]*), %Float64 %36, %Float64 %38)
	store %main_Point* null, %main_Point** %none
; if_1
	%40 = load %main_Point*, %main_Point** %none
	%41 = icmp eq %main_Point* %40, null
	br %Bool %41 , label %then_1, label %endif_1
then_1:
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str17 to [0 x i8]*))
	br label %endif_1
endif_1:
	%43 = bitcast [5 x %Int32]* %arr to [0 x %Int32]*
	%44 = getelementptr [0 x %Int32], [0 x %Int32]* %43, %Int32 0, %Int32 1
	%45 = load %Int32, %Int32* %44
	%46 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str18 to [0 x i8]*), %Int32 %45)
	ret void
}

define internal void @tourControl() {
	%k = alloca %Int32, align 4
	%j = alloca %Int32, align 4
	%cb = alloca %main_Action*, align 8
; if_0
	br %Bool 0 , label %then_0, label %else_0
then_0:
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @.str19 to [0 x i8]*))
	br label %endif_0
else_0:
; if_1
	br %Bool 1 , label %then_1, label %else_1
then_1:
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @.str20 to [0 x i8]*))
	br label %endif_1
else_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @.str21 to [0 x i8]*))
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	store %Int32 0, %Int32* %k
; while_1
	br label %again_1
again_1:
	%4 = load %Int32, %Int32* %k
	%5 = icmp slt %Int32 %4, 5
	br %Bool %5 , label %body_1, label %break_1
body_1:
	%6 = load %Int32, %Int32* %k
	%7 = add %Int32 %6, 1
	store %Int32 %7, %Int32* %k
; if_2
	%8 = load %Int32, %Int32* %k
	%9 = icmp eq %Int32 %8, 3
	br %Bool %9 , label %then_2, label %endif_2
then_2:
	br label %again_1
	br label %endif_2
endif_2:
	%11 = load %Int32, %Int32* %k
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str22 to [0 x i8]*), %Int32 %11)
	br label %again_1
break_1:
	store %Int32 0, %Int32* %j
; while_2
	br label %again_2
again_2:
	br %Bool 1 , label %body_2, label %break_2
body_2:
; if_3
	%13 = load %Int32, %Int32* %j
	%14 = icmp eq %Int32 %13, 2
	br %Bool %14 , label %then_3, label %endif_3
then_3:
	br label %break_2
	br label %endif_3
endif_3:
	%16 = load %Int32, %Int32* %j
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str23 to [0 x i8]*), %Int32 %16)
	%18 = load %Int32, %Int32* %j
	%19 = add %Int32 %18, 1
	store %Int32 %19, %Int32* %j
	br label %again_2
break_2:
; if_4
	%20 = load %Int32, %Int32* %j
	%21 = icmp sgt %Int32 %20, 0
	%22 = load %Int32, %Int32* %k
	%23 = icmp slt %Int32 %22, 0
	%24 = xor %Bool %23, 1
	%25 = and %Bool %21, %24
	br %Bool %25 , label %then_4, label %endif_4
then_4:
	%26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str24 to [0 x i8]*))
	br label %endif_4
endif_4:
	store %main_Action* @announce, %main_Action** %cb
	%27 = load %main_Action*, %main_Action** %cb
	call void %27()
	%28 = load %main_Action*, %main_Action** %cb
	call void %28()
	ret void
}

define %Int @main() {
	call void @tourValues()
	call void @tourBits()
	call void @tourData()
	call void @tourControl()
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str25 to [0 x i8]*), %Size 16)
	%2 = call %Int32 @sum(%Int32 5)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str26 to [0 x i8]*), %Int32 %2)
	ret %Int 0
}


