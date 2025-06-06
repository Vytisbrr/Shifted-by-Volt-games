extends CharacterBody2D

signal healthChanged
@onready var coffin = $coffin
@onready var heart = $heart
@onready var hptext = $Label
@onready var Hppickups = 0
@export var normalspeed = 1000
@export var gravity = 35
@export var jump_force = 900
@onready var deathtimer = $Deathtimer
@export var maxHealth = 100
@onready var currentHealth: int = maxHealth
@onready var ap = $AnimationPlayer
@onready var sprite = $wrigg
@onready var coyote_timer = $coyotetimer
@onready var Jumpbuffertimer = $Jumpbuffertimer
@onready var swordhitboxdefault = $wrigg/Swordhitboxdefault
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
var bouncing = false
var has_sword = false
var showswordpickup = false
@onready var defaultsword = $Defaultsword
@onready var swordpickuptimer = $swordpickuptimer
@onready var camera: Camera2D = get_tree().get_first_node_in_group("camera")
func _physics_process(delta):
	if currentHealth > 0:
		heart.show()
		coffin.hide()
	else:
		heart.hide()
		coffin.show()
	if showswordpickup == false:
		defaultsword.visible = false
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
	if Input.is_action_just_pressed("attack") && !isattacking && has_sword:
		isattacking = true
		ap.play("Sword swing")
	var horizontal_direction = Input.get_axis("move left","move right")
	velocity.x = speed * horizontal_direction
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
	if horizontal_direction == -1:
		swordhitboxdefault.scale.x = -1.616
		swordhitboxdefault.position.x = -54.646
	if horizontal_direction == 1:
		swordhitboxdefault.scale.x = 1.616
		swordhitboxdefault.position.x = -24.646
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
	if area.name == "bigslimearea":
		currentHealth -= 3
		camera.trigger_shake(20, 15)
		framefreeze(0.05, 1)
		if currentHealth <= 0:
			currentHealth = 0
			deathtimer.start()
			
			 
		healthChanged.emit(currentHealth)



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
		currentHealth += 30
		if currentHealth > maxHealth:
			currentHealth = maxHealth
		Hppickups -= 1
		healthChanged.emit(currentHealth)


func _on_healthpickup_area_entered(area: Area2D):
	if area.name == "Healthpickup" && currentHealth > 0 && Isdisabledhppickup.isdisabled == false:
		Hppickups += 1
		if Hppickups > 9:
			Hppickups = 9
func displayhppickups():
	hptext.text = str(Hppickups)
func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "Sword swing":
		isattacking = false
func _on_playerhitbox_area_entered(area: Area2D):
	if area.name == "swordarea":
		has_sword = true
		showswordpickup = true
		defaultsword.visible = true
		swordpickuptimer.start()
func _on_swordpickuptimer_timeout():
	showswordpickup = false
	defaultsword.visible = false
	
func _on_swordhitboxdefault_area_entered(area: Area2D) -> void:
	if area.name == "Hurtbox":
		camera.trigger_shake(8, 10)
		framefreeze(0.10, 0.30)
		
func framefreeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1.0
func _on_playerhitbox_smslime_entered(area: Area2D):
		if area.name == "smallslimearea":
			currentHealth -= 5
			camera.trigger_shake(5, 5)
			framefreeze(0.10, 0.3)
			if currentHealth <= 0:
				currentHealth = 0
				deathtimer.start()
			
			 
			healthChanged.emit(currentHealth)


func _on_playerhitbox_medslime_entered(area: Area2D) -> void:
		if area.name == "medslimearea":
			currentHealth -= 15
			camera.trigger_shake(10, 110)
			framefreeze(0.07, 0.5)
			if currentHealth <= 0:
				currentHealth = 0
				deathtimer.start()
			
			 
			healthChanged.emit(currentHealth)
