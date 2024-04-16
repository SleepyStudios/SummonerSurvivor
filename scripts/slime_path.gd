extends Area2D

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
  var tween = get_tree().create_tween()
  tween.parallel().tween_property($Sprite2D, "scale", Vector2.ZERO, 1.5).set_trans(Tween.TRANS_LINEAR)
  tween.parallel().tween_property($Sprite2D, "modulate", Color.TRANSPARENT, 1.0).set_trans(Tween.TRANS_LINEAR)
  tween.tween_callback(queue_free)

func _on_area_entered(area: Area2D) -> void:
  if area.is_in_group("player_feet"):
    area.get_parent().hitbox.handle_hit()
    $SFX.play()
