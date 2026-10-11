
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

; MODULE: fsm

; -- print includes --
; from included assert
declare void @assert(%Bool %cond)
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
; -- print imports 'fsm' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'fsm' --
; -- strings --
@.str1 = private constant [52 x i8] [i8 91, i8 37, i8 115, i8 93, i8 32, i8 102, i8 115, i8 109, i8 32, i8 116, i8 105, i8 109, i8 101, i8 111, i8 117, i8 116, i8 32, i8 40, i8 37, i8 117, i8 41, i8 32, i8 111, i8 99, i8 99, i8 117, i8 114, i8 101, i8 100, i8 44, i8 32, i8 115, i8 119, i8 105, i8 116, i8 99, i8 104, i8 95, i8 116, i8 111, i8 95, i8 115, i8 116, i8 97, i8 103, i8 101, i8 40, i8 37, i8 100, i8 41, i8 10, i8 0]
@.str2 = private constant [23 x i8] [i8 91, i8 37, i8 115, i8 93, i8 32, i8 35, i8 37, i8 115, i8 95, i8 37, i8 117, i8 32, i8 45, i8 62, i8 32, i8 35, i8 37, i8 115, i8 95, i8 37, i8 117, i8 10, i8 0]
@.str3 = private constant [7 x i8] [i8 60, i8 110, i8 117, i8 108, i8 108, i8 62, i8 0]
; -- endstrings --
%fsm_StageId = type %Word16;
%fsm_ComplexState = type {
	%fsm_StateDesc*,
	%fsm_StageId
};

%fsm_StateServiceRoutine = type %fsm_ComplexState (%fsm_ComplexState, i8*);
%fsm_StateDesc = type {
	%Str8*,
	%Nat16,
	%fsm_StateServiceRoutine*
};

%fsm_FSM = type {
	%Str8*,
	%fsm_ComplexState,
	%fsm_ComplexState,
	i8*,
	%Nat32,
	%Bool
};

define void @fsm_init(%fsm_FSM* %self, %Str8* %id, %fsm_StateDesc* %initState, i8* %payload) {
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 0
	store %Str8* %id, %Str8** %1
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
	%3 = insertvalue %fsm_ComplexState zeroinitializer, %fsm_StateDesc* %initState, 0
	store %fsm_ComplexState %3, %fsm_ComplexState* %2
	%4 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2
	%5 = insertvalue %fsm_ComplexState zeroinitializer, %fsm_StateDesc* %initState, 0
	store %fsm_ComplexState %5, %fsm_ComplexState* %4
	%6 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 3
	store i8* %payload, i8** %6
	%7 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	store %Nat32 0, %Nat32* %7
	%8 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	store %Bool 0, %Bool* %8
	ret void
}

define void @fsm_task(%fsm_FSM* %self) {
	%state = alloca %fsm_ComplexState
	%next_state = alloca %fsm_ComplexState
; if_0
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	%2 = load %Bool, %Bool* %1
	br %Bool %2 , label %then_0, label %endif_0
then_0:
	%3 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	store %Bool 0, %Bool* %3
	%4 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2
	%5 = call %fsm_ComplexState @fsm_cmdNextStage(%fsm_FSM* %self)
	store %fsm_ComplexState %5, %fsm_ComplexState* %4
	%6 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 0
	%7 = load %Str8*, %Str8** %6
	%8 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2, %Int32 1
	%9 = load %fsm_StageId, %fsm_StageId* %8
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([52 x i8]* @.str1 to [0 x i8]*), %Str8* %7, %Nat32 0, %fsm_StageId %9)
	br label %endif_0
endif_0:
; if_1
	%11 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2
	%12 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
	%13 = bitcast %fsm_ComplexState* %11 to i8*
	%14 = bitcast %fsm_ComplexState* %12 to i8*
	%15 = call i1 (i8*, i8*, i64) @memeq(i8* %13, i8* %14, %Int64 16)
	%16 = icmp eq %Bool %15, 0
	br %Bool %16 , label %then_1, label %endif_1
