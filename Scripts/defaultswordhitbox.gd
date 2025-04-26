class_name swordhitbox
extends Area2D


@export var damage := 2

func _init() -> void:
	collision_layer = 2
	collision_mask = 0
