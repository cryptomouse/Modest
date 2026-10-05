
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


; MODULE: delay

; -- print includes --
; -- end print includes --
; -- print imports 'delay' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'delay' --
; -- strings --
; -- endstrings --
define void @delay_ms(%Nat32 %x) {
	%1 = alloca %Nat32, align 4
	store %Nat32 %x, %Nat32* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Nat32, %Nat32* %1
	%3 = icmp ugt %Nat32 %2, 0
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %4
; while_2
	br label %again_2
again_2:
	%5 = load %Nat32, %Nat32* %4
	%6 = icmp ult %Nat32 %5, 380
	br %Bool %6 , label %body_2, label %break_2
body_2:
	%7 = load %Nat32, %Nat32* %4
	%8 = add %Nat32 %7, 1
	store %Nat32 %8, %Nat32* %4
	br label %again_2
break_2:
	%9 = load %Nat32, %Nat32* %1
	%10 = sub %Nat32 %9, 1
	store %Nat32 %10, %Nat32* %1
	br label %again_1
break_1:
	ret void
}


