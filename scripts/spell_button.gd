extends TextureButton


var spell_name: String = "Explosion"

signal selected_spell



func _on_button_up() -> void:
	selected_spell.emit(spell_name)
	print("Click")
