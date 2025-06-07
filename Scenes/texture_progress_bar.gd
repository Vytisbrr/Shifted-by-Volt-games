extends TextureProgressBar
@onready var player = get_parent()
@onready var dmgbartimer = $"../dmgtimer"
@onready var dmgbar = $"../dmgbar"
var dmgbaract = false
func _on_value_changed(value: float):
	dmgbaract = true
	if dmgbaract == true:
		dmgbar.value = dmgbar.value
	dmgbartimer.start()
func _process(delta):
	var flashhealth = player.currentHealth
	max_value = player.maxHealth
	value = player.currentHealth
	value_changed
	dmgbar.max_value = player.maxHealth
	if dmgbaract == false:
		dmgbar.value = player.currentHealth

func _on_dmgtimer_timeout():
	dmgbaract = false


	
