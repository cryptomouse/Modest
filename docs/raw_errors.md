# Raw errors — обзор сообщений компилятора

Автоматически собранный список всех вызовов `error()`, `fatal()`, `warning()`, `note()`, `info()` из `src/` (кроме самого `src/error.py`). Сообщение приведено как Python-выражение из исходника (f-строки / `%`-форматирование как есть). Закомментированные вызовы не включены.

## Сводка

| Уровень | Кол-во |
|---|---|
| fatal | 10 |
| error | 157 |
| warning | 8 |
| note | 1 |
| info | 14 |
| **всего** | **190** |

| Файл | Кол-во |
|---|---|
| [src/semantic.py](../src/semantic.py) | 118 |
| [src/parser.py](../src/parser.py) | 27 |
| [src/value/cons.py](../src/value/cons.py) | 7 |
| [src/backend/llvm.py](../src/backend/llvm.py) | 6 |
| [src/lexer.py](../src/lexer.py) | 6 |
| [src/backend/c11.py](../src/backend/c11.py) | 5 |
| [src/main.py](../src/main.py) | 4 |
| [src/hlir/types.py](../src/hlir/types.py) | 3 |
| [src/value/char.py](../src/value/char.py) | 2 |
| [src/value/float.py](../src/value/float.py) | 2 |
| [src/value/int.py](../src/value/int.py) | 2 |
| [src/value/nat.py](../src/value/nat.py) | 2 |
| [src/value/word.py](../src/value/word.py) | 2 |
| [src/backend/modest.py](../src/backend/modest.py) | 1 |
| [src/value/array.py](../src/value/array.py) | 1 |
| [src/value/fixed.py](../src/value/fixed.py) | 1 |
| [src/value/pointer.py](../src/value/pointer.py) | 1 |

## По файлам

