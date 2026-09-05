extends Control

var weapon: WeaponRessource

@onready
var TextLabel: RichTextLabel = $TextLabel

func _ready() -> void:
	TextLabel.push_color(weapon.text_color)
	TextLabel.append_text(weapon.text)

func _process(_delta: float) -> void:
	pass
