
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

; MODULE: lib

; -- print includes --
; -- end print includes --
; -- print imports 'lib' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'lib' --
; -- strings --
; -- endstrings --
%lib_Celsius = type %Fixed32;