then_1:
	%17 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
	%18 = load %fsm_ComplexState, %fsm_ComplexState* %17
	store %fsm_ComplexState %18, %fsm_ComplexState* %state
	%19 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2
	%20 = load %fsm_ComplexState, %fsm_ComplexState* %19
	store %fsm_ComplexState %20, %fsm_ComplexState* %next_state
	%21 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 0
	%22 = load %Str8*, %Str8** %21
	%23 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 0
	%24 = load %fsm_StateDesc*, %fsm_StateDesc** %23
	%25 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %24, %Int32 0, %Int32 0
	%26 = load %Str8*, %Str8** %25
	%27 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%28 = load %fsm_StageId, %fsm_StageId* %27
	%29 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %next_state, %Int32 0, %Int32 0
	%30 = load %fsm_StateDesc*, %fsm_StateDesc** %29
	%31 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %30, %Int32 0, %Int32 0
	%32 = load %Str8*, %Str8** %31
	%33 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %next_state, %Int32 0, %Int32 1
	%34 = load %fsm_StageId, %fsm_StageId* %33
	%35 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @.str2 to [0 x i8]*), %Str8* %22, %Str8* %26, %fsm_StageId %28, %Str8* %32, %fsm_StageId %34)
	%36 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
	%37 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2
	%38 = load %fsm_ComplexState, %fsm_ComplexState* %37
	store %fsm_ComplexState %38, %fsm_ComplexState* %36
	br label %endif_1
endif_1:
	%39 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1, %Int32 0
	%40 = load %fsm_StateDesc*, %fsm_StateDesc** %39
	%41 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %40, %Int32 0, %Int32 2
	%42 = load %fsm_StateServiceRoutine*, %fsm_StateServiceRoutine** %41
	%43 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 2
	%44 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
	%45 = load %fsm_ComplexState, %fsm_ComplexState* %44
	%46 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 3
	%47 = load i8*, i8** %46
	%48 = call %fsm_ComplexState %42(%fsm_ComplexState %45, i8* %47)
	store %fsm_ComplexState %48, %fsm_ComplexState* %43
	ret void
}

