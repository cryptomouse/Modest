
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


; MODULE: table

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
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare [0 x %Char]* @strncpy([0 x %Char]* %dst, [0 x %ConstChar]* %src, %SizeT %n)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
declare %SizeT @strcspn(%Str8* %str1, %Str8* %str2)
; -- end print includes --
; -- print imports 'table' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'table' --
; -- strings --
@.str1 = private constant [2 x i8] [i8 124, i8 0]
@.str2 = private constant [4 x i8] [i8 32, i8 37, i8 115, i8 0]
@.str3 = private constant [2 x i8] [i8 32, i8 0]
@.str4 = private constant [3 x i8] [i8 124, i8 10, i8 0]
@.str5 = private constant [2 x i8] [i8 43, i8 0]
@.str6 = private constant [2 x i8] [i8 45, i8 0]
@.str7 = private constant [3 x i8] [i8 43, i8 10, i8 0]
; -- endstrings --
%table_Row = type [0 x %Str8*];
%table_Table = type {
	%table_Row*,
	[0 x %table_Row]*,
	%Nat32,
	%Nat32,
	%Bool
};

define void @table_print(%table_Table* %table) {
	%i = alloca %Nat32, align 4
	%j = alloca %Nat32, align 4
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	store %Nat32 0, %Nat32* %i
	store %Nat32 0, %Nat32* %j
	%3 = mul %Int32 1, 1
	%4 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%5 = load %Nat32, %Nat32* %4
	%6 = mul %Nat32 %5, 1
	%7 = mul %Nat32 %5, 8
	%8 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%9 = load %Nat32, %Nat32* %8
	%10 = mul %Nat32 %9, %6
	%11 = mul %Nat32 %9, %7
	%12 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 1
	%13 = load [0 x %table_Row]*, [0 x %table_Row]** %12
	%14 = bitcast [0 x %table_Row]* %13 to [0 x [0 x %Str8*]]*
	%15 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%16 = load %Nat32, %Nat32* %15
	%17 = mul %Nat32 %16, 1
	%18 = mul %Nat32 %16, 4
	%19 = alloca %Nat32, %Nat32 %17, align 4
	%20 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%21 = load %Nat32, %Nat32* %20
	%22 = mul %Nat32 %21, 4
	%23 = bitcast %Nat32* %19 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %23, i8 0, %Nat32 %22, i1 0)
; if_0
	%24 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%25 = load %table_Row*, %table_Row** %24
	%26 = icmp ne %table_Row* %25, null
	br %Bool %26 , label %then_0, label %endif_0
then_0:
	store %Nat32 0, %Nat32* %i
; while_1
	br label %again_1
again_1:
	%27 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%28 = load %Nat32, %Nat32* %i
	%29 = load %Nat32, %Nat32* %27
	%30 = icmp ult %Nat32 %28, %29
	br %Bool %30 , label %body_1, label %break_1
body_1:
	%31 = load %Nat32, %Nat32* %i
	%32 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%33 = load %table_Row*, %table_Row** %32
	%34 = bitcast %Nat32 %31 to %Nat32
	%35 = getelementptr %table_Row, %table_Row* %33, %Int32 0, %Nat32 %34
	%36 = load %Str8*, %Str8** %35
	%37 = call %SizeT @strlen(%Str8* %36)
	%38 = trunc %SizeT %37 to %Nat32
; if_1
	%39 = load %Nat32, %Nat32* %i
	%40 = mul %Nat32 %39, 1
	%41 = add %Int32 0, %40
	%42 = getelementptr %Nat32, [0 x %Nat32]* %19, %Int32 %41
	%43 = load %Nat32, %Nat32* %42
	%44 = icmp ugt %Nat32 %38, %43
	br %Bool %44 , label %then_1, label %endif_1
then_1:
	%45 = load %Nat32, %Nat32* %i
	%46 = mul %Nat32 %45, 1
	%47 = add %Int32 0, %46
	%48 = getelementptr %Nat32, [0 x %Nat32]* %19, %Int32 %47
	store %Nat32 %38, %Nat32* %48
	br label %endif_1
endif_1:
	%49 = load %Nat32, %Nat32* %i
	%50 = add %Nat32 %49, 1
	store %Nat32 %50, %Nat32* %i
	br label %again_1
break_1:
	br label %endif_0
endif_0:
	store %Nat32 0, %Nat32* %i
; while_2
	br label %again_2
again_2:
	%51 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%52 = load %Nat32, %Nat32* %i
	%53 = load %Nat32, %Nat32* %51
	%54 = icmp ult %Nat32 %52, %53
	br %Bool %54 , label %body_2, label %break_2
body_2:
	store %Nat32 0, %Nat32* %j
; while_3
	br label %again_3
again_3:
	%55 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%56 = load %Nat32, %Nat32* %j
	%57 = load %Nat32, %Nat32* %55
	%58 = icmp ult %Nat32 %56, %57
	br %Bool %58 , label %body_3, label %break_3
