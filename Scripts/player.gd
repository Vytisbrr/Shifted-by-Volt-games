extends CharacterBody2D

signal healthChanged
@onready var hptext = $Label
@onready var Hppickups = 0
@export var normalspeed = 1000
@export var gravity = 35
@export var jump_force = 900
@onready var deathtimer = $Deathtimer
@export var maxHealth = 10
@onready var currentHealth: int = maxHealth
@onready var HeartContainer = $CanvasLayer/Hearts
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var coyote_timer = $coyotetimer
@onready var Jumpbuffertimer = $Jumpbuffertimer
@onready var swordhitboxdefault = $Swordhitboxdefault
@onready var attacktimetimer = $attacktimetimer
@export var dashspeed = 6000
var can_coyote_jump = false
var jump_buffered = false
var isdashing = false
@onready var dashtimer = $dashtimer
@onready var dashcooldowntimer = $Dashcooldowntimer
@onready var falldmg: RayCast2D = $Falldmg
var dashcoolingdown = false
var isattacking = false
var was_grounded = true
var fall_speed_threshold = 1800
func _physics_process(delta):
	displayhppickups()
	if Input.is_action_just_pressed("Dash") && isdashing == false && dashcoolingdown == false:
		dashtimer.start()
		isdashing = true
		dashcoolingdown = true
		dashcooldowntimer.start()
	var speed = dashspeed if isdashing == true else normalspeed
	var was_on_floor = is_on_floor()
	if !is_on_floor() && (can_coyote_jump == false):
		velocity.y += gravity
		if velocity.y > 4500:
			velocity.y = 4500
	if Input.is_action_just_pressed("jump"):
		jump()
	if Input.is_action_just_pressed("attack"):
		isattacking = true
		ap.play("Sword swing")
		attacktimetimer.start()
	if Input.is_action_just_pressed("attack") && !isattacking:
		isattacking = true
		ap.play("Sword swing")
		attacktimetimer.start()
	var horizontal_direction = Input.get_axis("move left","move right")
	
	velocity.x = speed * horizontal_direction
	
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
	
	
	move_and_slide()
	if was_on_floor && !is_on_floor() && velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()
	#Touched ground
	if !was_on_floor && is_on_floor():
		if jump_buffered:
			jump_buffered = false
			jump()
	updateanimations(horizontal_direction)
func updateanimations(horizotal_direction):
	if is_on_floor() && isattacking == false:
		if horizotal_direction == 0 && velocity.y == 0:
			ap.play("idle")
		else:
			ap.play("walk")
	else:
		if velocity.y < 0 && isattacking == false:
			ap.play("Jump")
		elif velocity.y > 0 && isattacking == false:
			ap.play("falling")
func _on_coyotetimer_timeout():
	can_coyote_jump = false
	
func jump():
	if is_on_floor() || can_coyote_jump:
		velocity.y = -jump_force
		if can_coyote_jump:
			can_coyote_jump = false
	else:
		if !jump_buffered:
			jump_buffered = true
			Jumpbuffertimer.start()



func _on_hitbox_area_entered(area: Area2D):
	if area.name == "enemyarea":
		currentHealth -= 1
		if currentHealth <= 0:
			currentHealth = 0
			deathtimer.start()
			
			 
		healthChanged.emit(currentHealth)
func _ready():
	HeartContainer.setmaxHearts(maxHealth)
	HeartContainer.updateHearts(currentHealth)
	healthChanged.connect(HeartContainer.updateHearts)
	


func _on_deathtimer_timeout() -> void:
	print ("YOU DIED!")
	print ("EMOTIONAL DAAAAAAMAGE!!!!!!!!!!!!!!")
	get_tree().reload_current_scene()
	
func _on_jumpbuffertimer_timeout() -> void:
	jump_buffered = false
	


func _on_dashtimer_timeout():
	isdashing = false


func _on_dashcooldowntimer_timeout():
	dashcoolingdown = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Heal") && currentHealth != maxHealth && currentHealth > 0 && Hppickups > 0:
		currentHealth += 1
		Hppickups -= 1
		healthChanged.emit(currentHealth)


func _on_healthpickup_area_entered(area: Area2D):
	if area.name == "Healthpickup" && currentHealth < maxHealth && currentHealth > 0:
		currentHealth += 1
		healthChanged.emit(currentHealth)
	elif area.name == "Healthpickup" && currentHealth == maxHealth && currentHealth > 0:
		Hppickups += 1
		if Hppickups > 9:
			Hppickups = 9
func displayhppickups():
	hptext.text = str(Hppickups)
func _on_attacktimetimer_timeout():
	isattacking = false
