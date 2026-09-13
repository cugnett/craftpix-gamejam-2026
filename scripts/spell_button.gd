extends TextureButton

enum stat_type {
	POWER,
	SPEED,
	COOLDOWN,
}

@onready var rng = RandomNumberGenerator.new()
@onready var hover_sound: AudioStreamPlayer = $HoverSound

var spell_name: String
var stat_upgraded: String
var upgrade_multiplier: float

signal selected_spell

func randomize_upgrade():
	var base_upgrade_multiplier = rng.randf()
	var randi_stat_upgraded = 0
	if spell_name == "Shield":
		randi_stat_upgraded = rng.randi_range(0, 1)
	else:
		randi_stat_upgraded = rng.randi_range(0, 2)
	
	match randi_stat_upgraded:
		0:
			stat_upgraded = "Power"
			match spell_name:
				"Explosion":
					upgrade_multiplier = snapped(base_upgrade_multiplier + 0.5, 0.1)
				"Freeze":
					upgrade_multiplier = snapped(base_upgrade_multiplier / 3 + 0.1, 0.1)
				"Shield":
					upgrade_multiplier = snapped(base_upgrade_multiplier + 1, 0.1)
		1:
			stat_upgraded = "Cooldown"
			match spell_name:
				"Explosion":
					if get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Player").weapons["explosion"].cooldown == 0.0:
						upgrade_multiplier = 0.0
					else:
						upgrade_multiplier = snapped(base_upgrade_multiplier / 10 + 0.1, 0.1) 
				"Freeze":
					if get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Player").weapons["freeze"].cooldown == 0.0:
						upgrade_multiplier = 0.0
					else:
						upgrade_multiplier = snapped(base_upgrade_multiplier / 10 + 0.1, 0.1) 
				"Shield":
					if get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Player").weapons["shield"].cooldown == 0.0:
						upgrade_multiplier = 0.0
					else:
						upgrade_multiplier = snapped(base_upgrade_multiplier / 8 + 0.6, 0.1) 
		2:
			stat_upgraded = "Speed"
			match spell_name:
				"Explosion":
					upgrade_multiplier = snapped(base_upgrade_multiplier * 10 + 10, 0.1)
				"Freeze":
					upgrade_multiplier = snapped(base_upgrade_multiplier * 10 + 10, 0.1)
	


func _on_mouse_entered() -> void:
	hover_sound.play()
