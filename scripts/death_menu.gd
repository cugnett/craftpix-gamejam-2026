extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$OnReadySound.play()
	await get_tree().create_timer(3).timeout
	$Music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_restart_button_pressed() -> void:
	ChangeScene.change_scene(ChangeScene.game_scene)


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_restart_button_mouse_entered() -> void:
	$ButtonSound.play()


func _on_options_button_mouse_entered() -> void:
	$ButtonSound.play()


func _on_exit_button_mouse_entered() -> void:
	$ButtonSound.play()
