
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
	%3 = mul %Size 1, 1
	%4 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%5 = load %Nat32, %Nat32* %4
	%6 = zext %Nat32 %5 to %Size
	%7 = mul %Size %6, 1
	%8 = mul %Size %6, 8
	%9 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%10 = load %Nat32, %Nat32* %9
	%11 = zext %Nat32 %10 to %Size
	%12 = mul %Size %11, %7
	%13 = mul %Size %11, %8
	%14 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 1
	%15 = load [0 x %table_Row]*, [0 x %table_Row]** %14
	%16 = bitcast [0 x %table_Row]* %15 to [0 x [0 x %Str8*]]*
	%17 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%18 = load %Nat32, %Nat32* %17
	%19 = zext %Nat32 %18 to %Size
	%20 = mul %Size %19, 1
	%21 = mul %Size %19, 4
	%22 = alloca %Nat32, %Size %20, align 4
	%23 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%24 = load %Nat32, %Nat32* %23
	%25 = mul %Nat32 %24, 4
	%26 = bitcast %Nat32* %22 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %26, i8 0, %Nat32 %25, i1 0)
; if_0
	%27 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%28 = load %table_Row*, %table_Row** %27
	%29 = icmp ne %table_Row* %28, null
	br %Bool %29 , label %then_0, label %endif_0
then_0:
	store %Nat32 0, %Nat32* %i
; while_1
	br label %again_1
again_1:
	%30 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%31 = load %Nat32, %Nat32* %i
	%32 = load %Nat32, %Nat32* %30
	%33 = icmp ult %Nat32 %31, %32
	br %Bool %33 , label %body_1, label %break_1
body_1:
	%34 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%35 = load %table_Row*, %table_Row** %34
	%36 = load %Nat32, %Nat32* %i
	%37 = bitcast %Nat32 %36 to %Nat32
	%38 = getelementptr %table_Row, %table_Row* %35, %Int32 0, %Nat32 %37
	%39 = load %Str8*, %Str8** %38
	%40 = call %SizeT @strlen(%Str8* %39)
	%41 = trunc %SizeT %40 to %Nat32
; if_1
	%42 = load %Nat32, %Nat32* %i
	%43 = zext %Nat32 %42 to %Size
	%44 = mul %Size %43, 1
	%45 = add %Size 0, %44
	%46 = trunc %Size %45 to %Nat32
	%47 = getelementptr %Nat32, [0 x %Nat32]* %22, %Nat32 %46
	%48 = load %Nat32, %Nat32* %47
	%49 = icmp ugt %Nat32 %41, %48
	br %Bool %49 , label %then_1, label %endif_1
then_1:
	%50 = load %Nat32, %Nat32* %i
	%51 = zext %Nat32 %50 to %Size
	%52 = mul %Size %51, 1
	%53 = add %Size 0, %52
	%54 = trunc %Size %53 to %Nat32
	%55 = getelementptr %Nat32, [0 x %Nat32]* %22, %Nat32 %54
	store %Nat32 %41, %Nat32* %55
	br label %endif_1
endif_1:
	%56 = load %Nat32, %Nat32* %i
	%57 = add %Nat32 %56, 1
	store %Nat32 %57, %Nat32* %i
	br label %again_1
break_1:
	br label %endif_0
endif_0:
	store %Nat32 0, %Nat32* %i
; while_2
	br label %again_2
again_2:
	%58 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%59 = load %Nat32, %Nat32* %i
	%60 = load %Nat32, %Nat32* %58
	%61 = icmp ult %Nat32 %59, %60
	br %Bool %61 , label %body_2, label %break_2
body_2:
	store %Nat32 0, %Nat32* %j
; while_3
	br label %again_3
again_3:
	%62 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%63 = load %Nat32, %Nat32* %j
	%64 = load %Nat32, %Nat32* %62
	%65 = icmp ult %Nat32 %63, %64
	br %Bool %65 , label %body_3, label %break_3
body_3:
	%66 = load %Nat32, %Nat32* %i
	%67 = load %Nat32, %Nat32* %j
	%68 = zext %Nat32 %66 to %Size
	%69 = mul %Size %68, %7
	%70 = add %Size 0, %69
	%71 = zext %Nat32 %67 to %Size
	%72 = mul %Size %71, 1
	%73 = add %Size %70, %72
	%74 = trunc %Size %73 to %Nat32
	%75 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %16, %Nat32 %74
	%76 = load %Str8*, %Str8** %75
	%77 = call %SizeT @strlen(%Str8* %76)
	%78 = trunc %SizeT %77 to %Nat32
