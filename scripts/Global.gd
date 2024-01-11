extends Node

var octave = 0
var w
var h

func remap_to_limits(desired_curve):
	var mmin = desired_curve.min()
	var mmax = desired_curve.max()
	if mmin < 0 or mmax > Global.h:
		for x in Global.w:
			desired_curve[x] = remap(desired_curve[x], mmin, mmax, max(0, mmin), min(Global.h, mmax))
	return desired_curve