body_3:
	%59 = load %Nat32, %Nat32* %j
	%60 = load %Nat32, %Nat32* %i
	%61 = mul %Nat32 %60, %6
	%62 = add %Int32 0, %61
	%63 = mul %Nat32 %59, 1
	%64 = add %Int32 %62, %63
	%65 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %14, %Int32 %64
	%66 = load %Str8*, %Str8** %65
	%67 = call %SizeT @strlen(%Str8* %66)
	%68 = trunc %SizeT %67 to %Nat32
; if_2
	%69 = load %Nat32, %Nat32* %j
	%70 = mul %Nat32 %69, 1
	%71 = add %Int32 0, %70
	%72 = getelementptr %Nat32, [0 x %Nat32]* %19, %Int32 %71
	%73 = load %Nat32, %Nat32* %72
	%74 = icmp ugt %Nat32 %68, %73
	br %Bool %74 , label %then_2, label %endif_2
then_2:
	%75 = load %Nat32, %Nat32* %j
	%76 = mul %Nat32 %75, 1
	%77 = add %Int32 0, %76
	%78 = getelementptr %Nat32, [0 x %Nat32]* %19, %Int32 %77
	store %Nat32 %68, %Nat32* %78
	br label %endif_2
endif_2:
	%79 = load %Nat32, %Nat32* %j
	%80 = add %Nat32 %79, 1
	store %Nat32 %80, %Nat32* %j
	br label %again_3
break_3:
	%81 = load %Nat32, %Nat32* %i
	%82 = add %Nat32 %81, 1
	store %Nat32 %82, %Nat32* %i
	br label %again_2
break_2:
	store %Nat32 0, %Nat32* %i
; while_4
	br label %again_4
again_4:
	%83 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%84 = load %Nat32, %Nat32* %i
	%85 = load %Nat32, %Nat32* %83
	%86 = icmp ult %Nat32 %84, %85
	br %Bool %86 , label %body_4, label %break_4
body_4:
	%87 = load %Nat32, %Nat32* %i
	%88 = mul %Nat32 %87, 1
	%89 = add %Int32 0, %88
	%90 = getelementptr %Nat32, [0 x %Nat32]* %19, %Int32 %89
	%91 = load %Nat32, %Nat32* %i
	%92 = mul %Nat32 %91, 1
	%93 = add %Int32 0, %92
	%94 = getelementptr %Nat32, [0 x %Nat32]* %19, %Int32 %93
	%95 = load %Nat32, %Nat32* %94
	%96 = add %Nat32 %95, 2
	store %Nat32 %96, %Nat32* %90
	%97 = load %Nat32, %Nat32* %i
	%98 = add %Nat32 %97, 1
	store %Nat32 %98, %Nat32* %i
	br label %again_4
break_4:
	%99 = bitcast [0 x %Nat32]* %19 to [0 x %Nat32]*
	%100 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%101 = load %Nat32, %Nat32* %100
	call void @separator([0 x %Nat32]* %99, %Nat32 %101)
; if_3
	%102 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%103 = load %table_Row*, %table_Row** %102
	%104 = icmp ne %table_Row* %103, null
	br %Bool %104 , label %then_3, label %endif_3
then_3:
	%105 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%106 = load %table_Row*, %table_Row** %105
	%107 = bitcast [0 x %Nat32]* %19 to [0 x %Nat32]*
	%108 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%109 = load %Nat32, %Nat32* %108
	call void @printRow(%table_Row* %106, [0 x %Nat32]* %107, %Nat32 %109)
	%110 = bitcast [0 x %Nat32]* %19 to [0 x %Nat32]*
	%111 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%112 = load %Nat32, %Nat32* %111
	call void @separator([0 x %Nat32]* %110, %Nat32 %112)
	br label %endif_3
endif_3:
	store %Nat32 0, %Nat32* %i
; while_5
	br label %again_5
again_5:
	%113 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%114 = load %Nat32, %Nat32* %i
	%115 = load %Nat32, %Nat32* %113
	%116 = icmp ult %Nat32 %114, %115
	br %Bool %116 , label %body_5, label %break_5
body_5:
	%117 = load %Nat32, %Nat32* %i
	%118 = mul %Nat32 %117, %6
	%119 = add %Int32 0, %118
	%120 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %14, %Int32 %119
	%121 = bitcast [0 x %Str8*]* %120 to [0 x %Str8*]*
	%122 = bitcast [0 x %Nat32]* %19 to [0 x %Nat32]*
	%123 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%124 = load %Nat32, %Nat32* %123
	call void @printRow([0 x %Str8*]* %121, [0 x %Nat32]* %122, %Nat32 %124)
; if_4
	%125 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 4
	%126 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%127 = load %Nat32, %Nat32* %126
	%128 = sub %Nat32 %127, 1
	%129 = load %Nat32, %Nat32* %i
	%130 = icmp ult %Nat32 %129, %128
	%131 = load %Bool, %Bool* %125
	%132 = and %Bool %131, %130
	br %Bool %132 , label %then_4, label %endif_4