define void @fsm_tick(%fsm_FSM* %self) {
; if_0
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	%2 = load %Nat32, %Nat32* %1
	%3 = icmp ugt %Nat32 %2, 0
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	%5 = load %Nat32, %Nat32* %4
	%6 = sub %Nat32 %5, 1
	store %Nat32 %6, %Nat32* %4
; if_1
	%7 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	%8 = load %Nat32, %Nat32* %7
	%9 = icmp eq %Nat32 %8, 0
	br %Bool %9 , label %then_1, label %endif_1
then_1:
	%10 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	store %Bool 1, %Bool* %10
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

define %fsm_ComplexState @fsm_cmdSwitchState(%fsm_FSM* %self, %fsm_StateDesc* %state) {
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	store %Nat32 0, %Nat32* %1
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	store %Bool 0, %Bool* %2
	%3 = insertvalue %fsm_ComplexState zeroinitializer, %fsm_StateDesc* %state, 0
	ret %fsm_ComplexState %3
}

define %fsm_ComplexState @fsm_cmdSwitchStage(%fsm_FSM* %self, %Word16 %stage) {
	%newState = alloca %fsm_ComplexState, align 8
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	store %Nat32 0, %Nat32* %1
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	store %Bool 0, %Bool* %2
	%3 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
	%4 = load %fsm_ComplexState, %fsm_ComplexState* %3
	store %fsm_ComplexState %4, %fsm_ComplexState* %newState
	%5 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %newState, %Int32 0, %Int32 1
	%6 = bitcast %Word16 %stage to %fsm_StageId
	store %fsm_StageId %6, %fsm_StageId* %5
	%7 = load %fsm_ComplexState, %fsm_ComplexState* %newState
	ret %fsm_ComplexState %7
}

define %fsm_ComplexState @fsm_cmdNextStage(%fsm_FSM* %self) {
	%state = alloca %fsm_ComplexState
	%newState = alloca %fsm_ComplexState, align 8
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	store %Nat32 0, %Nat32* %1
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 5
	store %Bool 0, %Bool* %2
	%3 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
	%4 = load %fsm_ComplexState, %fsm_ComplexState* %3
	store %fsm_ComplexState %4, %fsm_ComplexState* %state
	%5 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%6 = load %fsm_StageId, %fsm_StageId* %5
	%7 = bitcast %fsm_StageId %6 to %Nat16
	%8 = add %Nat16 %7, 1
	%9 = load %fsm_ComplexState, %fsm_ComplexState* %state
	store %fsm_ComplexState %9, %fsm_ComplexState* %newState
	%10 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %newState, %Int32 0, %Int32 1
	%11 = bitcast %Nat16 %8 to %fsm_StageId
	store %fsm_StageId %11, %fsm_StageId* %10
	%12 = load %fsm_ComplexState, %fsm_ComplexState* %newState
	ret %fsm_ComplexState %12
}

define %fsm_ComplexState @fsm_cmdNextStageLimited(%fsm_FSM* %self, %Nat32 %t) {
	%state = alloca %fsm_ComplexState
	%newState = alloca %fsm_ComplexState, align 8
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 4
	store %Nat32 %t, %Nat32* %1
	%2 = getelementptr %fsm_FSM, %fsm_FSM* %self, %Int32 0, %Int32 1
	%3 = load %fsm_ComplexState, %fsm_ComplexState* %2
	store %fsm_ComplexState %3, %fsm_ComplexState* %state
	%4 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %state, %Int32 0, %Int32 1
	%5 = load %fsm_StageId, %fsm_StageId* %4
	%6 = bitcast %fsm_StageId %5 to %Nat16
	%7 = add %Nat16 %6, 1
	%8 = load %fsm_ComplexState, %fsm_ComplexState* %state
	store %fsm_ComplexState %8, %fsm_ComplexState* %newState
	%9 = getelementptr %fsm_ComplexState, %fsm_ComplexState* %newState, %Int32 0, %Int32 1
	%10 = bitcast %Nat16 %7 to %fsm_StageId
	store %fsm_StageId %10, %fsm_StageId* %9
	%11 = load %fsm_ComplexState, %fsm_ComplexState* %newState
	ret %fsm_ComplexState %11
}

define %fsm_ComplexState @fsm_getComplexState(%fsm_FSM %__fsm) {
	%fsm = alloca %fsm_FSM
	store %fsm_FSM %__fsm, %fsm_FSM* %fsm
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 1
	%2 = load %fsm_ComplexState, %fsm_ComplexState* %1
	ret %fsm_ComplexState %2
}

define %fsm_StateDesc* @fsm_getState(%fsm_FSM %__fsm) {
	%fsm = alloca %fsm_FSM
	store %fsm_FSM %__fsm, %fsm_FSM* %fsm
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 1, %Int32 0
	%2 = load %fsm_StateDesc*, %fsm_StateDesc** %1
	ret %fsm_StateDesc* %2
}

define %fsm_StageId @fsm_getStage(%fsm_FSM %__fsm) {
	%fsm = alloca %fsm_FSM
	store %fsm_FSM %__fsm, %fsm_FSM* %fsm
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 1, %Int32 1
	%2 = load %fsm_StageId, %fsm_StageId* %1
	ret %fsm_StageId %2
}

define %Str8* @fsm_getStateName(%fsm_FSM* %fsm) {
; if_0
	%1 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 1, %Int32 0
	%2 = load %fsm_StateDesc*, %fsm_StateDesc** %1
	%3 = icmp eq %fsm_StateDesc* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %Str8* bitcast ([7 x i8]* @.str3 to [0 x i8]*)
	br label %endif_0
endif_0:
	%5 = getelementptr %fsm_FSM, %fsm_FSM* %fsm, %Int32 0, %Int32 1, %Int32 0
	%6 = load %fsm_StateDesc*, %fsm_StateDesc** %5
	%7 = getelementptr %fsm_StateDesc, %fsm_StateDesc* %6, %Int32 0, %Int32 0
	%8 = load %Str8*, %Str8** %7
	ret %Str8* %8
}


