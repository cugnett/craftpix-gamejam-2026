extends Area2D

const SPEED: int = 300

var direction: Vector2

func _ready() -> void:
	rotate(direction.angle())

func _process(delta: float) -> void:
	position += direction * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	# animation explosion
	if(body.name != "Player"):
		queue_free()
		if body.has_method("take_damage"):
			body.take_damage()
