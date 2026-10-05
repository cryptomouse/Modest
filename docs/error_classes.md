# Классы ошибок компилятора

Разбор сообщений из [raw_errors.md](raw_errors.md) (190 вызовов `error/fatal/warning/note/info`) по смысловым классам. Несколько сообщений попадают в два класса (например, `module '%s' not found` — и «неизвестное имя», и «импорт»), такие продублированы.

## Сводка

| # | Класс | Сколько | Основной источник |
|---|---|---|---|
| 1 | Драйвер, окружение, конфигурация | 6 | main.py, backend |
| 2 | Лексические ошибки | 10 | lexer.py, parser.py |
| 3 | Синтаксис: ожидался / неожиданный токен | 18 | parser.py |
| 4 | Синтаксис: стиль и соглашения | 5 | parser.py |
| 5 | Неизвестное имя | 16 | semantic.py |
| 6 | Повторное определение | 8 | semantic.py |
| 7 | Доступ и видимость | 9 | semantic.py |
| 8 | Несоответствие типов операндов / присваивания | 6 | semantic.py, cons.py |
| 9 | Ожидалась другая категория типа | 24 | semantic.py |
| 10 | Тип запрещён в этой позиции | 10 | semantic.py |
| 11 | Неполные типы и рекурсивные зависимости | 7 | semantic.py |
| 12 | Конструирование значения | 10 | value/*.py |
| 13 | Переполнение и арифметика констант | 12 | semantic.py, value/*.py |
| 14 | Индексы, срезы, границы | 10 | semantic.py |
| 15 | Требуется значение времени компиляции | 8 | semantic.py |
| 16 | Изменяемость, lvalue, инициализация | 5 | semantic.py |
| 17 | Вызов функции: аргументы | 7 | semantic.py |
| 18 | Возврат из функции | 2 | semantic.py |
| 19 | Импорт и модули | 7 | semantic.py |
| 20 | Предупреждения о качестве кода | 4 | semantic.py |
| 21 | Внутренние ошибки / не реализовано | 13 | backend, semantic.py |

## Наблюдения

**Отладочные / временные тексты, видимые пользователю.** `undefined type2`, `expected immediate value2`, `type error2`, `annotation '%s' not defined2`, `unexpected token1`, `rec dep!`, `is_incompleted`, `do_eval_string??`. Цифра в конце — явно метка «второй экземпляр», её надо убрать и дать нормальный текст.

**Нет имени виновника.** `undefined type`, `undefined type2`, `access to private type`, `unsuitable type`, `unknown value`, `expected mutable value`, `type redefinition`, `using of an incompleted type` — не говорят, *какой* тип/значение. Рядом `undefined value '%s'` и `undefined field '%s'` имя дают — стоит выровнять.

**Разнобой в формулировках одного и того же:**
- неполный тип: `incompleted type` (×4), `incomplete value`, `is_incompleted`;
- переполнение: `integer overflow`, `word overflow`, `float overflow`, `fixed point overflow`, `fixed point (%d.%d) overflow`;
- конструирование: `cannot implicitly construct`, `cannot construct '%s' from '%s' value`, `cannot implicitly cons to common type`, `attempt to construct`, `Cannot cons pointer!!`;
- ожидание категории: `expected value with array type` vs `expected array type`, `expected value with signed type` vs `expected value with integer type` vs `expected integral value`;
- кавычки вокруг имён: то `'%s'`, то `` `%s` ``, то без кавычек (`module %s not found` рядом с `module '%s' not found`).

**Уровни сообщений.**
- Пояснения к ошибке идут через `info` (`previous definition was here`, `` `%s` holds at most %s ``, `attempt to construct ...`, `give the literal a type first ...`), хотя для этого есть `note` — используется он ровно один раз (`to match this '{'`).
- `compile time call not implemented, will returned zero value!` — `warning`, хотя это недоделка компилятора и молча даёт неверный результат; скорее ICE/`error`.
- `extra argument with generic type` — `warning`, непонятно, почему не ошибка.
- Внутренние ошибки (класс 21) оформлены как обычные `error` — пользователь не отличит свою ошибку от бага компилятора. Стоит завести отдельный уровень вроде `internal error:`.

**Хвостовой `\n` в тексте.** `no input files\n`, `annotation '%s' not defined\n` (×2), `...not defined2\n`, `cannot implicitly construct ...\n` — `str_common_message` и так добавляет перевод строки, получается пустая строка.

**Опечатки и грамматика.** `unised import`, `has not attribute`, `will returned`, `sizeof(...) are forbidden`, `using of an incompleted type`, `non local VLA are forbidden`, `Cannot cons pointer!!`.

**Дубли одного сообщения в соседних строках** (возможно, одно из мест мёртвое или стоит различить по тексту): `slice index out of bounds` (semantic.py:1753/1756), `word overflow` (word.py:60/63), `unsuitable value type` для левого/правого операнда (semantic.py:919/923 — текст не говорит, какой операнд).

**Ошибки без позиции (`ti`)** — помимо драйверных, `fatal("Object %s has not attribute %s")` в semantic.py:3531/3541 и проверка `backend.modest` — выдаются без указания места в исходнике.

## Классы подробно

### 1. Драйвер, окружение, конфигурация

Нет входных файлов, путей, бэкенда, неверная настройка. Все — `fatal`, без позиции в исходнике.

| Где | Ур. | Сообщение |
|---|---|---|
| [main.py:51](../src/main.py#L51) | fatal | `"no input files\n"` |
| [main.py:62](../src/main.py#L62) | fatal | `"required path to library"` |
| [main.py:104](../src/main.py#L104) | fatal | `"file \"%s\" not found" % src_name` |
| [main.py:120](../src/main.py#L120) | fatal | `"backend not specified (cfg: backend.default)"` |
| [backend/c11.py:2563](../src/backend/c11.py#L2563) | fatal | `"runtime header not found: %s" % src` |
| [backend/modest.py:82](../src/backend/modest.py#L82) | fatal | `"backend.modest.%s: expected 'same-line' or 'next-line', got '%s'" % (name, v)` |

### 2. Лексические ошибки

Литералы, комментарии, идентификаторы, escape-последовательности. Escape-ы проверяются в парсере, но по сути это лексика.

| Где | Ур. | Сообщение |
|---|---|---|
| [lexer.py:218](../src/lexer.py#L218) | error | `"identifier '%s' contains non-ASCII characters" % s` |
| [lexer.py:273](../src/lexer.py#L273) | error | `"hexadecimal literal cannot have a fractional part"` |
| [lexer.py:275](../src/lexer.py#L275) | error | `"number literal has more than one '.'"` |
| [lexer.py:277](../src/lexer.py#L277) | error | `"expected digit after '.' in number literal"` |
| [lexer.py:354](../src/lexer.py#L354) | error | `"unexpected EOF in a string literal"` |
| [lexer.py:459](../src/lexer.py#L459) | error | `"unexpected EOF in a block comment"` |
| [parser.py:1358](../src/parser.py#L1358) | error | `"expected exactly 2 hex digits after \\x"` |
| [parser.py:1367](../src/parser.py#L1367) | error | `"expected '{' after \\u"` |
| [parser.py:1376](../src/parser.py#L1376) | error | `"expected \\u{H...H} with 1-6 hex digits"` |
| [parser.py:1385](../src/parser.py#L1385) | error | `"\\u{%s} is outside the Unicode range (max 10FFFF)" % cod` |

### 3. Синтаксис: ожидался токен / неожиданный токен

Самый однородный класс; заметная часть — «unexpected end of file» для незакрытых скобок.

| Где | Ур. | Сообщение |
|---|---|---|
| [parser.py:212](../src/parser.py#L212) | error | `"expected '%s' token" % token` |
| [parser.py:268](../src/parser.py#L268) | error | `"expected separator"` |
| [parser.py:316](../src/parser.py#L316) | error | `"expected '}' (unexpected end of file)"` |
| [parser.py:485](../src/parser.py#L485) | error | `"expected ')' (unexpected end of file)"` |
| [parser.py:1208](../src/parser.py#L1208) | error | `"expected ']' (unexpected end of file)"` |
| [parser.py:1262](../src/parser.py#L1262) | error | `"expected '}' (unexpected end of file)"` |
| [parser.py:1943](../src/parser.py#L1943) | error | `"expected '}' (unexpected end of file)"` |
| [parser.py:1944](../src/parser.py#L1944) | note | `"to match this '{'"` |
| [parser.py:1062](../src/parser.py#L1062) | error | `"expected ')' token"` |
| [parser.py:1102](../src/parser.py#L1102) | error | `"expected ')' token"` |
| [parser.py:2124](../src/parser.py#L2124) | error | `"expected ':' token"` |
| [parser.py:510](../src/parser.py#L510) | error | `"expected -> return type"` |
| [parser.py:536](../src/parser.py#L536) | error | `"expected type expr"` |
| [parser.py:1081](../src/parser.py#L1081) | error | `"expected identifier"` |
| [parser.py:709](../src/parser.py#L709) | error | `"required parentheses"` |
| [parser.py:797](../src/parser.py#L797) | error | `"required parentheses"` |
| [parser.py:1691](../src/parser.py#L1691) | error | `"unexpected token1 '%s'" % tokstr` |
| [parser.py:2434](../src/parser.py#L2434) | error | `"unexpected token '%s'" % self.ctok()` |

### 4. Синтаксис: стиль и соглашения

Регистр первой буквы идентификатора, пропущенный `:`, недопустимый модификатор доступа.

| Где | Ур. | Сообщение |
|---|---|---|
| [parser.py:243](../src/parser.py#L243) | error | `"value identifier must start with a small letter; '%s' names a type" % s` |
| [parser.py:252](../src/parser.py#L252) | error | `"type identifier must start with a capital letter; '%s' names a value" % s` |
| [parser.py:2126](../src/parser.py#L2126) | warning | `"function signature should be preceded by ':' — write 'func %s: (...) -> ...'" % id['str']` |
| [parser.py:2179](../src/parser.py#L2179) | warning | `"missing ':' before type"` |
| [parser.py:2442](../src/parser.py#L2442) | error | `"%s cannot have any access level modifier" % x['kind']` |

### 5. Неизвестное имя (undefined / unknown / not found)

Имя типа, значения, поля, модуля, аннотации, прагмы не найдено.

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:556](../src/semantic.py#L556) | error | `"undefined type"` |
| [semantic.py:533](../src/semantic.py#L533) | error | `"undefined type2"` |
| [semantic.py:527](../src/semantic.py#L527) | error | `"unknown namespace"` |
| [semantic.py:521](../src/semantic.py#L521) | error | `"module '%s' not found" % left_id_str` |
| [semantic.py:3083](../src/semantic.py#L3083) | error | `"module %s not found" % impline` |
| [semantic.py:1867](../src/semantic.py#L1867) | error | `"undefined value '%s'" % id_str` |
| [semantic.py:1789](../src/semantic.py#L1789) | error | `"unknown value"` |
| [semantic.py:1819](../src/semantic.py#L1819) | error | `"undefined field '%s'" % field_id['str']` |
| [hlir/types.py:2533](../src/hlir/types.py#L2533) | error | `"undefined field '%s'" % field_id.str` |
| [semantic.py:1439](../src/semantic.py#L1439) | error | `"unknown argument '%s'" % a['key']['str']` |
| [semantic.py:1474](../src/semantic.py#L1474) | error | `"unspecified parameter '%s'" % p_id_str` |
| [semantic.py:793](../src/semantic.py#L793) | error | `"annotation '%s' not defined\n" % a['kind']` |
| [semantic.py:2497](../src/semantic.py#L2497) | error | `"annotation '%s' not defined2\n" % a['kind']` |
| [semantic.py:3478](../src/semantic.py#L3478) | error | `"annotation '%s' not defined\n" % a['kind']` |
| [semantic.py:3208](../src/semantic.py#L3208) | error | `"unknown pragma '%s'" % id` |
| [semantic.py:2174](../src/semantic.py#L2174) | error | `"unknown value kind '%s'" % k` |

### 6. Повторное определение

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:2190](../src/semantic.py#L2190) | error | `"redefinition of '%s'" % x['id']['str']` |
| [semantic.py:2216](../src/semantic.py#L2216) | error | `"redefinition of '%s'" % x['id']['str']` |
| [semantic.py:2846](../src/semantic.py#L2846) | error | `"redefinition of '%s'" % x['id']['str']` |
| [semantic.py:2869](../src/semantic.py#L2869) | error | `"redefinition of '%s'" % x['id']['str']` |
| [semantic.py:3366](../src/semantic.py#L3366) | error | `"redefinition of '%s'" % x['id']['str']` |
| [semantic.py:3367](../src/semantic.py#L3367) | info | `"previous definition was here"` |
| [semantic.py:2630](../src/semantic.py#L2630) | error | `"type redefinition"` |
| [semantic.py:650](../src/semantic.py#L650) | error | `"redefinition of '%s' field" % field_id_str` |

### 7. Доступ и видимость (private/public)

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:536](../src/semantic.py#L536) | error | `"access to private type"` |
| [semantic.py:1792](../src/semantic.py#L1792) | error | `` "access to private value `%s.%s`" % (left['str'], x['right']['str']) `` |
| [semantic.py:1830](../src/semantic.py#L1830) | error | `"access to private field of record"` |
| [semantic.py:2577](../src/semantic.py#L2577) | error | `"using a private type in a public context"` |
| [semantic.py:2744](../src/semantic.py#L2744) | error | `"using a private type in a public context"` |
| [semantic.py:2792](../src/semantic.py#L2792) | error | `"using a private type in a public context"` |
| [semantic.py:2742](../src/semantic.py#L2742) | error | `"public constant must have a non-generic type"` |
| [semantic.py:2790](../src/semantic.py#L2790) | error | `"public variables are forbidden"` |
| [semantic.py:515](../src/semantic.py#L515) | error | `"via import is forbidden"` |

### 8. Несоответствие типов операндов / присваивания

Два значения разных типов там, где нужен один.

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:904](../src/semantic.py#L904) | error | `"different types '%s' & '%s' in operation" % (l.type.to_str(), r.type.to_str())` |
| [semantic.py:927](../src/semantic.py#L927) | error | `"cannot implicitly cons to common type '%s' & '%s'" % (l.type.to_str(), r.type.to_str())` |
| [semantic.py:889](../src/semantic.py#L889) | error | `"cannot concat arrays"` |
| [semantic.py:2662](../src/semantic.py#L2662) | error | `"type mismatch %s & %s" % (var_type.to_str(), init_value.type.to_str())` |
| [hlir/types.py:1422](../src/hlir/types.py#L1422) | info | `` "cannot select common type (`%s` & `%s`)" % (a.to_str(), b.to_str()) `` |
| [value/cons.py:142](../src/value/cons.py#L142) | error | `"type error2"` |

### 9. Ожидалась другая категория типа

Значение есть, но его тип не той «породы»: нужен указатель, массив, запись, функция, целое, Bool, Word, строка и т.п.

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:2543](../src/semantic.py#L2543) | error | `"expected type expr"` |
| [semantic.py:919](../src/semantic.py#L919) | error | `"unsuitable value type '%s' for '%s' operation" % (l.type.to_str(), op)` |
| [semantic.py:923](../src/semantic.py#L923) | error | `"unsuitable value type '%s' for '%s' operation" % (r.type.to_str(), op)` |
| [semantic.py:1050](../src/semantic.py#L1050) | error | `"unsuitable value type '%s' for '%s' operation" % (v.type.to_str(), op)` |
| [semantic.py:809](../src/semantic.py#L809) | error | `"expected word value"` |
| [semantic.py:813](../src/semantic.py#L813) | error | `"expected natural or non-negative integer value"` |
| [semantic.py:1093](../src/semantic.py#L1093) | error | `"expected non-negative integer value"` |
| [semantic.py:1134](../src/semantic.py#L1134) | error | `"expected value with signed type"` |
| [semantic.py:1176](../src/semantic.py#L1176) | error | `"expected value with signed type"` |
| [semantic.py:1571](../src/semantic.py#L1571) | error | `"expected integral value"` |
| [semantic.py:1581](../src/semantic.py#L1581) | error | `"expected value with Bool type"` |
| [semantic.py:2375](../src/semantic.py#L2375) | error | `"expected value with integer type"` |
| [semantic.py:1260](../src/semantic.py#L1260) | error | `"expected pointer value"` |
| [semantic.py:1273](../src/semantic.py#L1273) | error | `"cannot dereference the pointer"` |
| [semantic.py:1291](../src/semantic.py#L1291) | error | `"expected value with array type"` |
| [semantic.py:1308](../src/semantic.py#L1308) | error | `"expected array type"` |
| [semantic.py:1388](../src/semantic.py#L1388) | error | `"expected function or pointer to function"` |
| [semantic.py:1640](../src/semantic.py#L1640) | error | `"expected array, pointer to array, or string"` |
| [semantic.py:1717](../src/semantic.py#L1717) | error | `"expected array or pointer to array"` |
| [semantic.py:1812](../src/semantic.py#L1812) | error | `"expected record or pointer to record"` |
| [semantic.py:2082](../src/semantic.py#L2082) | error | `"expected string value"` |
| [semantic.py:2920](../src/semantic.py#L2920) | error | `"expected a function type"` |
| [semantic.py:1241](../src/semantic.py#L1241) | error | `"operation new requires value with aggregate type"` |
| [value/array.py:38](../src/value/array.py#L38) | error | `"value with unsuitable type"` |

### 10. Тип запрещён в этой позиции

Тип допустим вообще, но не как поле / параметр / результат / константа / переменная / аргумент sizeof.

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:470](../src/semantic.py#L470) | error | `"unsuitable type"` |
| [semantic.py:2738](../src/semantic.py#L2738) | error | `"unsuitable type"` |
| [semantic.py:2795](../src/semantic.py#L2795) | error | `"unsuitable type"` |
| [semantic.py:693](../src/semantic.py#L693) | error | `"forbidden param type"` |
| [semantic.py:703](../src/semantic.py#L703) | error | `"forbidden retval type"` |
| [semantic.py:621](../src/semantic.py#L621) | error | `"non local VLA are forbidden"` |
| [semantic.py:2022](../src/semantic.py#L2022) | error | `"sizeof(<#type_function#>) are forbidden"` |
| [semantic.py:2029](../src/semantic.py#L2029) | error | `"sizeof(<#value_function#>) are forbidden"` |
| [semantic.py:571](../src/semantic.py#L571) | error | `"unsupported layout"` |
| [semantic.py:2802](../src/semantic.py#L2802) | error | `"variable of unsized array type requires an initializer"` |

### 11. Неполные типы и рекурсивные зависимости

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:473](../src/semantic.py#L473) | error | `"using of an incompleted type"` |
| [semantic.py:608](../src/semantic.py#L608) | error | `"using of an incompleted type"` |
| [semantic.py:700](../src/semantic.py#L700) | error | `"using of an incompleted type"` |
| [semantic.py:1894](../src/semantic.py#L1894) | error | `"use of incomplete value"` |
| [semantic.py:2614](../src/semantic.py#L2614) | error | `"is_incompleted"` |
| [semantic.py:2610](../src/semantic.py#L2610) | error | `"rec dep!"` |
| [value/cons.py:71](../src/value/cons.py#L71) | error | `"cannot construct value of incompleted type"` |

### 12. Конструирование значения (value cons)

Нельзя построить значение типа T из значения типа U — явно или неявно.

| Где | Ур. | Сообщение |
|---|---|---|
| [value/cons.py:150](../src/value/cons.py#L150) | error | `` "cannot implicitly construct `%s` from `%s`\n" % (t.to_str(), v.type.to_str()) `` |
| [value/cons.py:177](../src/value/cons.py#L177) | error | `"cannot construct '%s' from '%s' value" % (t.to_str(), from_type.to_str())` |
| [value/char.py:49](../src/value/char.py#L49) | error | `"cannot construct %s value from String with length != 1" % t.to_str()` |
| [value/char.py:56](../src/value/char.py#L56) | error | `"cannot construct %s value from String" % t.to_str()` |
| [value/cons.py:197](../src/value/cons.py#L197) | error | `"cannot select default type for value with generic type"` |
| [value/int.py:68](../src/value/int.py#L68) | info | `` "attempt to construct `%s` from `%s`" % (t.to_str(), v.type.to_str()) `` |
| [value/nat.py:63](../src/value/nat.py#L63) | info | `` "attempt to construct `%s` from `%s`" % (t.to_str(), v.type.to_str()) `` |
| [value/pointer.py:18](../src/value/pointer.py#L18) | info | `"Cannot cons pointer!! from %s to %s" % (from_type, to)` |
| [value/cons.py:74](../src/value/cons.py#L74) | info | `str(to)` |
| [value/cons.py:173](../src/value/cons.py#L173) | info | `"explicit cons from the same type"` |

### 13. Переполнение и арифметика констант

Значение не влезает в целевой тип при вычислении на этапе компиляции; деление на ноль.

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:975](../src/semantic.py#L975) | error | `"fixed point overflow" if t.is_fixed() else "integer overflow"` |
| [value/int.py:67](../src/value/int.py#L67) | error | `"integer overflow"` |
| [value/nat.py:62](../src/value/nat.py#L62) | error | `"integer overflow"` |
| [value/word.py:60](../src/value/word.py#L60) | error | `"word overflow"` |
| [value/word.py:63](../src/value/word.py#L63) | error | `"word overflow"` |
| [value/fixed.py:94](../src/value/fixed.py#L94) | error | `"fixed point (%d.%d) overflow" % (t.width - t.fraction, t.fraction)` |
| [semantic.py:968](../src/semantic.py#L968) | error | `"float overflow"` |
| [value/float.py:56](../src/value/float.py#L56) | error | `"float overflow"` |
| [semantic.py:969](../src/semantic.py#L969) | info | `` "`%s` holds at most %s" % (t.to_str(), str_fractional(float_max(t.width), 64)) `` |
| [value/float.py:57](../src/value/float.py#L57) | info | `` "`%s` holds at most %s" % (t.to_str(), str_fractional(float_max(t.width), 64)) `` |
| [semantic.py:944](../src/semantic.py#L944) | error | `"division by zero"` |
| [semantic.py:1016](../src/semantic.py#L1016) | error | `"division by zero"` |

### 14. Индексы, срезы, границы

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:1611](../src/semantic.py#L1611) | error | `"array index must be non-negative"` |
| [semantic.py:1623](../src/semantic.py#L1623) | error | `"string index out of bounds"` |
| [semantic.py:1657](../src/semantic.py#L1657) | error | `"array index out of bounds"` |
| [semantic.py:1737](../src/semantic.py#L1737) | error | `"slice index must be non-negative"` |
| [semantic.py:1742](../src/semantic.py#L1742) | error | `"empty slice"` |
| [semantic.py:1745](../src/semantic.py#L1745) | error | `"wrong slice direction"` |
| [semantic.py:1753](../src/semantic.py#L1753) | error | `"slice index out of bounds"` |
| [semantic.py:1756](../src/semantic.py#L1756) | error | `"slice index out of bounds"` |
| [semantic.py:1646](../src/semantic.py#L1646) | error | `"cannot index an array of unsized array"` |
| [semantic.py:1724](../src/semantic.py#L1724) | error | `"cannot slice array of an unsized array"` |

### 15. Требуется значение времени компиляции

Операция возможна только с immediate-значением (литерал/константа).

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:820](../src/semantic.py#L820) | error | `"a literal can only be shifted by a compile-time count"` |
| [semantic.py:821](../src/semantic.py#L821) | info | `` "give the literal a type first, e.g. `Word32 0x01 << n`" `` |
| [semantic.py:1616](../src/semantic.py#L1616) | error | `"cannot index string in runtime"` |
| [semantic.py:1650](../src/semantic.py#L1650) | error | `"cannot index array with generic type in runtime"` |
| [semantic.py:2069](../src/semantic.py#L2069) | error | `"expected immediate value2"` |
| [semantic.py:2857](../src/semantic.py#L2857) | error | `"expected immediate value"` |
| [semantic.py:3203](../src/semantic.py#L3203) | error | `"expected string literal"` |
| [backend/llvm.py:1368](../src/backend/llvm.py#L1368) | error | `"expected immediate index value"` |

### 16. Изменяемость, lvalue, инициализация

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:2329](../src/semantic.py#L2329) | error | `"expected lvalue"` |
| [semantic.py:2333](../src/semantic.py#L2333) | error | `"expected mutable value"` |
| [semantic.py:2371](../src/semantic.py#L2371) | error | `"expected mutable value"` |
| [semantic.py:1222](../src/semantic.py#L1222) | error | `"expected mutable value or function"` |
| [semantic.py:2113](../src/semantic.py#L2113) | error | `"attempt to use an uninitialized value"` |

### 17. Вызов функции: аргументы и параметры

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:1398](../src/semantic.py#L1398) | error | `"too many arguments"` |
| [semantic.py:1481](../src/semantic.py#L1481) | error | `"not enough arguments"` |
| [semantic.py:1459](../src/semantic.py#L1459) | error | `"positional argument follows keyword argument"` |
| [semantic.py:1439](../src/semantic.py#L1439) | error | `"unknown argument '%s'" % a['key']['str']` |
| [semantic.py:1474](../src/semantic.py#L1474) | error | `"unspecified parameter '%s'" % p_id_str` |
| [semantic.py:1503](../src/semantic.py#L1503) | warning | `"extra argument with generic type"` |
| [semantic.py:1540](../src/semantic.py#L1540) | warning | `"compile time call not implemented, will returned zero value!"` |

### 18. Возврат из функции

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:2282](../src/semantic.py#L2282) | error | `"expected return value"` |
| [semantic.py:3001](../src/semantic.py#L3001) | warning | `"expected return operator at end"` |

### 19. Импорт и модули

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:515](../src/semantic.py#L515) | error | `"via import is forbidden"` |
| [semantic.py:521](../src/semantic.py#L521) | error | `"module '%s' not found" % left_id_str` |
| [semantic.py:3083](../src/semantic.py#L3083) | error | `"module %s not found" % impline` |
| [semantic.py:3098](../src/semantic.py#L3098) | error | `"recursive import detected"` |
| [semantic.py:3104](../src/semantic.py#L3104) | fatal | `"recursive import detected '%s'" % abspath` |
| [semantic.py:3121](../src/semantic.py#L3121) | fatal | `"cannot import module"` |
| [semantic.py:3306](../src/semantic.py#L3306) | warning | `"unised import"` |

### 20. Предупреждения о качестве кода

Не ошибки: устаревшее, неиспользуемое.

| Где | Ур. | Сообщение |
|---|---|---|
| [semantic.py:564](../src/semantic.py#L564) | warning | `"using a deprecated type"` |
| [semantic.py:1888](../src/semantic.py#L1888) | warning | `"using a deprecated value"` |
| [semantic.py:3030](../src/semantic.py#L3030) | info | `"value '%s' defined but not used" % id_str` |
| [semantic.py:3306](../src/semantic.py#L3306) | warning | `"unised import"` |

### 21. Внутренние ошибки компилятора / не реализовано

Пользователь не должен их видеть; по сути это assert-ы.

| Где | Ур. | Сообщение |
|---|---|---|
| [backend/c11.py:647](../src/backend/c11.py#L647) | error | `"str_value_literal not implemented for %s" % str(t)` |
| [backend/c11.py:1594](../src/backend/c11.py#L1594) | error | `"value undef in C backend"` |
| [backend/c11.py:1597](../src/backend/c11.py#L1597) | error | `"value bad in C backend"` |
| [backend/c11.py:2640](../src/backend/c11.py#L2640) | error | `"attempt to load non aggregate"` |
| [backend/llvm.py:220](../src/backend/llvm.py#L220) | error | `"undefined value in llvm backend"` |
| [backend/llvm.py:586](../src/backend/llvm.py#L586) | info | `"<llvm::unknown_value_kind '%s'>" % k` |
| [backend/llvm.py:1984](../src/backend/llvm.py#L1984) | info | `"do_eval_string??"` |
| [backend/llvm.py:2121](../src/backend/llvm.py#L2121) | error | `"do_eval_literal: unknown literal"` |
| [backend/llvm.py:2253](../src/backend/llvm.py#L2253) | error | `"llvm do_eval cannot eval (%s) value" % 'k'` |
| [hlir/types.py:2075](../src/hlir/types.py#L2075) | info | `msg` |
| [semantic.py:3531](../src/semantic.py#L3531) | fatal | `"Object %s has not attribute %s" % (str(x), step)` |
| [semantic.py:3541](../src/semantic.py#L3541) | fatal | `"Object %s has not attribute %s" % (str(x), step)` |
| [semantic.py:1540](../src/semantic.py#L1540) | warning | `"compile time call not implemented, will returned zero value!"` |