then_4:
	%133 = bitcast [0 x %Nat32]* %19 to [0 x %Nat32]*
	%134 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%135 = load %Nat32, %Nat32* %134
	call void @separator([0 x %Nat32]* %133, %Nat32 %135)
	br label %endif_4
endif_4:
	%136 = load %Nat32, %Nat32* %i
	%137 = add %Nat32 %136, 1
	store %Nat32 %137, %Nat32* %i
	br label %again_5
break_5:
	%138 = bitcast [0 x %Nat32]* %19 to [0 x %Nat32]*
	%139 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%140 = load %Nat32, %Nat32* %139
	call void @separator([0 x %Nat32]* %138, %Nat32 %140)
	%141 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %141)
	ret void
}

define internal void @printRow([0 x %Str8*]* %raw_row, [0 x %Nat32]* %sz, %Nat32 %nCols) {
	%j = alloca %Nat32, align 4
	%len = alloca %Nat32, align 4
	%k = alloca %Nat32, align 4
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = mul %Nat32 %nCols, 1
	%4 = mul %Nat32 %nCols, 8
	%5 = bitcast [0 x %Str8*]* %raw_row to [0 x %Str8*]*
	store %Nat32 0, %Nat32* %j
; while_1
	br label %again_1
again_1:
	%6 = load %Nat32, %Nat32* %j
	%7 = icmp ult %Nat32 %6, %nCols
	br %Bool %7 , label %body_1, label %break_1
body_1:
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str1 to [0 x i8]*))
	%9 = load %Nat32, %Nat32* %j
	%10 = mul %Nat32 %9, 1
	%11 = add %Int32 0, %10
	%12 = getelementptr %Str8*, [0 x %Str8*]* %5, %Int32 %11
	%13 = load %Str8*, %Str8** %12
	%14 = call %SizeT @strlen(%Str8* %13)
	%15 = trunc %SizeT %14 to %Nat32
	store %Nat32 %15, %Nat32* %len
; if_0
	%16 = getelementptr %Str8, %Str8* %13, %Int32 0, %Int32 0
	%17 = load %Char8, %Char8* %16
	%18 = icmp ne %Char8 %17, 0
	br %Bool %18 , label %then_0, label %endif_0
then_0:
	%19 = load %Nat32, %Nat32* %len
	%20 = add %Nat32 %19, 1
	store %Nat32 %20, %Nat32* %len
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @.str2 to [0 x i8]*), %Str8* %13)
	br label %endif_0
endif_0:
	store %Nat32 0, %Nat32* %k
; while_2
	br label %again_2
again_2:
	%22 = load %Nat32, %Nat32* %j
	%23 = bitcast %Nat32 %22 to %Nat32
	%24 = getelementptr [0 x %Nat32], [0 x %Nat32]* %sz, %Int32 0, %Nat32 %23
	%25 = load %Nat32, %Nat32* %24
	%26 = load %Nat32, %Nat32* %len
	%27 = sub %Nat32 %25, %26
	%28 = load %Nat32, %Nat32* %k
	%29 = icmp ult %Nat32 %28, %27
	br %Bool %29 , label %body_2, label %break_2
body_2:
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str3 to [0 x i8]*))
	%31 = load %Nat32, %Nat32* %k
	%32 = add %Nat32 %31, 1
	store %Nat32 %32, %Nat32* %k
	br label %again_2
break_2:
	%33 = load %Nat32, %Nat32* %j
	%34 = add %Nat32 %33, 1
	store %Nat32 %34, %Nat32* %j
	br label %again_1
break_1:
	%35 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @.str4 to [0 x i8]*))
	%36 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %36)
	ret void
}

define internal void @separator([0 x %Nat32]* %sz, %Nat32 %n) {
	%i = alloca %Nat32, align 4
	%j = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %i
; while_1
	br label %again_1
again_1:
	%1 = load %Nat32, %Nat32* %i
	%2 = icmp ult %Nat32 %1, %n
	br %Bool %2 , label %body_1, label %break_1
body_1:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str5 to [0 x i8]*))
	store %Nat32 0, %Nat32* %j
; while_2
	br label %again_2
again_2:
	%4 = load %Nat32, %Nat32* %i
	%5 = bitcast %Nat32 %4 to %Nat32
	%6 = getelementptr [0 x %Nat32], [0 x %Nat32]* %sz, %Int32 0, %Nat32 %5
	%7 = load %Nat32, %Nat32* %j
	%8 = load %Nat32, %Nat32* %6
	%9 = icmp ult %Nat32 %7, %8
	br %Bool %9 , label %body_2, label %break_2
body_2:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str6 to [0 x i8]*))
	%11 = load %Nat32, %Nat32* %j
	%12 = add %Nat32 %11, 1
	store %Nat32 %12, %Nat32* %j
	br label %again_2
break_2:
	%13 = load %Nat32, %Nat32* %i
	%14 = add %Nat32 %13, 1
	store %Nat32 %14, %Nat32* %i
	br label %again_1
break_1:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @.str7 to [0 x i8]*))
	ret void
}


