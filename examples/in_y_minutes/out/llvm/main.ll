
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
@.str1 = private constant [16 x i8] [i8 109, i8 111, i8 100, i8 101, i8 115, i8 116, i8 32, i8 115, i8 97, i8 121, i8 115, i8 32, i8 104, i8 105, i8 10, i8 0]
@.str2 = private constant [26 x i8] [i8 119, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 120, i8 32, i8 45, i8 62, i8 32, i8 97, i8 115, i8 73, i8 110, i8 116, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
@.str3 = private constant [13 x i8] [i8 104, i8 101, i8 105, i8 103, i8 104, i8 116, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@.str4 = private constant [15 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 44, i8 32, i8 77, i8 111, i8 100, i8 101, i8 115, i8 116, i8 33, i8 0]
@.str5 = private constant [21 x i8] [i8 37, i8 115, i8 32, i8 40, i8 115, i8 116, i8 97, i8 114, i8 116, i8 115, i8 32, i8 119, i8 105, i8 116, i8 104, i8 32, i8 37, i8 99, i8 41, i8 10, i8 0]
@.str6 = private constant [4 x i8] [i8 37, i8 100, i8 32, i8 0]
@.str7 = private constant [2 x i8] [i8 10, i8 0]
@.str8 = private constant [15 x i8] [i8 100, i8 105, i8 115, i8 116, i8 97, i8 110, i8 99, i8 101, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@.str9 = private constant [10 x i8] [i8 112, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@.str10 = private constant [16 x i8] [i8 99, i8 111, i8 108, i8 111, i8 114, i8 32, i8 105, i8 115, i8 32, i8 103, i8 114, i8 101, i8 101, i8 110, i8 10, i8 0]
@.str11 = private constant [12 x i8] [i8 117, i8 32, i8 124, i8 32, i8 118, i8 32, i8 61, i8 32, i8 37, i8 120, i8 10, i8 0]
@.str12 = private constant [8 x i8] [i8 107, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str13 = private constant [8 x i8] [i8 106, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str14 = private constant [13 x i8] [i8 108, i8 111, i8 103, i8 105, i8 99, i8 32, i8 119, i8 111, i8 114, i8 107, i8 115, i8 10, i8 0]
@.str15 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 80, i8 111, i8 105, i8 110, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 117, i8 10, i8 0]
@.str16 = private constant [16 x i8] [i8 115, i8 117, i8 109, i8 40, i8 48, i8 46, i8 46, i8 53, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --

; This is a line comment. There are no block comments.; sqrt


; `include` pastes a module's names directly into scope — used for C
; bindings and library modules. `import "mymodule"` instead requires a
; `mymodule.` prefix on every name it brings in (see docs/lang).


; --- Types ------------------------------------------------------------------
;
; PascalCase for types, camelCase for everything else. Base types: Bool,
; IntX/NatX/WordX (8/16/32/64/128 — signed/unsigned/bitwise), CharX (8/16/32),
; FloatX (32/64), Str8/Str16/Str32 (= []CharX), Int/Nat/Word (target width).
%Point = type {
	%Float64,
	%Float64
};

%Meters = type %Float64;
%Color = type %Nat8;
%Action = type void ();


; --- Functions ----------------------------------------------------------------
define internal %Float64 @distance(%Point %__a, %Point %__b) alwaysinline {
	%a = alloca %Point
	store %Point %__a, %Point* %a
	%b = alloca %Point
	store %Point %__b, %Point* %b
	%1 = getelementptr %Point, %Point* %a, %Int32 0, %Int32 0
	%2 = getelementptr %Point, %Point* %b, %Int32 0, %Int32 0
	%3 = load %Float64, %Float64* %1
	%4 = load %Float64, %Float64* %2
	%5 = fsub %Float64 %3, %4
	%6 = getelementptr %Point, %Point* %a, %Int32 0, %Int32 1
	%7 = getelementptr %Point, %Point* %b, %Int32 0, %Int32 1
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
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str1 to [0 x i8]*))
	ret void
}

define %Int @main() {
	%i32 = alloca %Int32, align 4
	%f64 = alloca %Float64, align 8
	%counter = alloca %Int32, align 4
	%locked = alloca %Int32, align 4
	%w = alloca %Word64, align 8
	%asInt = alloca %Int64, align 8
	%height = alloca %Meters, align 8
	%arr = alloca [5 x %Int32], align 4
	%slice = alloca [2 x %Int32], align 4
	%i = alloca %Nat32, align 4
	%origin = alloca %Point
	%corner = alloca %Point
	%p = alloca %Point, align 8
	%pp = alloca %Point*, align 8
	%c = alloca %Color, align 1
	%u = alloca %Word32, align 4
	%v = alloca %Word32, align 4
	%k = alloca %Int32, align 4
	%j = alloca %Int32, align 4
	%cb = alloca %Action*, align 8
	store %Int32 42, %Int32* %i32
	store %Float64 3.14159, %Float64* %f64
	store %Int32 10, %Int32* %counter
	store %Int32 20, %Int32* %counter
	store %Int32 40, %Int32* %locked
	store %Word64 9223372036854775808, %Word64* %w
	%1 = load %Word64, %Word64* %w
	%2 = bitcast %Word64 %1 to %Int64
	store %Int64 %2, %Int64* %asInt
	%3 = load %Word64, %Word64* %w
	%4 = load %Int64, %Int64* %asInt
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str2 to [0 x i8]*), %Word64 %3, %Int64 %4)
	store %Meters 1.8, %Meters* %height
	%6 = load %Meters, %Meters* %height
	%7 = bitcast %Meters %6 to %Float64
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str3 to [0 x i8]*), %Float64 %7)
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str5 to [0 x i8]*), %Str8* bitcast ([15 x i8]* @.str4 to [0 x i8]*), %Char8 77)
	%10 = insertvalue [5 x %Int32] zeroinitializer, %Int32 1, 0
	%11 = insertvalue [5 x %Int32] %10, %Int32 2, 1
	%12 = insertvalue [5 x %Int32] %11, %Int32 3, 2
	%13 = insertvalue [5 x %Int32] %12, %Int32 4, 3
	%14 = insertvalue [5 x %Int32] %13, %Int32 5, 4
	%15 = zext i8 5 to %Nat32
	store [5 x %Int32] %14, [5 x %Int32]* %arr
	%16 = zext i8 1 to %Nat32
	%17 = getelementptr [5 x %Int32], [5 x %Int32]* %arr, %Int32 0, %Nat32 %16
	%18 = bitcast %Int32* %17 to [2 x %Int32]*
	%19 = load [2 x %Int32], [2 x %Int32]* %18
	%20 = zext i8 2 to %Nat32
	store [2 x %Int32] %19, [2 x %Int32]* %slice
	store %Nat32 0, %Nat32* %i
