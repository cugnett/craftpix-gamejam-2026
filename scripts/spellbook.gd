extends Node2D

@onready var right_zone: PanelContainer = $SpellBookSprite/RightZone
@onready var upgrade_stats: Label = $SpellBookSprite/RightZone/UpgradeStats
@onready var spell_button: TextureButton = $SpellBookSprite/LeftZone/GridContainer/SpellButton
@onready var spell_button_2: TextureButton = $SpellBookSprite/LeftZone/GridContainer/SpellButton2
@onready var spell_button_3: TextureButton = $SpellBookSprite/LeftZone/GridContainer/SpellButton3
@onready var open_cose_sound: AudioStreamPlayer = $OpenCoseSound

@export var initial_position: Vector2 = Vector2(-304.0, 4.0)
@export var book_close_sfx: AudioStreamWAV
@export var book_open_sfx: AudioStreamWAV

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	right_zone.visible = false
	SignalManager.booksheet_collected.connect(_on_book_sheet_booksheet_collected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_book_sheet_booksheet_collected() -> void:
	get_parent().get_node("Player").can_move = false
	print("Collected!")
	#Set spell book position
	var player_position = get_parent().get_node("Player").player_map_position
	var camera_width = get_parent().get_node("Player").camera_width
	var camera_height = get_parent().get_node("Player").camera_height
	position = player_position * Vector2(camera_width,camera_height)
	position.x += camera_width/5
	position.y += camera_height/4.5
	
	#display spellbook
	$SpellBookSprite.get_node("LeftZone").visible = false
	visible = true
	open_cose_sound.stream = book_open_sfx
	open_cose_sound.play()
	$SpellBookSprite.play("open")
	await $SpellBookSprite.animation_finished
	$SpellBookSprite.get_node("LeftZone").visible = true
	
	spell_button.spell_name = "Explosion"
	spell_button.get_child(0).text = "Explosion"
	spell_button.randomize_upgrade()
	spell_button_2.spell_name = "Freeze"
	spell_button_2.get_child(0).text = "Freeze"
	spell_button_2.randomize_upgrade()
	spell_button_3.spell_name = "Shield"
	spell_button_3.get_child(0).text = "Shield"
	spell_button_3.randomize_upgrade()

func close_book():
	$SpellBookSprite.get_node("LeftZone").visible = false
	right_zone.visible = false
	$SpellBookSprite.play("close")
	open_cose_sound.stream = book_close_sfx
	open_cose_sound.play()
	await $SpellBookSprite.animation_finished
	position = initial_position
	get_parent().get_node("Player").can_move = true

func display_upgrade(spell_name: String, stat_upgraded: String, current_stat: String, multiplier: String) -> void:
	if stat_upgraded == "Cooldown":
		upgrade_stats.text = \
		spell_name + "\n" + \
		stat_upgraded + "\n" + \
		current_stat + " sub " + multiplier
	else: 
		upgrade_stats.text = \
		spell_name + "\n" + \
		stat_upgraded + "\n" + \
		current_stat + " add " + multiplier
	right_zone.visible = true

func stat_to_upgrade(weapon: WeaponRessource, stat_upgraded: String) -> String:
		match stat_upgraded:
			"Power":
				return str(weapon.power)
			"Speed":
				return str(weapon.speed)
			"Cooldown":
				return str(weapon.cooldown)
		return ""

func _on_spell_button_mouse_entered() -> void:
	display_upgrade(
		spell_button.spell_name,
		spell_button.stat_upgraded,
		stat_to_upgrade(get_parent().get_node("Player").weapons["explosion"], spell_button.stat_upgraded),
		str(spell_button.upgrade_multiplier)
	 )
	


func _on_spell_button_mouse_exited() -> void:
	right_zone.visible = false


func _on_spell_button_2_mouse_entered() -> void:
	print("mult in spellbook" + str(spell_button_2.upgrade_multiplier))
	print(str(spell_button_2.upgrade_multiplier))
	display_upgrade(
		spell_button_2.spell_name,
		spell_button_2.stat_upgraded,
		stat_to_upgrade(get_parent().get_node("Player").weapons["freeze"], spell_button_2.stat_upgraded),
		str(spell_button_2.upgrade_multiplier)
	 )


func _on_spell_button_2_mouse_exited() -> void:
	right_zone.visible = false


func _on_spell_button_3_mouse_entered() -> void:
	display_upgrade(
		spell_button_3.spell_name,
		spell_button_3.stat_upgraded,
		stat_to_upgrade(get_parent().get_node("Player").weapons["shield"], spell_button_3.stat_upgraded),
		str(spell_button_3.upgrade_multiplier)
	 )


func _on_spell_button_3_mouse_exited() -> void:
	right_zone.visible = false

func upgrade_weapon(weapon: WeaponRessource, spell: TextureButton):
	match spell.stat_upgraded:
		"Power":
			weapon.upgrade_power(spell.upgrade_multiplier)
		"Speed":
			weapon.upgrade_speed(spell.upgrade_multiplier)
		"Cooldown":
			weapon.upgrade_cooldown(spell.upgrade_multiplier)

func _on_spell_button_button_up() -> void:
	var weapon = get_parent().get_node("Player").weapons["explosion"]
	upgrade_weapon(weapon, spell_button)
	close_book()


func _on_spell_button_2_button_up() -> void:
	var weapon = get_parent().get_node("Player").weapons["freeze"]
	upgrade_weapon(weapon, spell_button_2)
	close_book()


func _on_spell_button_3_button_up() -> void:
	var weapon = get_parent().get_node("Player").weapons["shield"]
	upgrade_weapon(weapon, spell_button_3)
	close_book()
