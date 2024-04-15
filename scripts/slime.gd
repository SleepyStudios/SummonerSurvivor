extends Creature

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var path_scene = preload("res://scenes/slime_path.tscn")

func _process(_delta: float) -> void:
  if velocity.x > 0:
    sprite.flip_h = true
  else:
    sprite.flip_h = false

func on_death() -> void:
  super()

  var tween = get_tree().create_tween()
  tween.tween_property(sprite, "scale", Vector2.ZERO, 0.35).set_trans(Tween.TRANS_LINEAR)
  tween.tween_callback(queue_free)

func _on_path_timer_timeout() -> void:
  var path = path_scene.instantiate()
  path.position = position
  player.get_parent().add_child(path)
