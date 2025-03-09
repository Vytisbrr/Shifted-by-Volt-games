extends CharacterBody2D

@export var SPEED = 60
@export var gravity = 20
var direction = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft


@onready var ap =  $AnimationPlayer
@onready var area = $enemyarea

func _physics_process(delta):
	move_and_slide()
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 3000:
			velocity.y = 3000
	if is_on_floor():
		velocity.x += direction * SPEED
	var slime = $Sprite2D
	updateanimations(slime)
	if ray_cast_right.is_colliding():
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1
func updateanimations(slime):
	ap.play("idle")
	
