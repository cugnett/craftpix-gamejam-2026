class_name WeaponRessource
extends Resource

enum weapon_type {
	ATTACK,
	CURSE,
	BUFF,
}

@export var name: String
@export var power: float
@export var speed: int
@export var cooldown: float
@export var is_ready: bool = true
@export var particle_scene: PackedScene
@export var type: weapon_type
@export var text: String
@export var text_color: Color

func upgrade_power(added_power: int):
	power += added_power
	
func upgrade_speed(added_speed: int):
	speed += added_speed
	
func upgrade_cooldown(reduced_cooldown: float):
	cooldown -= reduced_cooldown
