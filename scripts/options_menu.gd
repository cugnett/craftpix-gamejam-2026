extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_confirm_button_pressed() -> void:
	SignalManager.validate_sound_options.emit()


func _on_confirm_button_mouse_entered() -> void:
	$ButtonSound.play()