; if_2
	%79 = load %Nat32, %Nat32* %j
	%80 = zext %Nat32 %79 to %Size
	%81 = mul %Size %80, 1
	%82 = add %Size 0, %81
	%83 = trunc %Size %82 to %Nat32
	%84 = getelementptr %Nat32, [0 x %Nat32]* %22, %Nat32 %83
	%85 = load %Nat32, %Nat32* %84
	%86 = icmp ugt %Nat32 %78, %85
	br %Bool %86 , label %then_2, label %endif_2
then_2:
	%87 = load %Nat32, %Nat32* %j
	%88 = zext %Nat32 %87 to %Size
	%89 = mul %Size %88, 1
	%90 = add %Size 0, %89
	%91 = trunc %Size %90 to %Nat32
	%92 = getelementptr %Nat32, [0 x %Nat32]* %22, %Nat32 %91
	store %Nat32 %78, %Nat32* %92
	br label %endif_2
endif_2:
	%93 = load %Nat32, %Nat32* %j
	%94 = add %Nat32 %93, 1
	store %Nat32 %94, %Nat32* %j
	br label %again_3
break_3:
	%95 = load %Nat32, %Nat32* %i
	%96 = add %Nat32 %95, 1
	store %Nat32 %96, %Nat32* %i
	br label %again_2
break_2:
	store %Nat32 0, %Nat32* %i
; while_4
	br label %again_4
again_4:
	%97 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%98 = load %Nat32, %Nat32* %i
	%99 = load %Nat32, %Nat32* %97
	%100 = icmp ult %Nat32 %98, %99
	br %Bool %100 , label %body_4, label %break_4
body_4:
	%101 = load %Nat32, %Nat32* %i
	%102 = zext %Nat32 %101 to %Size
	%103 = mul %Size %102, 1
	%104 = add %Size 0, %103
	%105 = trunc %Size %104 to %Nat32
	%106 = getelementptr %Nat32, [0 x %Nat32]* %22, %Nat32 %105
	%107 = load %Nat32, %Nat32* %i
	%108 = zext %Nat32 %107 to %Size
	%109 = mul %Size %108, 1
	%110 = add %Size 0, %109
	%111 = trunc %Size %110 to %Nat32
	%112 = getelementptr %Nat32, [0 x %Nat32]* %22, %Nat32 %111
	%113 = load %Nat32, %Nat32* %112
	%114 = add %Nat32 %113, 2
	store %Nat32 %114, %Nat32* %106
	%115 = load %Nat32, %Nat32* %i
	%116 = add %Nat32 %115, 1
	store %Nat32 %116, %Nat32* %i
	br label %again_4
break_4:
	%117 = bitcast [0 x %Nat32]* %22 to [0 x %Nat32]*
	%118 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%119 = load %Nat32, %Nat32* %118
	call void @separator([0 x %Nat32]* %117, %Nat32 %119)
; if_3
	%120 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%121 = load %table_Row*, %table_Row** %120
	%122 = icmp ne %table_Row* %121, null
	br %Bool %122 , label %then_3, label %endif_3
then_3:
	%123 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%124 = load %table_Row*, %table_Row** %123
	%125 = bitcast [0 x %Nat32]* %22 to [0 x %Nat32]*
	%126 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%127 = load %Nat32, %Nat32* %126
	call void @printRow(%table_Row* %124, [0 x %Nat32]* %125, %Nat32 %127)
	%128 = bitcast [0 x %Nat32]* %22 to [0 x %Nat32]*
	%129 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%130 = load %Nat32, %Nat32* %129
	call void @separator([0 x %Nat32]* %128, %Nat32 %130)
	br label %endif_3
endif_3:
	store %Nat32 0, %Nat32* %i
; while_5
	br label %again_5
again_5:
	%131 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%132 = load %Nat32, %Nat32* %i
	%133 = load %Nat32, %Nat32* %131
	%134 = icmp ult %Nat32 %132, %133
	br %Bool %134 , label %body_5, label %break_5
body_5:
	%135 = load %Nat32, %Nat32* %i
	%136 = zext %Nat32 %135 to %Size
	%137 = mul %Size %136, %7
	%138 = add %Size 0, %137
	%139 = trunc %Size %138 to %Nat32
	%140 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %16, %Nat32 %139
	%141 = bitcast [0 x %Str8*]* %140 to [0 x %Str8*]*
	%142 = bitcast [0 x %Nat32]* %22 to [0 x %Nat32]*
	%143 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%144 = load %Nat32, %Nat32* %143
	call void @printRow([0 x %Str8*]* %141, [0 x %Nat32]* %142, %Nat32 %144)
