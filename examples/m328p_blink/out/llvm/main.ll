
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
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"

; from import "delay"
declare void @delay_ms(%Nat32 %x)

; end from import "delay"
; from included avr
%avr_IO8 = type %Word8;
%avr_IO16 = type %Word16;

; from import "avr"
%m328p_GPIO = type <{
	%avr_IO8,
	%avr_IO8,
	%avr_IO8
}>;


; end from import "avr"
; -- end print imports 'main' --
; -- strings --
; -- endstrings --
define %Int16 @main() {
	%1 = getelementptr %m328p_GPIO, %m328p_GPIO* null, %Int32 0, %Int32 1
	%2 = bitcast i8 255 to %avr_IO8
	store %avr_IO8 %2, %avr_IO8* %1
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%3 = getelementptr %m328p_GPIO, %m328p_GPIO* null, %Int32 0, %Int32 2
	%4 = bitcast i8 255 to %avr_IO8
	store %avr_IO8 %4, %avr_IO8* %3
	call void @delay_ms(%Nat32 1000)
	%5 = getelementptr %m328p_GPIO, %m328p_GPIO* null, %Int32 0, %Int32 2
	%6 = bitcast i8 0 to %avr_IO8
	store %avr_IO8 %6, %avr_IO8* %5
	call void @delay_ms(%Nat32 1000)
	br label %again_1
break_1:
	ret %Int16 0
}


