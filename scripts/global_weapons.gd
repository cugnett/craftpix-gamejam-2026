extends Node

var weapons: Dictionary = {
		"explosion": preload("res://ressources/explosion_weapon.tres"),
		"freeze": preload("res://ressources/freeze_weapon.tres"),
		"shield": preload("res://ressources/shield_weapon.tres"),
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func new_dict_weapons() -> Dictionary:
	return weapons

func reset_weapons_stats() -> void:
	for weapon in weapons.values():
		weapon.reset_values()
