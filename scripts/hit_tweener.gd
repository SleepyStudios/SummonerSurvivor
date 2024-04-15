class_name HitTweener extends Node2D

@export var sprite: Node2D

func start_hit_tween():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "self_modulate", Color(1, 0.5, 0.5), 0.1).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(_reverse_hit_tween)

func _reverse_hit_tween():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "self_modulate", Color.WHITE, 0.1).set_trans(Tween.TRANS_LINEAR)
