extends Control

var pausemenuatstartfixed = false

func resume():
	get_tree().paused = false
	hide()
	
func pause():
	get_tree().paused = true
	show()
func didgamejuststart():
	if pausemenuatstartfixed == false:
		pausemenuatstartfixed = true
		get_tree().paused = false
		hide()

func testEsc():
	if Input.is_action_just_pressed("esc") && get_tree().paused == false:
		get_tree().paused = true
		pause()
	elif Input.is_action_just_pressed("esc") && get_tree().paused == true:
		get_tree().paused = false
		resume()

func _on_resume_pressed() -> void:
	resume()
	
func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
func _on_quit_pressed() -> void:
	get_tree().quit()
func _process(delta: float):
	didgamejuststart()
	testEsc()