### src/semantic.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [semantic.py:470](../src/semantic.py#L470) | error | `do_field` | `"unsuitable type"` |
| [semantic.py:473](../src/semantic.py#L473) | error | `do_field` | `"using of an incompleted type"` |
| [semantic.py:515](../src/semantic.py#L515) | error | `do_type_named` | `"via import is forbidden"` |
| [semantic.py:521](../src/semantic.py#L521) | error | `do_type_named` | `"module '%s' not found" % left_id_str` |
| [semantic.py:527](../src/semantic.py#L527) | error | `do_type_named` | `"unknown namespace"` |
| [semantic.py:533](../src/semantic.py#L533) | error | `do_type_named` | `"undefined type2"` |
| [semantic.py:536](../src/semantic.py#L536) | error | `do_type_named` | `"access to private type"` |
| [semantic.py:556](../src/semantic.py#L556) | error | `do_type_named` | `"undefined type"` |
| [semantic.py:564](../src/semantic.py#L564) | warning | `do_type_named` | `"using a deprecated type"` |
| [semantic.py:571](../src/semantic.py#L571) | error | `change_type_layout` | `"unsupported layout"` |
| [semantic.py:608](../src/semantic.py#L608) | error | `do_type_array` | `"using of an incompleted type"` |
| [semantic.py:621](../src/semantic.py#L621) | error | `do_type_array` | `"non local VLA are forbidden"` |
| [semantic.py:650](../src/semantic.py#L650) | error | `do_type_record` | `"redefinition of '%s' field" % field_id_str` |
| [semantic.py:693](../src/semantic.py#L693) | error | `do_type_func` | `"forbidden param type"` |
| [semantic.py:700](../src/semantic.py#L700) | error | `do_type_func` | `"using of an incompleted type"` |
| [semantic.py:703](../src/semantic.py#L703) | error | `do_type_func` | `"forbidden retval type"` |
| [semantic.py:793](../src/semantic.py#L793) | error | `append_common_type_annos` | `"annotation '%s' not defined\n" % a['kind']` |
| [semantic.py:809](../src/semantic.py#L809) | error | `do_value_shift` | `"expected word value"` |
| [semantic.py:813](../src/semantic.py#L813) | error | `do_value_shift` | `"expected natural or non-negative integer value"` |
| [semantic.py:820](../src/semantic.py#L820) | error | `do_value_shift` | `"a literal can only be shifted by a compile-time count"` |
| [semantic.py:821](../src/semantic.py#L821) | info | `do_value_shift` | `` "give the literal a type first, e.g. `Word32 0x01 << n`" `` |
| [semantic.py:889](../src/semantic.py#L889) | error | `do_value_bin_op` | `"cannot concat arrays"` |
| [semantic.py:904](../src/semantic.py#L904) | error | `do_value_bin_op` | `"different types '%s' & '%s' in operation" % (l.type.to_str(), r.type.to_str())` |
| [semantic.py:919](../src/semantic.py#L919) | error | `do_value_bin_op` | `"unsuitable value type '%s' for '%s' operation" % (l.type.to_str(), op)` |
| [semantic.py:923](../src/semantic.py#L923) | error | `do_value_bin_op` | `"unsuitable value type '%s' for '%s' operation" % (r.type.to_str(), op)` |
| [semantic.py:927](../src/semantic.py#L927) | error | `do_value_bin_op` | `"cannot implicitly cons to common type '%s' & '%s'" % (l.type.to_str(), r.type.to_str())` |
| [semantic.py:944](../src/semantic.py#L944) | error | `do_value_bin_op` | `"division by zero"` |
| [semantic.py:968](../src/semantic.py#L968) | error | `do_value_bin_op` | `"float overflow"` |
| [semantic.py:969](../src/semantic.py#L969) | info | `do_value_bin_op` | `` "`%s` holds at most %s" % (t.to_str(), str_fractional(float_max(t.width), 64)) `` |
| [semantic.py:975](../src/semantic.py#L975) | error | `do_value_bin_op` | `"fixed point overflow" if t.is_fixed() else "integer overflow"` |
| [semantic.py:1016](../src/semantic.py#L1016) | error | `do_bin_immediate` | `"division by zero"` |
| [semantic.py:1050](../src/semantic.py#L1050) | error | `do_value_unary_check` | `"unsuitable value type '%s' for '%s' operation" % (v.type.to_str(), op)` |
| [semantic.py:1093](../src/semantic.py#L1093) | error | `do_value_bitwise_not` | `"expected non-negative integer value"` |
| [semantic.py:1134](../src/semantic.py#L1134) | error | `do_value_neg` | `"expected value with signed type"` |
| [semantic.py:1176](../src/semantic.py#L1176) | error | `do_value_pos` | `"expected value with signed type"` |
| [semantic.py:1222](../src/semantic.py#L1222) | error | `do_value_ref` | `"expected mutable value or function"` |
| [semantic.py:1241](../src/semantic.py#L1241) | error | `do_value_new` | `"operation new requires value with aggregate type"` |
| [semantic.py:1260](../src/semantic.py#L1260) | error | `do_value_deref` | `"expected pointer value"` |
| [semantic.py:1273](../src/semantic.py#L1273) | error | `do_value_deref` | `"cannot dereference the pointer"` |
| [semantic.py:1291](../src/semantic.py#L1291) | error | `do_value_lengthof_value` | `"expected value with array type"` |
| [semantic.py:1308](../src/semantic.py#L1308) | error | `do_value_lengthof_type` | `"expected array type"` |
| [semantic.py:1388](../src/semantic.py#L1388) | error | `do_value_call` | `"expected function or pointer to function"` |
| [semantic.py:1398](../src/semantic.py#L1398) | error | `do_value_call` | `"too many arguments"` |
| [semantic.py:1439](../src/semantic.py#L1439) | error | `do_value_call` | `"unknown argument '%s'" % a['key']['str']` |
| [semantic.py:1459](../src/semantic.py#L1459) | error | `do_value_call` | `"positional argument follows keyword argument"` |
| [semantic.py:1474](../src/semantic.py#L1474) | error | `do_value_call` | `"unspecified parameter '%s'" % p_id_str` |
| [semantic.py:1481](../src/semantic.py#L1481) | error | `do_value_call` | `"not enough arguments"` |
| [semantic.py:1503](../src/semantic.py#L1503) | warning | `do_value_call` | `"extra argument with generic type"` |
| [semantic.py:1540](../src/semantic.py#L1540) | warning | `ct_call` | `"compile time call not implemented, will returned zero value!"` |
| [semantic.py:1571](../src/semantic.py#L1571) | error | `do_rvalue_integral` | `"expected integral value"` |
| [semantic.py:1581](../src/semantic.py#L1581) | error | `do_rvalue_bool` | `"expected value with Bool type"` |
| [semantic.py:1611](../src/semantic.py#L1611) | error | `do_value_index` | `"array index must be non-negative"` |
| [semantic.py:1616](../src/semantic.py#L1616) | error | `do_value_index` | `"cannot index string in runtime"` |
| [semantic.py:1623](../src/semantic.py#L1623) | error | `do_value_index` | `"string index out of bounds"` |
| [semantic.py:1640](../src/semantic.py#L1640) | error | `do_value_index` | `"expected array, pointer to array, or string"` |
| [semantic.py:1646](../src/semantic.py#L1646) | error | `do_value_index` | `"cannot index an array of unsized array"` |
| [semantic.py:1650](../src/semantic.py#L1650) | error | `do_value_index` | `"cannot index array with generic type in runtime"` |
| [semantic.py:1657](../src/semantic.py#L1657) | error | `do_value_index` | `"array index out of bounds"` |
| [semantic.py:1717](../src/semantic.py#L1717) | error | `do_value_slice` | `"expected array or pointer to array"` |
| [semantic.py:1724](../src/semantic.py#L1724) | error | `do_value_slice` | `"cannot slice array of an unsized array"` |
| [semantic.py:1737](../src/semantic.py#L1737) | error | `do_value_slice` | `"slice index must be non-negative"` |
| [semantic.py:1742](../src/semantic.py#L1742) | error | `do_value_slice` | `"empty slice"` |
| [semantic.py:1745](../src/semantic.py#L1745) | error | `do_value_slice` | `"wrong slice direction"` |
| [semantic.py:1753](../src/semantic.py#L1753) | error | `do_value_slice` | `"slice index out of bounds"` |
| [semantic.py:1756](../src/semantic.py#L1756) | error | `do_value_slice` | `"slice index out of bounds"` |
| [semantic.py:1789](../src/semantic.py#L1789) | error | `do_value_access` | `"unknown value"` |
| [semantic.py:1792](../src/semantic.py#L1792) | error | `do_value_access` | `` "access to private value `%s.%s`" % (left['str'], x['right']['str']) `` |
| [semantic.py:1812](../src/semantic.py#L1812) | error | `acc` | `"expected record or pointer to record"` |
| [semantic.py:1819](../src/semantic.py#L1819) | error | `acc` | `"undefined field '%s'" % field_id['str']` |
| [semantic.py:1830](../src/semantic.py#L1830) | error | `acc` | `"access to private field of record"` |
| [semantic.py:1867](../src/semantic.py#L1867) | error | `do_value_named` | `"undefined value '%s'" % id_str` |
| [semantic.py:1888](../src/semantic.py#L1888) | warning | `do_value_named` | `"using a deprecated value"` |
| [semantic.py:1894](../src/semantic.py#L1894) | error | `do_value_named` | `"use of incomplete value"` |
| [semantic.py:2022](../src/semantic.py#L2022) | error | `do_value_sizeof_type` | `"sizeof(<#type_function#>) are forbidden"` |
| [semantic.py:2029](../src/semantic.py#L2029) | error | `do_value_sizeof_value` | `"sizeof(<#value_function#>) are forbidden"` |
| [semantic.py:2069](../src/semantic.py#L2069) | error | `do_value_immediate` | `"expected immediate value2"` |
| [semantic.py:2082](../src/semantic.py#L2082) | error | `do_value_immediate_string` | `"expected string value"` |
| [semantic.py:2113](../src/semantic.py#L2113) | error | `do_rvalue` | `"attempt to use an uninitialized value"` |
| [semantic.py:2174](../src/semantic.py#L2174) | error | `do_value` | `"unknown value kind '%s'" % k` |
| [semantic.py:2190](../src/semantic.py#L2190) | error | `do_stmt_let` | `"redefinition of '%s'" % x['id']['str']` |
| [semantic.py:2216](../src/semantic.py#L2216) | error | `do_stmt_var` | `"redefinition of '%s'" % x['id']['str']` |
| [semantic.py:2282](../src/semantic.py#L2282) | error | `do_stmt_return` | `"expected return value"` |
| [semantic.py:2329](../src/semantic.py#L2329) | error | `do_stmt_assign` | `"expected lvalue"` |
| [semantic.py:2333](../src/semantic.py#L2333) | error | `do_stmt_assign` | `"expected mutable value"` |
| [semantic.py:2371](../src/semantic.py#L2371) | error | `do_stmt_incdec` | `"expected mutable value"` |
| [semantic.py:2375](../src/semantic.py#L2375) | error | `do_stmt_incdec` | `"expected value with integer type"` |
| [semantic.py:2497](../src/semantic.py#L2497) | error | `do_stmt` | `"annotation '%s' not defined2\n" % a['kind']` |
| [semantic.py:2543](../src/semantic.py#L2543) | error | `def_type_common` | `"expected type expr"` |
| [semantic.py:2577](../src/semantic.py#L2577) | error | `def_type_common` | `"using a private type in a public context"` |
| [semantic.py:2610](../src/semantic.py#L2610) | error | `def_type_common` | `"rec dep!"` |
| [semantic.py:2614](../src/semantic.py#L2614) | error | `def_type_common` | `"is_incompleted"` |
| [semantic.py:2630](../src/semantic.py#L2630) | error | `def_type_global` | `"type redefinition"` |
| [semantic.py:2662](../src/semantic.py#L2662) | error | `process_field_common` | `"type mismatch %s & %s" % (var_type.to_str(), init_value.type.to_str())` |
| [semantic.py:2738](../src/semantic.py#L2738) | error | `def_const_common` | `"unsuitable type"` |
| [semantic.py:2742](../src/semantic.py#L2742) | error | `def_const_common` | `"public constant must have a non-generic type"` |
| [semantic.py:2744](../src/semantic.py#L2744) | error | `def_const_common` | `"using a private type in a public context"` |
| [semantic.py:2790](../src/semantic.py#L2790) | error | `def_var_common` | `"public variables are forbidden"` |
| [semantic.py:2792](../src/semantic.py#L2792) | error | `def_var_common` | `"using a private type in a public context"` |
| [semantic.py:2795](../src/semantic.py#L2795) | error | `def_var_common` | `"unsuitable type"` |
| [semantic.py:2802](../src/semantic.py#L2802) | error | `def_var_common` | `"variable of unsized array type requires an initializer"` |
| [semantic.py:2846](../src/semantic.py#L2846) | error | `def_const_global` | `"redefinition of '%s'" % x['id']['str']` |
| [semantic.py:2857](../src/semantic.py#L2857) | error | `def_const_global` | `"expected immediate value"` |
| [semantic.py:2869](../src/semantic.py#L2869) | error | `def_var_global` | `"redefinition of '%s'" % x['id']['str']` |
| [semantic.py:2920](../src/semantic.py#L2920) | error | `def_func` | `"expected a function type"` |
| [semantic.py:3001](../src/semantic.py#L3001) | warning | `def_func` | `"expected return operator at end"` |
| [semantic.py:3030](../src/semantic.py#L3030) | info | `check_unuse` | `"value '%s' defined but not used" % id_str` |
| [semantic.py:3083](../src/semantic.py#L3083) | error | `do_import` | `"module %s not found" % impline` |
| [semantic.py:3098](../src/semantic.py#L3098) | error | `do_import` | `"recursive import detected"` |
| [semantic.py:3104](../src/semantic.py#L3104) | fatal | `do_import` | `"recursive import detected '%s'" % abspath` |
| [semantic.py:3121](../src/semantic.py#L3121) | fatal | `do_import` | `"cannot import module"` |
| [semantic.py:3203](../src/semantic.py#L3203) | error | `do_directive_pragma` | `"expected string literal"` |
| [semantic.py:3208](../src/semantic.py#L3208) | error | `do_directive_pragma` | `"unknown pragma '%s'" % id` |
| [semantic.py:3306](../src/semantic.py#L3306) | warning | `process_module` | `"unised import"` |
| [semantic.py:3366](../src/semantic.py#L3366) | error | `decl_func` | `"redefinition of '%s'" % x['id']['str']` |
| [semantic.py:3367](../src/semantic.py#L3367) | info | `decl_func` | `"previous definition was here"` |
| [semantic.py:3478](../src/semantic.py#L3478) | error | `def_phase2` | `"annotation '%s' not defined\n" % a['kind']` |
| [semantic.py:3531](../src/semantic.py#L3531) | fatal | `getObjAttrByPath` | `"Object %s has not attribute %s" % (str(x), step)` |
| [semantic.py:3541](../src/semantic.py#L3541) | fatal | `setObjAttrByPath` | `"Object %s has not attribute %s" % (str(x), step)` |

### src/parser.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [parser.py:212](../src/parser.py#L212) | error | `need` | `"expected '%s' token" % token` |
| [parser.py:243](../src/parser.py#L243) | error | `parse_identifier` | `"value identifier must start with a small letter; '%s' names a type" % s` |
| [parser.py:252](../src/parser.py#L252) | error | `parse_Identifier` | `"type identifier must start with a capital letter; '%s' names a value" % s` |
| [parser.py:268](../src/parser.py#L268) | error | `need_sep` | `"expected separator"` |
| [parser.py:316](../src/parser.py#L316) | error | `parse_type_record` | `"expected '}' (unexpected end of file)"` |
| [parser.py:485](../src/parser.py#L485) | error | `parse_type_func` | `"expected ')' (unexpected end of file)"` |
| [parser.py:510](../src/parser.py#L510) | error | `parse_type_func` | `"expected -> return type"` |
| [parser.py:536](../src/parser.py#L536) | error | `_parse_type_atom` | `"expected type expr"` |
| [parser.py:709](../src/parser.py#L709) | error | `expr_value_3` | `"required parentheses"` |
| [parser.py:797](../src/parser.py#L797) | error | `expr_value_4` | `"required parentheses"` |
| [parser.py:1062](../src/parser.py#L1062) | error | `parse_args` | `"expected ')' token"` |
| [parser.py:1081](../src/parser.py#L1081) | error | `parse_args` | `"expected identifier"` |
| [parser.py:1102](../src/parser.py#L1102) | error | `parse_args` | `"expected ')' token"` |
| [parser.py:1208](../src/parser.py#L1208) | error | `parse_value_array` | `"expected ']' (unexpected end of file)"` |
| [parser.py:1262](../src/parser.py#L1262) | error | `parse_value_record` | `"expected '}' (unexpected end of file)"` |
| [parser.py:1358](../src/parser.py#L1358) | error | `parse_value_string` | `"expected exactly 2 hex digits after \\x"` |
| [parser.py:1367](../src/parser.py#L1367) | error | `parse_value_string` | `"expected '{' after \\u"` |
| [parser.py:1376](../src/parser.py#L1376) | error | `parse_value_string` | `"expected \\u{H...H} with 1-6 hex digits"` |
| [parser.py:1385](../src/parser.py#L1385) | error | `parse_value_string` | `"\\u{%s} is outside the Unicode range (max 10FFFF)" % cod` |
| [parser.py:1691](../src/parser.py#L1691) | error | `expr_value_term` | `"unexpected token1 '%s'" % tokstr` |
| [parser.py:1943](../src/parser.py#L1943) | error | `stmt_block` | `"expected '}' (unexpected end of file)"` |
| [parser.py:1944](../src/parser.py#L1944) | note | `stmt_block` | `"to match this '{'"` |
| [parser.py:2124](../src/parser.py#L2124) | error | `parse_def_func` | `"expected ':' token"` |
| [parser.py:2126](../src/parser.py#L2126) | warning | `parse_def_func` | `"function signature should be preceded by ':' — write 'func %s: (...) -> ...'" % id['str']` |
| [parser.py:2179](../src/parser.py#L2179) | warning | `parse_stmt_field` | `"missing ':' before type"` |
| [parser.py:2434](../src/parser.py#L2434) | error | `parse` | `"unexpected token '%s'" % self.ctok()` |
| [parser.py:2442](../src/parser.py#L2442) | error | `parse` | `"%s cannot have any access level modifier" % x['kind']` |

### src/value/cons.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [cons.py:71](../src/value/cons.py#L71) | error | `cons_can` | `"cannot construct value of incompleted type"` |
| [cons.py:74](../src/value/cons.py#L74) | info | `cons_can` | `str(to)` |
| [cons.py:142](../src/value/cons.py#L142) | error | `value_cons_implicit_check` | `"type error2"` |
| [cons.py:150](../src/value/cons.py#L150) | error | `value_cons_implicit_check` | `` "cannot implicitly construct `%s` from `%s`\n" % (t.to_str(), v.type.to_str()) `` |
| [cons.py:173](../src/value/cons.py#L173) | info | `value_cons_explicit` | `"explicit cons from the same type"` |
| [cons.py:177](../src/value/cons.py#L177) | error | `value_cons_explicit` | `"cannot construct '%s' from '%s' value" % (t.to_str(), from_type.to_str())` |
| [cons.py:197](../src/value/cons.py#L197) | error | `value_cons_default` | `"cannot select default type for value with generic type"` |

### src/backend/llvm.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [llvm.py:220](../src/backend/llvm.py#L220) | error | `llvm_value_undef` | `"undefined value in llvm backend"` |
| [llvm.py:586](../src/backend/llvm.py#L586) | info | `llvm_print_value` | `"<llvm::unknown_value_kind '%s'>" % k` |
| [llvm.py:1368](../src/backend/llvm.py#L1368) | error | `do_eval_slice` | `"expected immediate index value"` |
| [llvm.py:1984](../src/backend/llvm.py#L1984) | info | `do_eval_string` | `"do_eval_string??"` |
| [llvm.py:2121](../src/backend/llvm.py#L2121) | error | `do_eval_literal` | `"do_eval_literal: unknown literal"` |
| [llvm.py:2253](../src/backend/llvm.py#L2253) | error | `do_eval` | `"llvm do_eval cannot eval (%s) value" % 'k'` |

### src/lexer.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [lexer.py:218](../src/lexer.py#L218) | error | `doId` | `"identifier '%s' contains non-ASCII characters" % s` |
| [lexer.py:273](../src/lexer.py#L273) | error | `doNumber` | `"hexadecimal literal cannot have a fractional part"` |
| [lexer.py:275](../src/lexer.py#L275) | error | `doNumber` | `"number literal has more than one '.'"` |
| [lexer.py:277](../src/lexer.py#L277) | error | `doNumber` | `"expected digit after '.' in number literal"` |
| [lexer.py:354](../src/lexer.py#L354) | error | `doString` | `"unexpected EOF in a string literal"` |
| [lexer.py:459](../src/lexer.py#L459) | error | `doBlockComment` | `"unexpected EOF in a block comment"` |

### src/backend/c11.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [c11.py:647](../src/backend/c11.py#L647) | error | `do_cvalue_literal_with_type` | `"str_value_literal not implemented for %s" % str(t)` |
| [c11.py:1594](../src/backend/c11.py#L1594) | error | `do_cvalue` | `"value undef in C backend"` |
| [c11.py:1597](../src/backend/c11.py#L1597) | error | `do_cvalue` | `"value bad in C backend"` |
| [c11.py:2563](../src/backend/c11.py#L2563) | fatal | `copy_runtime_headers` | `"runtime header not found: %s" % src` |
| [c11.py:2640](../src/backend/c11.py#L2640) | error | `do_cvalue_mem` | `"attempt to load non aggregate"` |

### src/main.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [main.py:51](../src/main.py#L51) | fatal | `main` | `"no input files\n"` |
| [main.py:62](../src/main.py#L62) | fatal | `main` | `"required path to library"` |
| [main.py:104](../src/main.py#L104) | fatal | `do_file` | `"file \"%s\" not found" % src_name` |
| [main.py:120](../src/main.py#L120) | fatal | `do_file` | `"backend not specified (cfg: backend.default)"` |

### src/hlir/types.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [types.py:1422](../src/hlir/types.py#L1422) | info | `select_common_type` | `` "cannot select common type (`%s` & `%s`)" % (a.to_str(), b.to_str()) `` |
| [types.py:2075](../src/hlir/types.py#L2075) | info | `print` | `msg` |
| [types.py:2533](../src/hlir/types.py#L2533) | error | `__init__` | `"undefined field '%s'" % field_id.str` |

### src/value/char.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [char.py:49](../src/value/char.py#L49) | error | `value_char_cons` | `"cannot construct %s value from String with length != 1" % t.to_str()` |
| [char.py:56](../src/value/char.py#L56) | error | `value_char_cons` | `"cannot construct %s value from String" % t.to_str()` |

### src/value/float.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [float.py:56](../src/value/float.py#L56) | error | `value_float_cons` | `"float overflow"` |
| [float.py:57](../src/value/float.py#L57) | info | `value_float_cons` | `` "`%s` holds at most %s" % (t.to_str(), str_fractional(float_max(t.width), 64)) `` |

### src/value/int.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [int.py:67](../src/value/int.py#L67) | error | `value_int_cons` | `"integer overflow"` |
| [int.py:68](../src/value/int.py#L68) | info | `value_int_cons` | `` "attempt to construct `%s` from `%s`" % (t.to_str(), v.type.to_str()) `` |

### src/value/nat.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [nat.py:62](../src/value/nat.py#L62) | error | `value_nat_cons` | `"integer overflow"` |
| [nat.py:63](../src/value/nat.py#L63) | info | `value_nat_cons` | `` "attempt to construct `%s` from `%s`" % (t.to_str(), v.type.to_str()) `` |

### src/value/word.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [word.py:60](../src/value/word.py#L60) | error | `value_word_cons` | `"word overflow"` |
| [word.py:63](../src/value/word.py#L63) | error | `value_word_cons` | `"word overflow"` |

### src/backend/modest.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [modest.py:82](../src/backend/modest.py#L82) | fatal | `style_setting` | `"backend.modest.%s: expected 'same-line' or 'next-line', got '%s'" % (name, v)` |

### src/value/array.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [array.py:38](../src/value/array.py#L38) | error | `value_array_create` | `"value with unsuitable type"` |

### src/value/fixed.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [fixed.py:94](../src/value/fixed.py#L94) | error | `fixed_cons_immediate` | `"fixed point (%d.%d) overflow" % (t.width - t.fraction, t.fraction)` |

### src/value/pointer.py

| Где | Уровень | Функция | Сообщение |
|---|---|---|---|
| [pointer.py:18](../src/value/pointer.py#L18) | info | `value_pointer_can` | `"Cannot cons pointer!! from %s to %s" % (from_type, to)` |

## Повторяющиеся сообщения

Одинаковый текст в нескольких местах — кандидаты на объединение/уточнение.

| Сообщение | Раз | Где |
|---|---|---|
| `"redefinition of '%s'" % x['id']['str']` | 5 | [semantic.py:2190](../src/semantic.py#L2190), [semantic.py:2216](../src/semantic.py#L2216), [semantic.py:2846](../src/semantic.py#L2846), [semantic.py:2869](../src/semantic.py#L2869), [semantic.py:3366](../src/semantic.py#L3366) |
| `"expected '}' (unexpected end of file)"` | 3 | [parser.py:316](../src/parser.py#L316), [parser.py:1262](../src/parser.py#L1262), [parser.py:1943](../src/parser.py#L1943) |
| `"unsuitable type"` | 3 | [semantic.py:470](../src/semantic.py#L470), [semantic.py:2738](../src/semantic.py#L2738), [semantic.py:2795](../src/semantic.py#L2795) |
| `"using of an incompleted type"` | 3 | [semantic.py:473](../src/semantic.py#L473), [semantic.py:608](../src/semantic.py#L608), [semantic.py:700](../src/semantic.py#L700) |
| `"using a private type in a public context"` | 3 | [semantic.py:2577](../src/semantic.py#L2577), [semantic.py:2744](../src/semantic.py#L2744), [semantic.py:2792](../src/semantic.py#L2792) |
| `"expected type expr"` | 2 | [parser.py:536](../src/parser.py#L536), [semantic.py:2543](../src/semantic.py#L2543) |
| `"required parentheses"` | 2 | [parser.py:709](../src/parser.py#L709), [parser.py:797](../src/parser.py#L797) |
| `"expected ')' token"` | 2 | [parser.py:1062](../src/parser.py#L1062), [parser.py:1102](../src/parser.py#L1102) |
| `"annotation '%s' not defined\n" % a['kind']` | 2 | [semantic.py:793](../src/semantic.py#L793), [semantic.py:3478](../src/semantic.py#L3478) |
| `"division by zero"` | 2 | [semantic.py:944](../src/semantic.py#L944), [semantic.py:1016](../src/semantic.py#L1016) |
| `"float overflow"` | 2 | [semantic.py:968](../src/semantic.py#L968), [float.py:56](../src/value/float.py#L56) |
| `` "`%s` holds at most %s" % (t.to_str(), str_fractional(float_max(t.width), 64)) `` | 2 | [semantic.py:969](../src/semantic.py#L969), [float.py:57](../src/value/float.py#L57) |
| `"expected value with signed type"` | 2 | [semantic.py:1134](../src/semantic.py#L1134), [semantic.py:1176](../src/semantic.py#L1176) |
| `"slice index out of bounds"` | 2 | [semantic.py:1753](../src/semantic.py#L1753), [semantic.py:1756](../src/semantic.py#L1756) |
| `"expected mutable value"` | 2 | [semantic.py:2333](../src/semantic.py#L2333), [semantic.py:2371](../src/semantic.py#L2371) |
| `"Object %s has not attribute %s" % (str(x), step)` | 2 | [semantic.py:3531](../src/semantic.py#L3531), [semantic.py:3541](../src/semantic.py#L3541) |
| `"integer overflow"` | 2 | [int.py:67](../src/value/int.py#L67), [nat.py:62](../src/value/nat.py#L62) |
| `` "attempt to construct `%s` from `%s`" % (t.to_str(), v.type.to_str()) `` | 2 | [int.py:68](../src/value/int.py#L68), [nat.py:63](../src/value/nat.py#L63) |
| `"word overflow"` | 2 | [word.py:60](../src/value/word.py#L60), [word.py:63](../src/value/word.py#L63) |

## Приложение: прочие выводы, не через error.py

Отладочные `print()` (часть — с `exit(1)`) в обход `error()` — пользователь увидит дамп без позиции в исходнике:

- [src/value/cons.py:143](../src/value/cons.py#L143)
- [src/value/cons.py:301](../src/value/cons.py#L301)
- [src/backend/c11.py:1595](../src/backend/c11.py#L1595)
- [src/backend/c11.py:1598](../src/backend/c11.py#L1598)
- [src/backend/c11.py:2641](../src/backend/c11.py#L2641)
- [src/backend/llvm.py:1515](../src/backend/llvm.py#L1515)
- [src/backend/llvm.py:2122](../src/backend/llvm.py#L2122)
- [src/backend/llvm.py:2254](../src/backend/llvm.py#L2254)
- [src/hlir/types.py:1419](../src/hlir/types.py#L1419)
- [src/semantic.py:3313](../src/semantic.py#L3313)
