
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


; MODULE: list

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
; from included stdlib
declare void @abort()
declare %Int @abs(%Int %x)
declare %Int @atexit(void ()* %x)
declare %Double @atof([0 x %ConstChar]* %nptr)
declare %Int @atoi([0 x %ConstChar]* %nptr)
declare %LongInt @atol([0 x %ConstChar]* %nptr)
declare i8* @calloc(%SizeT %num, %SizeT %size)
declare void @exit(%Int %x)
declare void @free(i8* %ptr)
declare %Str* @getenv(%Str* %name)
declare %LongInt @labs(%LongInt %x)
declare %Str* @secure_getenv(%Str* %name)
declare i8* @malloc(%SizeT %size)
declare %Int @system([0 x %ConstChar]* %string)
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
; -- print imports 'list' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'list' --
; -- strings --
@.str1 = private constant [14 x i8] [i8 110, i8 111, i8 100, i8 101, i8 95, i8 103, i8 101, i8 116, i8 40, i8 37, i8 100, i8 41, i8 10, i8 0]
@.str2 = private constant [17 x i8] [i8 110, i8 111, i8 100, i8 101, i8 95, i8 105, i8 110, i8 115, i8 101, i8 114, i8 116, i8 40, i8 37, i8 100, i8 41, i8 10, i8 0]
; -- endstrings --
%list_Node = type {
	%list_Node*,
	%list_Node*,
	i8*
};

%list_List = type {
	%list_Node*,
	%list_Node*,
	%Nat32
};

define %list_List* @list_create() {
	%1 = call i8* @malloc(%SizeT 24)
	%2 = bitcast i8* %1 to %list_List*
; if_0
	%3 = icmp eq %list_List* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %list_List* null
	br label %endif_0
endif_0:
	store %list_List zeroinitializer, %list_List* %2
	ret %list_List* %2
}

define %Nat32 @list_size_get(%list_List* %list) {
; if_0
	%1 = icmp eq %list_List* %list, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Nat32 0
	br label %endif_0
endif_0:
	%3 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%4 = load %Nat32, %Nat32* %3
	ret %Nat32 %4
}

define %list_Node* @list_first_node_get(%list_List* %list) {
; if_0
	%1 = icmp eq %list_List* %list, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 0
	%4 = load %list_Node*, %list_Node** %3
	ret %list_Node* %4
}

define %list_Node* @list_last_node_get(%list_List* %list) {
; if_0
	%1 = icmp eq %list_List* %list, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 1
	%4 = load %list_Node*, %list_Node** %3
	ret %list_Node* %4
}

define %list_Node* @list_node_first(%list_List* %list, %list_Node* %new_node) {
; if_0
	%1 = icmp eq %list_List* %list, null
	%2 = icmp eq %list_Node* %new_node, null
	%3 = or %Bool %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%5 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 0
	store %list_Node* %new_node, %list_Node** %5
	%6 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 1
	store %list_Node* %new_node, %list_Node** %6
	%7 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%8 = load %Nat32, %Nat32* %7
	%9 = add %Nat32 %8, 1
	store %Nat32 %9, %Nat32* %7
	ret %list_Node* %new_node
}

define %list_Node* @list_node_create() {
	%1 = call i8* @malloc(%SizeT 24)
	%2 = bitcast i8* %1 to %list_Node*
; if_0
	%3 = icmp eq %list_Node* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	store %list_Node zeroinitializer, %list_Node* %2
	ret %list_Node* %2
}

define %list_Node* @list_node_next_get(%list_Node* %node) {
; if_0
	%1 = icmp eq %list_Node* %node, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr %list_Node, %list_Node* %node, %Int32 0, %Int32 0
	%4 = load %list_Node*, %list_Node** %3
	ret %list_Node* %4
}

define %list_Node* @list_node_prev_get(%list_Node* %node) {
; if_0
	%1 = icmp eq %list_Node* %node, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%3 = getelementptr %list_Node, %list_Node* %node, %Int32 0, %Int32 1
	%4 = load %list_Node*, %list_Node** %3
	ret %list_Node* %4
}