; if_4
	%145 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 4
	%146 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%147 = load %Nat32, %Nat32* %146
	%148 = sub %Nat32 %147, 1
	%149 = load %Nat32, %Nat32* %i
	%150 = icmp ult %Nat32 %149, %148
	%151 = load %Bool, %Bool* %145
	%152 = and %Bool %151, %150
	br %Bool %152 , label %then_4, label %endif_4
then_4:
	%153 = bitcast [0 x %Nat32]* %22 to [0 x %Nat32]*
	%154 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%155 = load %Nat32, %Nat32* %154
	call void @separator([0 x %Nat32]* %153, %Nat32 %155)
	br label %endif_4
endif_4:
	%156 = load %Nat32, %Nat32* %i
	%157 = add %Nat32 %156, 1
	store %Nat32 %157, %Nat32* %i
	br label %again_5
break_5:
	%158 = bitcast [0 x %Nat32]* %22 to [0 x %Nat32]*
	%159 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%160 = load %Nat32, %Nat32* %159
	call void @separator([0 x %Nat32]* %158, %Nat32 %160)
	%161 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %161)
	ret void
}

define internal void @printRow([0 x %Str8*]* %raw_row, [0 x %Nat32]* %sz, %Nat32 %nCols) {
	%j = alloca %Nat32, align 4
	%len = alloca %Nat32, align 4
	%k = alloca %Nat32, align 4
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = zext %Nat32 %nCols to %Size
	%4 = mul %Size %3, 1
	%5 = mul %Size %3, 8
	%6 = bitcast [0 x %Str8*]* %raw_row to [0 x %Str8*]*
	store %Nat32 0, %Nat32* %j
; while_1
	br label %again_1
again_1:
	%7 = load %Nat32, %Nat32* %j
	%8 = icmp ult %Nat32 %7, %nCols
	br %Bool %8 , label %body_1, label %break_1
body_1:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str1 to [0 x i8]*))
	%10 = load %Nat32, %Nat32* %j
	%11 = zext %Nat32 %10 to %Size
	%12 = mul %Size %11, 1
	%13 = add %Size 0, %12
	%14 = trunc %Size %13 to %Nat32
	%15 = getelementptr %Str8*, [0 x %Str8*]* %6, %Nat32 %14
	%16 = load %Str8*, %Str8** %15
	%17 = call %SizeT @strlen(%Str8* %16)
	%18 = trunc %SizeT %17 to %Nat32
	store %Nat32 %18, %Nat32* %len
; if_0
	%19 = getelementptr %Str8, %Str8* %16, %Int32 0, %Int32 0
	%20 = load %Char8, %Char8* %19
	%21 = icmp ne %Char8 %20, 0
	br %Bool %21 , label %then_0, label %endif_0
then_0:
	%22 = load %Nat32, %Nat32* %len
	%23 = add %Nat32 %22, 1
	store %Nat32 %23, %Nat32* %len
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @.str2 to [0 x i8]*), %Str8* %16)
	br label %endif_0
endif_0:
	store %Nat32 0, %Nat32* %k
; while_2
	br label %again_2
again_2:
	%25 = load %Nat32, %Nat32* %j
	%26 = bitcast %Nat32 %25 to %Nat32
	%27 = getelementptr [0 x %Nat32], [0 x %Nat32]* %sz, %Int32 0, %Nat32 %26
	%28 = load %Nat32, %Nat32* %27
	%29 = load %Nat32, %Nat32* %len
	%30 = sub %Nat32 %28, %29
	%31 = load %Nat32, %Nat32* %k
	%32 = icmp ult %Nat32 %31, %30
	br %Bool %32 , label %body_2, label %break_2
body_2:
	%33 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str3 to [0 x i8]*))
	%34 = load %Nat32, %Nat32* %k
	%35 = add %Nat32 %34, 1
	store %Nat32 %35, %Nat32* %k
	br label %again_2
break_2:
	%36 = load %Nat32, %Nat32* %j
	%37 = add %Nat32 %36, 1
	store %Nat32 %37, %Nat32* %j
	br label %again_1
break_1:
	%38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @.str4 to [0 x i8]*))
	%39 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %39)
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


