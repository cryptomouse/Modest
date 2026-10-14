
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

; from import "queue"
%queue_Queue = type {
	%Nat32,
	%Nat32,
	%Nat32,
	%Nat32
};

declare %Bool @queue_init(%queue_Queue* %q, %Nat32 %capacity)
declare void @queue_deinit(%queue_Queue* %q)
declare void @queue_clear(%queue_Queue* %q)
declare %Nat32 @queue_capacity(%queue_Queue* %q)
declare %Nat32 @queue_size(%queue_Queue* %q)
declare %Bool @queue_isEmpty(%queue_Queue* %q)
declare %Bool @queue_isFull(%queue_Queue* %q)
declare %Nat32 @queue_getPutPosition(%queue_Queue* %q)
declare %Nat32 @queue_getGetPosition(%queue_Queue* %q)

; end from import "queue"

; from import "bq"
%queueWord8_QueueWord8 = type {
	%queue_Queue,
	[0 x %Word8]*
};

declare %Bool @queueWord8_init(%queueWord8_QueueWord8* %q, [0 x %Word8]* %buf, %Nat32 %capacity)
declare void @queueWord8_deinit(%queueWord8_QueueWord8* %q)
declare %Nat32 @queueWord8_capacity(%queueWord8_QueueWord8* %q)
declare %Nat32 @queueWord8_size(%queueWord8_QueueWord8* %q)
declare %Bool @queueWord8_isFull(%queueWord8_QueueWord8* %q)
declare %Bool @queueWord8_isEmpty(%queueWord8_QueueWord8* %q)
declare %Bool @queueWord8_put(%queueWord8_QueueWord8* %q, %Word8 %b)
declare %Bool @queueWord8_get(%queueWord8_QueueWord8* %q, %Word8* %b)
declare %Nat32 @queueWord8_read(%queueWord8_QueueWord8* %q, [0 x %Word8]* %data, %Nat32 %len)
declare %Nat32 @queueWord8_write(%queueWord8_QueueWord8* %q, [0 x %Word8]* %data, %Nat32 %len)
declare void @queueWord8_clear(%queueWord8_QueueWord8* %q)

; end from import "bq"

; from import "br"
%ringWord8_RingWord8 = type {
	%queue_Queue,
	[0 x %Word8]*
};

declare %Bool @ringWord8_init(%ringWord8_RingWord8* %q, [0 x %Word8]* %buf, %Nat32 %capacity)
declare void @ringWord8_deinit(%ringWord8_RingWord8* %q)
declare void @ringWord8_clear(%ringWord8_RingWord8* %q)
declare %Nat32 @ringWord8_capacity(%ringWord8_RingWord8* %q)
declare %Nat32 @ringWord8_size(%ringWord8_RingWord8* %q)
declare %Bool @ringWord8_isFull(%ringWord8_RingWord8* %q)
declare %Bool @ringWord8_isEmpty(%ringWord8_RingWord8* %q)
declare %Bool @ringWord8_put(%ringWord8_RingWord8* %q, %Word8 %b)
declare %Bool @ringWord8_get(%ringWord8_RingWord8* %q, %Word8* %b)

; end from import "br"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [17 x i8] [i8 60, i8 113, i8 117, i8 101, i8 117, i8 101, i8 32, i8 105, i8 115, i8 32, i8 102, i8 117, i8 108, i8 108, i8 62, i8 10, i8 0]
@.str2 = private constant [12 x i8] [i8 98, i8 113, i8 46, i8 112, i8 117, i8 116, i8 40, i8 37, i8 100, i8 41, i8 10, i8 0]
@.str3 = private constant [18 x i8] [i8 60, i8 113, i8 117, i8 101, i8 117, i8 101, i8 32, i8 105, i8 115, i8 32, i8 101, i8 109, i8 112, i8 116, i8 121, i8 62, i8 10, i8 0]
@.str4 = private constant [23 x i8] [i8 98, i8 113, i8 46, i8 103, i8 101, i8 116, i8 32, i8 61, i8 32, i8 37, i8 100, i8 44, i8 32, i8 114, i8 101, i8 115, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str5 = private constant [16 x i8] [i8 98, i8 113, i8 46, i8 105, i8 110, i8 105, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
@bq0 = internal global %queueWord8_QueueWord8 zeroinitializer
@br0 = internal global %ringWord8_RingWord8 zeroinitializer
@ii = internal global %Int32 0
define internal void @fill(%Nat32 %n) {
	%i = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %i
; while_1
	br label %again_1
again_1:
	%1 = load %Nat32, %Nat32* %i
	%2 = icmp ult %Nat32 %1, %n
	br %Bool %2 , label %body_1, label %break_1
body_1:
; if_0
	%3 = call %Bool @queueWord8_isFull(%queueWord8_QueueWord8* @bq0)
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str1 to [0 x i8]*))
	br label %break_1
	br label %endif_0
endif_0:
	%6 = load %Int32, %Int32* @ii
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str2 to [0 x i8]*), %Int32 %6)
	%8 = load %Int32, %Int32* @ii
	%9 = trunc %Int32 %8 to %Word8
	%10 = call %Bool @queueWord8_put(%queueWord8_QueueWord8* @bq0, %Word8 %9)
	%11 = load %Nat32, %Nat32* %i
	%12 = add %Nat32 %11, 1
	store %Nat32 %12, %Nat32* %i
	%13 = load %Int32, %Int32* @ii
	%14 = add %Int32 %13, 1
	store %Int32 %14, %Int32* @ii
	br label %again_1
break_1:
	ret void
}

define internal void @fetch(%Nat32 %n) {
	%i = alloca %Nat32, align 4
	%x = alloca %Word8, align 1
	store %Nat32 0, %Nat32* %i
; while_1
	br label %again_1
again_1:
	%1 = load %Nat32, %Nat32* %i
	%2 = icmp ult %Nat32 %1, %n
	br %Bool %2 , label %body_1, label %break_1
body_1:
; if_0
	%3 = call %Bool @queueWord8_isEmpty(%queueWord8_QueueWord8* @bq0)
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @.str3 to [0 x i8]*))
	br label %break_1
	br label %endif_0
endif_0:
	store %Word8 0, %Word8* %x
	%6 = call %Bool @queueWord8_get(%queueWord8_QueueWord8* @bq0, %Word8* %x)
	%7 = load %Word8, %Word8* %x
	%8 = sext %Word8 %7 to %Int
	%9 = zext %Bool %6 to %Word8
	%10 = zext %Word8 %9 to %Word32
	%11 = bitcast %Word32 %10 to %Int
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @.str4 to [0 x i8]*), %Int %8, %Int %11)
	%13 = load %Nat32, %Nat32* %i
	%14 = add %Nat32 %13, 1
	store %Nat32 %14, %Nat32* %i
	br label %again_1
break_1:
	ret void
}

@qbuf = internal global [10 x %Word8] zeroinitializer
define %Int @main() {
; if_0
	%1 = bitcast [10 x %Word8]* @qbuf to [0 x %Word8]*
	%2 = call %Bool @queueWord8_init(%queueWord8_QueueWord8* @bq0, [0 x %Word8]* %1, %Nat32 10)
	%3 = xor %Bool %2, 1
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @.str5 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	call void @fill(%Nat32 3)
	call void @fetch(%Nat32 7)
	call void @fill(%Nat32 12)
	call void @fetch(%Nat32 7)
	call void @fill(%Nat32 3)
	call void @fetch(%Nat32 7)
	call void @queueWord8_deinit(%queueWord8_QueueWord8* @bq0)
	ret %Int 0
}