define i8* @list_node_data_get(%list_Node* %node) {
; if_0
	%1 = icmp eq %list_Node* %node, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret i8* null
	br label %endif_0
endif_0:
	%3 = getelementptr %list_Node, %list_Node* %node, %Int32 0, %Int32 2
	%4 = load i8*, i8** %3
	ret i8* %4
}

define void @list_node_insert_right(%list_Node* %left, %list_Node* %new_right) {
	%1 = getelementptr %list_Node, %list_Node* %left, %Int32 0, %Int32 0
	%2 = load %list_Node*, %list_Node** %1
	%3 = getelementptr %list_Node, %list_Node* %left, %Int32 0, %Int32 0
	store %list_Node* %new_right, %list_Node** %3
; if_0
	%4 = icmp ne %list_Node* %2, null
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = getelementptr %list_Node, %list_Node* %2, %Int32 0, %Int32 1
	store %list_Node* %new_right, %list_Node** %5
	br label %endif_0
endif_0:
	%6 = getelementptr %list_Node, %list_Node* %new_right, %Int32 0, %Int32 0
	store %list_Node* %2, %list_Node** %6
	%7 = getelementptr %list_Node, %list_Node* %new_right, %Int32 0, %Int32 1
	store %list_Node* %left, %list_Node** %7
	ret void
}

define %list_Node* @list_node_get(%list_List* %list, %Int32 %pos) {
	%node = alloca %list_Node*, align 8
	%i = alloca %Nat32, align 4
	%i.2 = alloca %Nat32, align 4
; if_0
	%1 = icmp eq %list_List* %list, null
	%2 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%3 = load %Nat32, %Nat32* %2
	%4 = icmp eq %Nat32 %3, 0
	%5 = or %Bool %1, %4
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str1 to [0 x i8]*), %Int32 %pos)
	store %list_Node* null, %list_Node** %node
; if_1
	%8 = icmp sge %Int32 %pos, 0
	br %Bool %8 , label %then_1, label %else_1
then_1:
	%9 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 0
	%10 = load %list_Node*, %list_Node** %9
	store %list_Node* %10, %list_Node** %node
	%11 = bitcast %Int32 %pos to %Nat32
; if_2
	%12 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%13 = load %Nat32, %Nat32* %12
	%14 = icmp ugt %Nat32 %11, %13
	br %Bool %14 , label %then_2, label %endif_2
then_2:
	ret %list_Node* null
	br label %endif_2
endif_2:
	store %Nat32 0, %Nat32* %i
; while_1
	br label %again_1
again_1:
	%16 = load %Nat32, %Nat32* %i
	%17 = icmp ult %Nat32 %16, %11
	br %Bool %17 , label %body_1, label %break_1
body_1:
	%18 = load %list_Node*, %list_Node** %node
	%19 = getelementptr %list_Node, %list_Node* %18, %Int32 0, %Int32 0
	%20 = load %list_Node*, %list_Node** %19
	store %list_Node* %20, %list_Node** %node
	%21 = load %Nat32, %Nat32* %i
	%22 = add %Nat32 %21, 1
	store %Nat32 %22, %Nat32* %i
	br label %again_1
break_1:
	br label %endif_1
else_1:
	%23 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 1
	%24 = load %list_Node*, %list_Node** %23
	store %list_Node* %24, %list_Node** %node
	%25 = sub %Int32 0, %pos
	%26 = bitcast %Int32 %25 to %Nat32
	%27 = sub %Nat32 %26, 1
; if_3
	%28 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%29 = load %Nat32, %Nat32* %28
	%30 = icmp ugt %Nat32 %27, %29
	br %Bool %30 , label %then_3, label %endif_3
then_3:
	ret %list_Node* null
	br label %endif_3
endif_3:
	store %Nat32 0, %Nat32* %i.2
; while_2
	br label %again_2
again_2:
	%32 = load %Nat32, %Nat32* %i.2
	%33 = icmp ult %Nat32 %32, %27
	br %Bool %33 , label %body_2, label %break_2
body_2:
	%34 = load %list_Node*, %list_Node** %node
	%35 = getelementptr %list_Node, %list_Node* %34, %Int32 0, %Int32 1
	%36 = load %list_Node*, %list_Node** %35
	store %list_Node* %36, %list_Node** %node
	%37 = load %Nat32, %Nat32* %i.2
	%38 = add %Nat32 %37, 1
	store %Nat32 %38, %Nat32* %i.2
	br label %again_2
