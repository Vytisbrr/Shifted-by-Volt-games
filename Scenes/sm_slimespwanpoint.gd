extends Marker2D
@export var smslime: PackedScene
@onready var smslimedelay = $"../smslimedelay"
var canspawn = true
func _process(delta):
	spawnsmallslime()
func spawnsmallslime():
	if canspawn == true:
		var slime_instance = smslime.instantiate()
		slime_instance.global_transform = global_transform
		get_parent().add_child(slime_instance)
		canspawn = false
		smslimedelay.start()
func _on_smslimedelay_timeout():
	canspawn = true