; while_1
	br label %again_1
again_1:
	%21 = load %Nat32, %Nat32* %i
	%22 = icmp ult %Nat32 %21, 5
	br %Bool %22 , label %body_1, label %break_1
body_1:
	%23 = load %Nat32, %Nat32* %i
	%24 = bitcast %Nat32 %23 to %Nat32
	%25 = getelementptr [5 x %Int32], [5 x %Int32]* %arr, %Int32 0, %Nat32 %24
	%26 = load %Int32, %Int32* %25
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @.str6 to [0 x i8]*), %Int32 %26)
	%28 = load %Nat32, %Nat32* %i
	%29 = add %Nat32 %28, 1
	store %Nat32 %29, %Nat32* %i
	br label %again_1
break_1:
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str7 to [0 x i8]*))
	store %Point zeroinitializer, %Point* %origin
	%31 = insertvalue %Point zeroinitializer, %Float64 3.0, 0
	%32 = insertvalue %Point %31, %Float64 4.0, 1
	store %Point %32, %Point* %corner
	%33 = load %Point, %Point* %origin
	%34 = load %Point, %Point* %corner
	%35 = call %Float64 @distance(%Point %33, %Point %34)
	%36 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str8 to [0 x i8]*), %Float64 %35)
	%37 = load %Point, %Point* %corner
	store %Point %37, %Point* %p
	store %Point* %p, %Point** %pp
	%38 = load %Point*, %Point** %pp
	%39 = getelementptr %Point, %Point* %38, %Int32 0, %Int32 0
	store %Float64 99.0, %Float64* %39
	%40 = getelementptr %Point, %Point* %p, %Int32 0, %Int32 0
	%41 = load %Float64, %Float64* %40
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str9 to [0 x i8]*), %Float64 %41)
	store %Color 1, %Color* %c
; if_0
	%43 = load %Color, %Color* %c
	%44 = icmp eq %Color %43, 1
	br %Bool %44 , label %then_0, label %endif_0
then_0:
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str10 to [0 x i8]*))
	br label %endif_0
endif_0:
	%46 = zext i8 15 to %Word32
	store %Word32 %46, %Word32* %u
	%47 = zext i8 51 to %Word32
	store %Word32 %47, %Word32* %v
	%48 = load %Word32, %Word32* %u
	%49 = load %Word32, %Word32* %v
	%50 = or %Word32 %48, %49
	%51 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str11 to [0 x i8]*), %Word32 %50)
	store %Int32 0, %Int32* %k
; while_2
	br label %again_2
again_2:
	%52 = load %Int32, %Int32* %k
	%53 = icmp slt %Int32 %52, 5
	br %Bool %53 , label %body_2, label %break_2
body_2:
	%54 = load %Int32, %Int32* %k
	%55 = add %Int32 %54, 1
	store %Int32 %55, %Int32* %k
; if_1
	%56 = load %Int32, %Int32* %k
	%57 = icmp eq %Int32 %56, 3
	br %Bool %57 , label %then_1, label %endif_1
then_1:
	br label %again_2
	br label %endif_1
endif_1:
	%59 = load %Int32, %Int32* %k
	%60 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str12 to [0 x i8]*), %Int32 %59)
	br label %again_2
break_2:
	store %Int32 0, %Int32* %j
; while_3
	br label %again_3
again_3:
	br %Bool 1 , label %body_3, label %break_3
body_3:
; if_2
	%61 = load %Int32, %Int32* %j
	%62 = icmp eq %Int32 %61, 2
	br %Bool %62 , label %then_2, label %endif_2
then_2:
	br label %break_3
	br label %endif_2
endif_2:
	%64 = load %Int32, %Int32* %j
	%65 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str13 to [0 x i8]*), %Int32 %64)
	%66 = load %Int32, %Int32* %j
	%67 = add %Int32 %66, 1
	store %Int32 %67, %Int32* %j
	br label %again_3
break_3:
; if_3
	%68 = load %Int32, %Int32* %i32
	%69 = icmp sgt %Int32 %68, 0
	%70 = load %Int32, %Int32* %counter
	%71 = icmp slt %Int32 %70, 0
	%72 = xor %Bool %71, 1
	%73 = and %Bool %69, %72
	br %Bool %73 , label %then_3, label %endif_3
then_3:
	%74 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str14 to [0 x i8]*))
	br label %endif_3
endif_3:
	store %Action* @announce, %Action** %cb
	%75 = load %Action*, %Action** %cb
	call void %75()
	%76 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str15 to [0 x i8]*), %Size 16)
	%77 = call %Int32 @sum(%Int32 5)
	%78 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str16 to [0 x i8]*), %Int32 %77)
	ret %Int 0
}


