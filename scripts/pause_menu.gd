extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false
	SignalManager.validate_sound_options.connect(_validate_sound)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		visible = true
		get_tree().paused = true
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		visible = false
		get_tree().paused = false



func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_options_button_pressed() -> void:
	$OptionsMenu.visible = true
	$VBoxContainer.visible = false


func _on_resume_button_mouse_entered() -> void:
	$ButtonSound.play()


func _on_options_button_mouse_entered() -> void:
	$ButtonSound.play()
	
func _validate_sound() -> void:
	$VBoxContainer.visible = true
	$OptionsMenu.visible = false
