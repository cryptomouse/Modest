
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

; from import "list"
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

declare %list_List* @list_create()
declare %Nat32 @list_size_get(%list_List* %list)
declare %list_Node* @list_first_node_get(%list_List* %list)
declare %list_Node* @list_last_node_get(%list_List* %list)
declare %list_Node* @list_node_first(%list_List* %list, %list_Node* %new_node)
declare %list_Node* @list_node_create()
declare %list_Node* @list_node_next_get(%list_Node* %node)
declare %list_Node* @list_node_prev_get(%list_Node* %node)
declare i8* @list_node_data_get(%list_Node* %node)
declare void @list_node_insert_right(%list_Node* %left, %list_Node* %new_right)
declare %list_Node* @list_node_get(%list_List* %list, %Int32 %pos)
declare %list_Node* @list_node_insert(%list_List* %list, %Int32 %pos, %list_Node* %new_node)
declare %list_Node* @list_node_append(%list_List* %list, %list_Node* %new_node)
declare %list_Node* @list_insert(%list_List* %list, %Int32 %pos, i8* %data)
declare %list_Node* @list_append(%list_List* %list, i8* %data)

; end from import "list"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [21 x i8] [i8 108, i8 105, i8 115, i8 116, i8 95, i8 112, i8 114, i8 105, i8 110, i8 116, i8 95, i8 102, i8 111, i8 114, i8 119, i8 97, i8 114, i8 100, i8 58, i8 10, i8 0]
@.str2 = private constant [8 x i8] [i8 118, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@.str3 = private constant [22 x i8] [i8 108, i8 105, i8 115, i8 116, i8 95, i8 112, i8 114, i8 105, i8 110, i8 116, i8 95, i8 98, i8 97, i8 99, i8 107, i8 119, i8 97, i8 114, i8 100, i8 58, i8 10, i8 0]
@.str4 = private constant [8 x i8] [i8 118, i8 32, i8 61, i8 32, i8 37, i8 117, i8 10, i8 0]
@.str5 = private constant [21 x i8] [i8 108, i8 105, i8 110, i8 107, i8 101, i8 100, i8 32, i8 108, i8 105, i8 115, i8 116, i8 32, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@.str6 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 32, i8 108, i8 105, i8 115, i8 116, i8 0]
@.str7 = private constant [22 x i8] [i8 108, i8 105, i8 110, i8 107, i8 101, i8 100, i8 32, i8 108, i8 105, i8 115, i8 116, i8 32, i8 115, i8 105, i8 122, i8 101, i8 58, i8 32, i8 37, i8 117, i8 10, i8 0]
@.str8 = private constant [30 x i8] [i8 10, i8 108, i8 105, i8 115, i8 116, i8 46, i8 110, i8 111, i8 100, i8 101, i8 95, i8 103, i8 101, i8 116, i8 40, i8 108, i8 105, i8 115, i8 116, i8 44, i8 32, i8 110, i8 41, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@.str9 = private constant [19 x i8] [i8 110, i8 111, i8 100, i8 101, i8 32, i8 37, i8 105, i8 32, i8 110, i8 111, i8 116, i8 32, i8 101, i8 120, i8 105, i8 115, i8 116, i8 10, i8 0]
@.str10 = private constant [15 x i8] [i8 108, i8 105, i8 115, i8 116, i8 40, i8 37, i8 105, i8 41, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@.str11 = private constant [43 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@.str12 = private constant [19 x i8] [i8 110, i8 111, i8 100, i8 101, i8 32, i8 37, i8 105, i8 32, i8 110, i8 111, i8 116, i8 32, i8 101, i8 120, i8 105, i8 115, i8 116, i8 10, i8 0]
@.str13 = private constant [15 x i8] [i8 108, i8 105, i8 115, i8 116, i8 40, i8 37, i8 105, i8 41, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@.str14 = private constant [43 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
; -- endstrings --
define internal void @nat32_list_insert(%list_List* %lst, %Nat32 %x) {
	%1 = call i8* @malloc(%SizeT 4)
	%2 = bitcast i8* %1 to %Nat32*
	store %Nat32 %x, %Nat32* %2
	%3 = bitcast %Nat32* %2 to i8*
	%4 = call %list_Node* @list_append(%list_List* %lst, i8* %3)
	ret void
}

define internal void @list_print_forward(%list_List* %lst) {
	%pn = alloca %list_Node*, align 8
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str1 to [0 x i8]*))
	%2 = call %list_Node* @list_first_node_get(%list_List* %lst)
	store %list_Node* %2, %list_Node** %pn
; while_1
	br label %again_1
again_1:
	%3 = load %list_Node*, %list_Node** %pn
	%4 = icmp ne %list_Node* %3, null
	br %Bool %4 , label %body_1, label %break_1
body_1:
	%5 = load %list_Node*, %list_Node** %pn
	%6 = call i8* @list_node_data_get(%list_Node* %5)
	%7 = bitcast i8* %6 to %Nat32*
	%8 = load %Nat32, %Nat32* %7
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str2 to [0 x i8]*), %Nat32 %8)
	%10 = load %list_Node*, %list_Node** %pn
	%11 = call %list_Node* @list_node_next_get(%list_Node* %10)
	store %list_Node* %11, %list_Node** %pn
	br label %again_1
break_1:
	ret void
}

define internal void @list_print_backward(%list_List* %lst) {
	%pn = alloca %list_Node*, align 8
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str3 to [0 x i8]*))
	%2 = call %list_Node* @list_last_node_get(%list_List* %lst)
	store %list_Node* %2, %list_Node** %pn
; while_1
	br label %again_1
again_1:
	%3 = load %list_Node*, %list_Node** %pn
	%4 = icmp ne %list_Node* %3, null
	br %Bool %4 , label %body_1, label %break_1
body_1:
	%5 = load %list_Node*, %list_Node** %pn
	%6 = call i8* @list_node_data_get(%list_Node* %5)
	%7 = bitcast i8* %6 to %Nat32*
	%8 = load %Nat32, %Nat32* %7
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @.str4 to [0 x i8]*), %Nat32 %8)
	%10 = load %list_Node*, %list_Node** %pn
	%11 = call %list_Node* @list_node_prev_get(%list_Node* %10)
	store %list_Node* %11, %list_Node** %pn
	br label %again_1
