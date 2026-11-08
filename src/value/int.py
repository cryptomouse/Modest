
from hlir import *
from error import info, warning, error
from bits import nbits_for_num, int_zext
from .fixed import fixed_to_number
from real import float_special


# FixedX -> целое: снимаем масштаб с усечением к нулю,
# как обычное приведение дробного к целому (и как __fixedX_to_intX)
def fixed_to_int(v):
	return int(fixed_to_number(v.asset, v.type.fraction))



def is_fractional(t):
	return t.is_float() or t.is_fixed()



# FloatY/FixedY -> целое: дробь отбрасываем к нулю
def frac_to_int(v):
	return fixed_to_int(v) if v.type.is_fixed() else int(v.asset)



# Константа-NaN или бесконечность, из которой строят целое (BUG#120).
# Целого с таким значением нет ни в каком типе, а int() над ними в Python
# бросает исключение. Без unsafe это то же переполнение, что у Int8 300.0;
# под unsafe - тоже ошибка: значение известно уже сейчас, и осмысленного
# целого из него не получить, unsafe тут только спрятал бы мусор.
# Возвращает готовое (свернутое в 0) значение, если это такой случай, иначе None.
def frac_special_to_int(t, v, method, ti):
	if not (v.is_immediate() and v.type.is_float()):
		return None
	special = float_special(v.asset)
	if special is None:
		return None

	if method != 'unsafe':
		error("integer overflow", ti)
		info("attempt to construct `%s` from `%s`" % (t.to_str(), v.type.to_str()), ti)
	else:
		what = "NaN" if special == 'nan' else "infinity"
		error("cannot construct `%s` from %s" % (t.to_str(), what), ti)

	# дальше компиляция продолжается только ради остальных ошибок
	nv = ValueCons(t, t, v, method, ti=ti)
	nv.set_asset(0)
	nv.stage = HLIR_VALUE_STAGE_COMPILETIME
	return nv



def value_int_can(to, from_type, method, ti):
	# ширина записи hex-литерала держит только неявную конструкцию,
	# явная смотрит на значение (value_int_cons)
	if from_type.is_integer():
		return method != 'implicit' or from_type.width <= to.width

	if method == 'implicit':
		return False

	# explicit or unsafe cons method

	# ширина дробного источника ничего не говорит о том, влезет ли
	# значение: Float64 с 3.0 влезет в Int8, а с 1e300 - никуда.
	# Константу проверит value_int_cons, рантайм - UB#3
	if from_type.is_float() or from_type.is_fixed():
		return True

	c0 = from_type.is_integer()
	c1 = from_type.is_int()
	c2 = from_type.is_nat()
	c3 = from_type.is_word()
	c4 = from_type.is_float()
	c5 = from_type.is_fixed()
	c6 = from_type.is_rational()

	if c0 or c1 or c2 or c3 or c4 or c5 or c6:
		if method == 'unsafe':
			return True
		return to.width >= from_type.width

	if method != 'unsafe':
		return False

	if from_type.is_pointer():
		from common import settings
		return to.width >= int(settings['pointer_width'])

	return False



def value_int_cons(t, v, method, ti):
	#info("value_integer_cons()", ti)

	from_width = v.type.width
	to_width = t.width

	if method == 'explicit' and v.is_immediate() and v.type.is_integer():
		from_width = nbits_for_num(v.asset)

	special = frac_special_to_int(t, v, method, ti)
	if special is not None:
		return special

	if is_fractional(v.type):
		# FloatY/FixedY: проверяем значение, а не ширину - и только
		# известное. В рантайме не влезшее значение - UB#3
		from_width = 0
		if v.is_immediate():
			from_width = nbits_for_num(frac_to_int(v), signed=True)

	if method != 'unsafe':
		if from_width > to_width:
			error("integer overflow", ti)
			info("attempt to construct `%s` from `%s`" % (t.to_str(), v.type.to_str()), ti)

	nv = ValueCons(t, t, v, method, ti=ti)
	if v.is_immediate():
		a = frac_to_int(v) if is_fractional(v.type) else int(v.asset)
		nv.set_asset(a)
		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		return nv

	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv


