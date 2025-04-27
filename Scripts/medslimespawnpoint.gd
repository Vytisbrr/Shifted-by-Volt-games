extends Marker2D
@export var medslime: PackedScene
@onready var medslimedelay = $"../medslimedelay"
var canspawn = true
func _process(delta):
	spawnmediumslime()
func spawnmediumslime():
	if canspawn == true:
		var slime_instance = medslime.instantiate()
		slime_instance.global_transform = global_transform
		get_parent().add_child(slime_instance)
		canspawn = false
		medslimedelay.start()
func _on_medslimedelay_timeout() -> void:
	canspawn = true