break_1:
	ret void
}

define %Int @main() {
	%i = alloca %Int32, align 4
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @.str5 to [0 x i8]*))
	%2 = call %list_List* @list_create()
; if_0
	%3 = icmp eq %list_List* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @.str6 to [0 x i8]*))
	ret %Int 1
	br label %endif_0
endif_0:
	call void @nat32_list_insert(%list_List* %2, %Nat32 0)
	call void @nat32_list_insert(%list_List* %2, %Nat32 10)
	call void @nat32_list_insert(%list_List* %2, %Nat32 20)
	call void @nat32_list_insert(%list_List* %2, %Nat32 30)
	call void @nat32_list_insert(%list_List* %2, %Nat32 40)
	call void @nat32_list_insert(%list_List* %2, %Nat32 50)
	call void @nat32_list_insert(%list_List* %2, %Nat32 60)
	call void @nat32_list_insert(%list_List* %2, %Nat32 70)
	call void @nat32_list_insert(%list_List* %2, %Nat32 80)
	call void @nat32_list_insert(%list_List* %2, %Nat32 90)
	call void @nat32_list_insert(%list_List* %2, %Nat32 100)
	%6 = call %Nat32 @list_size_get(%list_List* %2)
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @.str7 to [0 x i8]*), %Nat32 %6)
	call void @list_print_forward(%list_List* %2)
	call void @list_print_backward(%list_List* %2)
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @.str8 to [0 x i8]*))
	store %Int32 0, %Int32* %i
; while_1
	br label %again_1
again_1:
	%9 = load %Int32, %Int32* %i
	%10 = icmp sge %Int32 %9, -12
	br %Bool %10 , label %body_1, label %break_1
body_1:
	%11 = load %Int32, %Int32* %i
	%12 = call %list_Node* @list_node_get(%list_List* %2, %Int32 %11)
; if_1
	%13 = icmp eq %list_Node* %12, null
	br %Bool %13 , label %then_1, label %endif_1
then_1:
	%14 = load %Int32, %Int32* %i
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @.str9 to [0 x i8]*), %Int32 %14)
	%16 = load %Int32, %Int32* %i
	%17 = sub %Int32 %16, 1
	store %Int32 %17, %Int32* %i
	br label %again_1
	br label %endif_1
endif_1:
	%19 = call i8* @list_node_data_get(%list_Node* %12)
	%20 = bitcast i8* %19 to %Nat32*
	%21 = load %Int32, %Int32* %i
	%22 = load %Nat32, %Nat32* %20
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str10 to [0 x i8]*), %Int32 %21, %Nat32 %22)
	%24 = load %Int32, %Int32* %i
	%25 = sub %Int32 %24, 1
	store %Int32 %25, %Int32* %i
	br label %again_1
break_1:
	%26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([43 x i8]* @.str11 to [0 x i8]*))
	store %Int32 0, %Int32* %i
; while_2
	br label %again_2
again_2:
	%27 = load %Int32, %Int32* %i
	%28 = icmp sle %Int32 %27, 12
	br %Bool %28 , label %body_2, label %break_2
body_2:
	%29 = load %Int32, %Int32* %i
	%30 = call %list_Node* @list_node_get(%list_List* %2, %Int32 %29)
; if_2
	%31 = icmp eq %list_Node* %30, null
	br %Bool %31 , label %then_2, label %endif_2
then_2:
	%32 = load %Int32, %Int32* %i
	%33 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @.str12 to [0 x i8]*), %Int32 %32)
	%34 = load %Int32, %Int32* %i
	%35 = add %Int32 %34, 1
	store %Int32 %35, %Int32* %i
	br label %again_2
	br label %endif_2
endif_2:
	%37 = call i8* @list_node_data_get(%list_Node* %30)
	%38 = bitcast i8* %37 to %Nat32*
	%39 = load %Int32, %Int32* %i
	%40 = load %Nat32, %Nat32* %38
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @.str13 to [0 x i8]*), %Int32 %39, %Nat32 %40)
	%42 = load %Int32, %Int32* %i
	%43 = add %Int32 %42, 1
	store %Int32 %43, %Int32* %i
	br label %again_2
break_2:
	%44 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([43 x i8]* @.str14 to [0 x i8]*))
	%45 = call i8* @malloc(%SizeT 4)
	%46 = bitcast i8* %45 to %Nat32*
	store %Nat32 1234, %Nat32* %46
	%47 = bitcast %Nat32* %46 to i8*
	%48 = call %list_Node* @list_insert(%list_List* %2, %Int32 4, i8* %47)
	call void @list_print_forward(%list_List* %2)
	ret %Int 0
}


