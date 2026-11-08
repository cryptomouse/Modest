
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
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Float16 = type half
%Float32 = type float
%Float64 = type double
%Fixed32 = type i32
%Fixed64 = type i64
%Size = type i64
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
	%3 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%4 = load %Nat32, %Nat32* %3
	%5 = zext %Nat32 %4 to %Size
	%6 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%7 = load %Nat32, %Nat32* %6
	%8 = zext %Nat32 %7 to %Size
	%9 = mul %Size 1, 1
	%10 = mul %Size %8, 1
	%11 = mul %Size %8, 8
	%12 = mul %Size %5, %10
	%13 = mul %Size %5, %11
	%14 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 1
	%15 = load [0 x %table_Row]*, [0 x %table_Row]** %14
	%16 = bitcast [0 x %table_Row]* %15 to [0 x [0 x %Str8*]]*
	%17 = mul %Size 1, 1
	%18 = mul %Size %8, 1
	%19 = mul %Size %8, 8
	%20 = mul %Size %5, %18
	%21 = mul %Size %5, %19
	%22 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%23 = load %Nat32, %Nat32* %22
	%24 = zext %Nat32 %23 to %Size
	%25 = mul %Size %24, 1
	%26 = mul %Size %24, 4
	%27 = alloca %Nat32, %Size %25, align 4
	%28 = mul %Size %24, 1
	%29 = mul %Size %24, 4
	%30 = trunc %Size %29 to %Nat32
	%31 = bitcast %Nat32* %27 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %31, i8 0, %Nat32 %30, i1 0)
; if_0
	%32 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%33 = load %table_Row*, %table_Row** %32
	%34 = icmp ne %table_Row* %33, null
	br %Bool %34 , label %then_0, label %endif_0
then_0:
	store %Nat32 0, %Nat32* %i
; while_1
	br label %again_1
again_1:
	%35 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%36 = load %Nat32, %Nat32* %i
	%37 = load %Nat32, %Nat32* %35
	%38 = icmp ult %Nat32 %36, %37
	br %Bool %38 , label %body_1, label %break_1
body_1:
	%39 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%40 = load %table_Row*, %table_Row** %39
	%41 = load %Nat32, %Nat32* %i
	%42 = bitcast %Nat32 %41 to %Nat32
	%43 = getelementptr %table_Row, %table_Row* %40, %Int32 0, %Nat32 %42
	%44 = load %Str8*, %Str8** %43
	%45 = call %SizeT @strlen(%Str8* %44)
	%46 = trunc %SizeT %45 to %Nat32
; if_1
	%47 = load %Nat32, %Nat32* %i
	%48 = zext %Nat32 %47 to %Size
	%49 = mul %Size %48, 1
	%50 = add %Size 0, %49
	%51 = trunc %Size %50 to %Nat32
	%52 = getelementptr %Nat32, [0 x %Nat32]* %27, %Nat32 %51
	%53 = load %Nat32, %Nat32* %52
	%54 = icmp ugt %Nat32 %46, %53
	br %Bool %54 , label %then_1, label %endif_1
then_1:
	%55 = load %Nat32, %Nat32* %i
	%56 = zext %Nat32 %55 to %Size
	%57 = mul %Size %56, 1
	%58 = add %Size 0, %57
	%59 = trunc %Size %58 to %Nat32
	%60 = getelementptr %Nat32, [0 x %Nat32]* %27, %Nat32 %59
	store %Nat32 %46, %Nat32* %60
	br label %endif_1
endif_1:
	%61 = load %Nat32, %Nat32* %i
	%62 = add %Nat32 %61, 1
	store %Nat32 %62, %Nat32* %i
	br label %again_1
break_1:
	br label %endif_0
endif_0:
	store %Nat32 0, %Nat32* %i
; while_2
	br label %again_2
again_2:
	%63 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%64 = load %Nat32, %Nat32* %i
	%65 = load %Nat32, %Nat32* %63
	%66 = icmp ult %Nat32 %64, %65
	br %Bool %66 , label %body_2, label %break_2
body_2:
	store %Nat32 0, %Nat32* %j
; while_3
	br label %again_3
again_3:
	%67 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%68 = load %Nat32, %Nat32* %j
	%69 = load %Nat32, %Nat32* %67
	%70 = icmp ult %Nat32 %68, %69
	br %Bool %70 , label %body_3, label %break_3
