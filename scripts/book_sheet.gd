extends Node2D





func _on_sheet_collision_shape_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player entered booksheet area")
		# Make sheet disappear
		$SheetAnimatedSprite.play("disappear")
		$SheetAnimatedSpriteShadow.play("disappear")
		await $SheetAnimatedSprite.animation_finished
		SignalManager.booksheet_collected.emit()
		queue_free()
		
		
