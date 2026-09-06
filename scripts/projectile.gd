extends Area2D

@onready
var TextLabel: RichTextLabel = $Control/TextLabel

var direction: Vector2
var weapon: WeaponRessource

func _ready() -> void:
	rotate(direction.angle())
	TextLabel.push_color(weapon.text_color)
	TextLabel.append_text(weapon.text)

func _process(delta: float) -> void:
	position += direction * weapon.speed * delta


func _on_body_entered(body: Node2D) -> void:
	if(body.name != "Player"):
		var explosion_fx = weapon.particle_scene
		var explosion = explosion_fx.instantiate()
		explosion.global_position = global_position
		get_parent().add_child(explosion)
		queue_free()
		match weapon.name:
			"explosion":
				if body.has_method("take_damage"):
					body.take_damage(weapon.power)
			"freeze":
				if body.has_method("frozen"):
					body.frozen(weapon.power)
