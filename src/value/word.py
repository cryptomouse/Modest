
from hlir import *
from error import info, warning, error
from bits import nbits_for_num, int_zext
from real import float_to_bits



def value_word_create(num, ti=None):
	required_width = nbits_for_num(num)
	t = type_word_create(required_width, ti=ti)
	t.generic = True
	v = ValueLiteral(t, asset=num, ti=ti)
	return v


def value_word_can(to, from_type, method, ti):
	# Неявно литерал входит в WordX, только если его ширина - у hex-литерала
	# ширина записи - не больше: 0x000F в Word8 не входит. Явная конструкция
	# `Word8 0x000F` смотрит на само значение (value_word_cons)
	if from_type.is_integer():
		return method != 'implicit' or from_type.width <= to.width

	if from_type.is_generic_word():
		return from_type.width <= to.width

	if method == 'implicit':
		return False

	# WordX - это мешок бит, а не число: у него нет ни арифметики, ни
	# порядка (docs/lang/value/binary.md).  Взять его младшие X бит -
	# не потеря значения, а сама операция, и явная конструкция её и
	# выражает; unsafe тут нечего охранять.  IntX/NatX - другое дело:
	# там усечение врёт о числе, и они остаются как были.
	if from_type.is_word():
		return True

	c0 = from_type.is_integer()
	c2 = from_type.is_int()
	c3 = from_type.is_char()
	c4 = from_type.is_bool()
	c5 = from_type.is_pointer()
	c6 = from_type.is_float()
	c7 = from_type.is_nat()
	c8 = from_type.is_fixed()

	if c0 or c2 or c3 or c4 or c5 or c6 or c7 or c8:
		if from_type.width <= to.width:
			return True
		return method == 'unsafe'

	return False


def value_word_cons(t, v, method, ti):
	nv = ValueCons(t, t, v, method, ti=ti)
	if v.is_immediate():
		if method == 'implicit':
			if v.type.width > t.width:
				error("word overflow", ti)
		elif method == 'explicit' and v.type.is_integer():
			if nbits_for_num(v.asset) > t.width:
				error("word overflow", ti)

		nv.stage = HLIR_VALUE_STAGE_COMPILETIME
		if v.type.is_float():
			# биты, а не число: кодировка IEEE 754 во всю ширину FloatY,
			# а дальше, как у WordY -> WordX, zext или усечение
			nv.set_asset(float_to_bits(v.asset, v.type.width) & (2**t.width - 1))
			return nv
		nv.set_asset(v.asset)
		if v.type.is_signed():
			nv.set_asset(int_zext(v.asset, v.type.width, t.width))
		return nv

	nv.stage = HLIR_VALUE_STAGE_RUNTIME
	return nv


