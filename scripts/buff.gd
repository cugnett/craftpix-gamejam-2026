extends Area2D

const SPEED_ROTATION = 5

@onready
var Text: CurvedText2D = $CurvedText2D

var direction: Vector2
var weapon: WeaponRessource

func _ready() -> void:
	$BuffSound.stream = weapon.launch_sound
	$BuffSound.play()
	Text.label_settings.set_font_color(weapon.text_color)
	Text.text = weapon.text

func _process(delta: float) -> void:
	Text.rotation += delta * SPEED_ROTATION
	Text.global_position = get_parent().get_node("Player").global_position


func _on_timer_timeout() -> void:
	queue_free()