break_2:
	br label %endif_1
endif_1:
	%39 = load %list_Node*, %list_Node** %node
	ret %list_Node* %39
}

define %list_Node* @list_node_insert(%list_List* %list, %Int32 %pos, %list_Node* %new_node) {
; if_0
	%1 = icmp eq %list_List* %list, null
	%2 = icmp eq %list_Node* %new_node, null
	%3 = or %Bool %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @.str2 to [0 x i8]*), %Int32 %pos)
	%6 = call %list_Node* @list_node_get(%list_List* %list, %Int32 %pos)
; if_1
	%7 = icmp eq %list_Node* %6, null
	br %Bool %7 , label %then_1, label %endif_1
then_1:
	ret %list_Node* null
	br label %endif_1
endif_1:
	%9 = call %list_Node* @list_node_prev_get(%list_Node* %6)
; if_2
	%10 = icmp eq %list_Node* %9, null
	br %Bool %10 , label %then_2, label %endif_2
then_2:
	ret %list_Node* null
	br label %endif_2
endif_2:
	call void @list_node_insert_right(%list_Node* %9, %list_Node* %new_node)
	%12 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%13 = load %Nat32, %Nat32* %12
	%14 = add %Nat32 %13, 1
	store %Nat32 %14, %Nat32* %12
	ret %list_Node* %new_node
}

define %list_Node* @list_node_append(%list_List* %list, %list_Node* %new_node) {
; if_0
	%1 = icmp eq %list_List* %list, null
	%2 = icmp eq %list_Node* %new_node, null
	%3 = or %Bool %1, %2
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
; if_1
	%5 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 1
	%6 = load %list_Node*, %list_Node** %5
	%7 = icmp eq %list_Node* %6, null
	br %Bool %7 , label %then_1, label %else_1
then_1:
	%8 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 0
	store %list_Node* %new_node, %list_Node** %8
	br label %endif_1
else_1:
	%9 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 1
	%10 = load %list_Node*, %list_Node** %9
	call void @list_node_insert_right(%list_Node* %10, %list_Node* %new_node)
	br label %endif_1
endif_1:
	%11 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 1
	store %list_Node* %new_node, %list_Node** %11
	%12 = getelementptr %list_List, %list_List* %list, %Int32 0, %Int32 2
	%13 = load %Nat32, %Nat32* %12
	%14 = add %Nat32 %13, 1
	store %Nat32 %14, %Nat32* %12
	ret %list_Node* %new_node
}

define %list_Node* @list_insert(%list_List* %list, %Int32 %pos, i8* %data) {
	%1 = call %list_Node* @list_node_create()
; if_0
	%2 = icmp eq %list_Node* %1, null
	br %Bool %2 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%4 = getelementptr %list_Node, %list_Node* %1, %Int32 0, %Int32 2
	store i8* %data, i8** %4
	%5 = call %list_Node* @list_node_insert(%list_List* %list, %Int32 %pos, %list_Node* %1)
	ret %list_Node* %5
}

define %list_Node* @list_append(%list_List* %list, i8* %data) {
; if_0
	%1 = icmp eq %list_List* %list, null
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %list_Node* null
	br label %endif_0
endif_0:
	%3 = call %list_Node* @list_node_create()
; if_1
	%4 = icmp eq %list_Node* %3, null
	br %Bool %4 , label %then_1, label %endif_1
then_1:
	ret %list_Node* null
	br label %endif_1
endif_1:
	%6 = getelementptr %list_Node, %list_Node* %3, %Int32 0, %Int32 2
	store i8* %data, i8** %6
	%7 = call %list_Node* @list_node_append(%list_List* %list, %list_Node* %3)
; if_2
	%8 = icmp eq %list_Node* %7, null
	br %Bool %8 , label %then_2, label %endif_2
then_2:
	%9 = bitcast %list_Node* %3 to i8*
	call void @free(i8* %9)
	ret %list_Node* null
	br label %endif_2
endif_2:
	ret %list_Node* %7
}


