extends Creature

var amplitude = 0.1
var period = 2
var time = 0

func _can_move() -> bool:
  return false

func _process(delta):
  time += delta

  var scale_factor = 1 + sin(time * period) * amplitude
  scale.x = scale_factor
  scale.y = scale_factor

func _on_timer_timeout() -> void:
  $Hitbox.does_physical_damage = false

  var tween = get_tree().create_tween()
  tween.tween_property($Sprite2D, "modulate", Color.TRANSPARENT, 0.35).set_trans(Tween.TRANS_LINEAR)
  tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 0.45).set_trans(Tween.TRANS_LINEAR)
  tween.tween_callback(queue_free)
