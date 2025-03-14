extends HBoxContainer

@onready var HeartUiClass = preload("res://ui/heart_ui.tscn")
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func setmaxHearts(max: int):
	for i in range(max):
		var heart = HeartUiClass.instantiate()
		add_child(heart)
func updateHearts(currentHealth: int):
	var hearts = get_children()
	
	for i in range(currentHealth):
		hearts[i].update(true)
	
	for i in range(currentHealth, hearts.size()):
		hearts[i].update(false)
