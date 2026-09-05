extends Node2D


signal booksheet_collected


func _on_sheet_collision_shape_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# Make sheet disappear
		$SheetAnimatedSprite.play("disappear")
		$SheetAnimatedSpriteShadow.play("disappear")
		await $SheetAnimatedSprite.animation_finished
		booksheet_collected.emit()
		queue_free()
		
		
