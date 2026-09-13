class_name WeaponRessource
extends Resource

enum weapon_type {
	ATTACK,
	CURSE,
	BUFF,
}

@export var name: String
@export var power: float
@export var speed: float
@export var cooldown: float
@export var is_ready: bool = true
@export var particle_scene: PackedScene
@export var type: weapon_type
@export var text: String
@export var text_color: Color
@export var launch_sound: AudioStream

var init_power: float
var init_speed: float
var init_cooldown: float

func upgrade_power(added_power: float):
	power += added_power
	
func upgrade_speed(added_speed: float):
	speed += added_speed
	
func upgrade_cooldown(reduced_cooldown: float):
	cooldown = max(cooldown - reduced_cooldown, 0.0)
	
func stock_init_values():
	init_power = power
	init_speed = speed
	init_cooldown = cooldown
	
func reset_values():
	power = init_power
	speed = init_speed
	cooldown = init_cooldown
