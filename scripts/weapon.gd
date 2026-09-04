extends Node2D

var is_ready: bool = true

@onready
var Level: Node2D = $".".get_parent().get_parent()
#var ShootingPoint: Marker2D = $Sprite2D/ShootingPoint

func _process(_delta: float) -> void:
	pass


func shoot(direction: Vector2) -> void:
	is_ready = false
	$Cooldown.start()
	const PROJECTILE = preload("res://scenes/Projectile.tscn")
	var new_projectile = PROJECTILE.instantiate()
	new_projectile.global_position = global_position
	new_projectile.global_rotation = global_rotation
	new_projectile.direction = direction
	Level.add_child(new_projectile)


func _on_cooldown_timeout() -> void:
	is_ready = true
