extends Node2D

func _ready() -> void:
  var tween = get_tree().create_tween()
  tween.tween_property($AnimatedSprite2D, "modulate", Color.TRANSPARENT, 0.35).set_trans(Tween.TRANS_LINEAR)
  tween.tween_callback(queue_free)

  $AnimatedSprite2D.frame = randi() % 2
