class_name slimehurtbox
extends Area2D


func _init() -> void:
	collision_layer = 0
	collision_mask = 2


func _ready() -> void:
	self.area_entered.connect(_on_area_entered)

func _on_area_entered(hitbox: swordhitbox) -> void:
	if hitbox == null:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
