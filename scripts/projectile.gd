extends Area2D

const SPEED: int = 300
const DAMAGE: int = 3

var direction: Vector2

func _ready() -> void:
	rotate(direction.angle())

func _process(delta: float) -> void:
	position += direction * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if(body.name != "Player"):
		var explosion_fx = preload("res://scenes/Explosion.tscn")
		var explosion = explosion_fx.instantiate()
		explosion.animation_time = 0.5
		explosion.global_position = global_position
		get_parent().add_child(explosion)
		queue_free()
		if body.has_method("take_damage"):
			body.take_damage(DAMAGE)
