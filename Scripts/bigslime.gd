extends CharacterBody2D

@export var SPEED = 200
@export var gravity = 20
@export var hp = 10
var direction = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft


@onready var ap =  $AnimationPlayer
@onready var area = $bigslimearea
@onready var deathtimer = $deathtimer
@onready var raycastfall = $RayCastfall
var immunity = false
var dead = false
var was_on_floor = true
var was_not_on_floor = false
func _physics_process(delta):
	move_and_slide()
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 3000:
			velocity.y = 3000
	if is_on_floor():
		velocity.x = direction * SPEED
	var slime = $Sprite2D
	updateanimations(slime)
	if ray_cast_right.is_colliding():
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1
func updateanimations(slime):
	if dead == false:
		ap.play("idle")
func _on_hurtbox_area_entered(area: Area2D):
	if area.name == "Swordhitboxdefault":
		hp -= 1
		if hp <= 0:
			hp = 0
			dead = true
			ap.play("death")
			


func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "death":
		queue_free()