body_3:
	%71 = load %Nat32, %Nat32* %i
	%72 = load %Nat32, %Nat32* %j
	%73 = zext %Nat32 %71 to %Size
	%74 = mul %Size 1, 1
	%75 = mul %Size %8, 1
	%76 = mul %Size %8, 8
	%77 = mul %Size %73, %75
	%78 = add %Size 0, %77
	%79 = zext %Nat32 %72 to %Size
	%80 = mul %Size 1, 1
	%81 = mul %Size %79, 1
	%82 = add %Size %78, %81
	%83 = trunc %Size %82 to %Nat32
	%84 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %16, %Nat32 %83
	%85 = load %Str8*, %Str8** %84
	%86 = call %SizeT @strlen(%Str8* %85)
	%87 = trunc %SizeT %86 to %Nat32
; if_2
	%88 = load %Nat32, %Nat32* %j
	%89 = zext %Nat32 %88 to %Size
	%90 = mul %Size %89, 1
	%91 = add %Size 0, %90
	%92 = trunc %Size %91 to %Nat32
	%93 = getelementptr %Nat32, [0 x %Nat32]* %27, %Nat32 %92
	%94 = load %Nat32, %Nat32* %93
	%95 = icmp ugt %Nat32 %87, %94
	br %Bool %95 , label %then_2, label %endif_2
then_2:
	%96 = load %Nat32, %Nat32* %j
	%97 = zext %Nat32 %96 to %Size
	%98 = mul %Size %97, 1
	%99 = add %Size 0, %98
	%100 = trunc %Size %99 to %Nat32
	%101 = getelementptr %Nat32, [0 x %Nat32]* %27, %Nat32 %100
	store %Nat32 %87, %Nat32* %101
	br label %endif_2
endif_2:
	%102 = load %Nat32, %Nat32* %j
	%103 = add %Nat32 %102, 1
	store %Nat32 %103, %Nat32* %j
	br label %again_3
break_3:
	%104 = load %Nat32, %Nat32* %i
	%105 = add %Nat32 %104, 1
	store %Nat32 %105, %Nat32* %i
	br label %again_2
break_2:
	store %Nat32 0, %Nat32* %i
; while_4
	br label %again_4
again_4:
	%106 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%107 = load %Nat32, %Nat32* %i
	%108 = load %Nat32, %Nat32* %106
	%109 = icmp ult %Nat32 %107, %108
	br %Bool %109 , label %body_4, label %break_4
body_4:
	%110 = load %Nat32, %Nat32* %i
	%111 = zext %Nat32 %110 to %Size
	%112 = mul %Size %111, 1
	%113 = add %Size 0, %112
	%114 = trunc %Size %113 to %Nat32
	%115 = getelementptr %Nat32, [0 x %Nat32]* %27, %Nat32 %114
	%116 = load %Nat32, %Nat32* %i
	%117 = zext %Nat32 %116 to %Size
	%118 = mul %Size %117, 1
	%119 = add %Size 0, %118
	%120 = trunc %Size %119 to %Nat32
	%121 = getelementptr %Nat32, [0 x %Nat32]* %27, %Nat32 %120
	%122 = load %Nat32, %Nat32* %121
	%123 = add %Nat32 %122, 2
	store %Nat32 %123, %Nat32* %115
	%124 = load %Nat32, %Nat32* %i
	%125 = add %Nat32 %124, 1
	store %Nat32 %125, %Nat32* %i
	br label %again_4
break_4:
	%126 = bitcast [0 x %Nat32]* %27 to [0 x %Nat32]*
	%127 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%128 = load %Nat32, %Nat32* %127
	call void @separator([0 x %Nat32]* %126, %Nat32 %128)
; if_3
	%129 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%130 = load %table_Row*, %table_Row** %129
	%131 = icmp ne %table_Row* %130, null
	br %Bool %131 , label %then_3, label %endif_3
then_3:
	%132 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 0
	%133 = load %table_Row*, %table_Row** %132
	%134 = bitcast [0 x %Nat32]* %27 to [0 x %Nat32]*
	%135 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%136 = load %Nat32, %Nat32* %135
	call void @printRow(%table_Row* %133, [0 x %Nat32]* %134, %Nat32 %136)
	%137 = bitcast [0 x %Nat32]* %27 to [0 x %Nat32]*
	%138 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%139 = load %Nat32, %Nat32* %138
	call void @separator([0 x %Nat32]* %137, %Nat32 %139)
	br label %endif_3
endif_3:
	store %Nat32 0, %Nat32* %i
; while_5
	br label %again_5
again_5:
	%140 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%141 = load %Nat32, %Nat32* %i
	%142 = load %Nat32, %Nat32* %140
	%143 = icmp ult %Nat32 %141, %142
	br %Bool %143 , label %body_5, label %break_5
