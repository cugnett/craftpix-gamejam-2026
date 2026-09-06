extends TextureButton

enum stat_type {
	POWER,
	SPEED,
	COOLDOWN,
}

@onready var rng = RandomNumberGenerator.new()

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
			upgrade_multiplier = snapped(base_upgrade_multiplier * 2 + 1, 0.1)
		1:
			stat_upgraded = "Cooldown"
			upgrade_multiplier = snapped(base_upgrade_multiplier / 8, 0.1) + 0.1
		2:
			stat_upgraded = "Speed"
			upgrade_multiplier = snapped(base_upgrade_multiplier * 10 + 10, 0.1)
	
