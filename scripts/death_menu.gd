extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$OnReadySound.play()
	await get_tree().create_timer(3).timeout
	$Music.play()
	SignalManager.validate_sound_options.connect(_validate_sound)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_restart_button_pressed() -> void:
	GlobalWeapons.reset_weapons_stats()
	ChangeScene.change_scene(ChangeScene.game_scene)

func _on_restart_button_2_pressed() -> void:
	ChangeScene.change_scene(ChangeScene.game_scene)

func _on_options_button_pressed() -> void:
	$VBoxContainer.visible = false
	$OptionsMenu.visible = true


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_restart_button_mouse_entered() -> void:
	$ButtonSound.play()


func _on_options_button_mouse_entered() -> void:
	$ButtonSound.play()


func _on_exit_button_mouse_entered() -> void:
	$ButtonSound.play()
	
func _validate_sound() -> void:
	$VBoxContainer.visible = true
	$OptionsMenu.visible = false
