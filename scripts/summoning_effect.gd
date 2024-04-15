extends Node2D

func _on_animated_sprite_2d_animation_finished() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.TRANSPARENT, 0.3).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(queue_free)