body_5:
	%144 = load %Nat32, %Nat32* %i
	%145 = zext %Nat32 %144 to %Size
	%146 = mul %Size 1, 1
	%147 = mul %Size %8, 1
	%148 = mul %Size %8, 8
	%149 = mul %Size %145, %147
	%150 = add %Size 0, %149
	%151 = trunc %Size %150 to %Nat32
	%152 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %16, %Nat32 %151
	%153 = bitcast [0 x %Str8*]* %152 to [0 x %Str8*]*
	%154 = bitcast [0 x %Nat32]* %27 to [0 x %Nat32]*
	%155 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%156 = load %Nat32, %Nat32* %155
	call void @printRow([0 x %Str8*]* %153, [0 x %Nat32]* %154, %Nat32 %156)
; if_4
	%157 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 4
	%158 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 2
	%159 = load %Nat32, %Nat32* %158
	%160 = sub %Nat32 %159, 1
	%161 = load %Nat32, %Nat32* %i
	%162 = icmp ult %Nat32 %161, %160
	%163 = load %Bool, %Bool* %157
	%164 = and %Bool %163, %162
	br %Bool %164 , label %then_4, label %endif_4
then_4:
	%165 = bitcast [0 x %Nat32]* %27 to [0 x %Nat32]*
	%166 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%167 = load %Nat32, %Nat32* %166
	call void @separator([0 x %Nat32]* %165, %Nat32 %167)
	br label %endif_4
endif_4:
	%168 = load %Nat32, %Nat32* %i
	%169 = add %Nat32 %168, 1
	store %Nat32 %169, %Nat32* %i
	br label %again_5
break_5:
	%170 = bitcast [0 x %Nat32]* %27 to [0 x %Nat32]*
	%171 = getelementptr %table_Table, %table_Table* %table, %Int32 0, %Int32 3
	%172 = load %Nat32, %Nat32* %171
	call void @separator([0 x %Nat32]* %170, %Nat32 %172)
	%173 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %173)
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
	%4 = mul %Size 1, 1
	%5 = mul %Size %3, 1
	%6 = mul %Size %3, 8
	%7 = bitcast [0 x %Str8*]* %raw_row to [0 x %Str8*]*
	%8 = mul %Size 1, 1
	%9 = mul %Size %3, 1
	%10 = mul %Size %3, 8
	store %Nat32 0, %Nat32* %j
; while_1
	br label %again_1
again_1:
	%11 = load %Nat32, %Nat32* %j
	%12 = icmp ult %Nat32 %11, %nCols
	br %Bool %12 , label %body_1, label %break_1
body_1:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str1 to [0 x i8]*))
	%14 = load %Nat32, %Nat32* %j
	%15 = zext %Nat32 %14 to %Size
	%16 = mul %Size 1, 1
	%17 = mul %Size %15, 1
	%18 = add %Size 0, %17
	%19 = trunc %Size %18 to %Nat32
	%20 = getelementptr %Str8*, [0 x %Str8*]* %7, %Nat32 %19
	%21 = load %Str8*, %Str8** %20
	%22 = call %SizeT @strlen(%Str8* %21)
	%23 = trunc %SizeT %22 to %Nat32
	store %Nat32 %23, %Nat32* %len
; if_0
	%24 = getelementptr %Str8, %Str8* %21, %Int32 0, %Int32 0
	%25 = load %Char8, %Char8* %24
	%26 = icmp ne %Char8 %25, 0
	br %Bool %26 , label %then_0, label %endif_0
then_0:
	%27 = load %Nat32, %Nat32* %len
	%28 = add %Nat32 %27, 1
	store %Nat32 %28, %Nat32* %len
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @.str2 to [0 x i8]*), %Str8* %21)
	br label %endif_0
endif_0:
	store %Nat32 0, %Nat32* %k
; while_2
	br label %again_2
again_2:
	%30 = load %Nat32, %Nat32* %j
	%31 = bitcast %Nat32 %30 to %Nat32
	%32 = getelementptr [0 x %Nat32], [0 x %Nat32]* %sz, %Int32 0, %Nat32 %31
	%33 = load %Nat32, %Nat32* %32
	%34 = load %Nat32, %Nat32* %len
	%35 = sub %Nat32 %33, %34
	%36 = load %Nat32, %Nat32* %k
	%37 = icmp ult %Nat32 %36, %35
	br %Bool %37 , label %body_2, label %break_2
body_2:
	%38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @.str3 to [0 x i8]*))
	%39 = load %Nat32, %Nat32* %k
	%40 = add %Nat32 %39, 1
	store %Nat32 %40, %Nat32* %k
	br label %again_2
break_2:
	%41 = load %Nat32, %Nat32* %j
	%42 = add %Nat32 %41, 1
	store %Nat32 %42, %Nat32* %j
	br label %again_1
break_1:
	%43 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @.str4 to [0 x i8]*))
	%44 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %44)
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


