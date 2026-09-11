extends Control


func _ready() -> void:
	$VBoxContainer/MasterHSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$VBoxContainer/MusicHSlider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$VBoxContainer/SfxHSlider.value = db_to_linear(AudioServer.get_bus_volume_db(2))


func _process(_delta: float) -> void:
	pass


func _on_master_h_slider_mouse_exited() -> void:
	release_focus()


func _on_music_h_slider_mouse_exited() -> void:
	release_focus()


func _on_sfx_h_slider_mouse_exited() -> void:
	release_focus()


func _on_master_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db($VBoxContainer/MasterHSlider.value))


func _on_music_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db($VBoxContainer/MusicHSlider.value))


func _on_sfx_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db($VBoxContainer/SfxHSlider.value))


func _on_sfx_h_slider_drag_ended(value_changed: bool) -> void:
	$"../ButtonSound".play()
