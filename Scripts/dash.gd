extends Node2D

@onready var dashtimer = $dashtimer

func startdash(dur):
	dashtimer.wait_time = dur
	dashtimer.start()
	
func is_dashing():
	return !dashtimer.is_stopped()
