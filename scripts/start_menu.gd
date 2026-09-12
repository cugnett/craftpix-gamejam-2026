extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Music.play(90.0)
	SignalManager.validate_sound_options.connect(_validate_sound)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_button_mouse_entered() -> void:
	$ButtonSound.play()


func _on_options_button_mouse_entered() -> void:
	$ButtonSound.play()


func _on_exit_button_mouse_entered() -> void:
	$ButtonSound.play()
	
func _validate_sound() -> void:
	$VBoxContainer.visible = true
	$OptionsMenu.visible = false


func _on_exit_button_button_up() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	ChangeScene.change_scene(ChangeScene.intro_scene)


func _on_options_button_pressed() -> void:
	$VBoxContainer.visible = false
	$OptionsMenu.visible = true
