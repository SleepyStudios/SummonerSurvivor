extends Label

const messages = [
  "USE [WASD] OR [ARROWS] TO MOVE",
  "USE [SPACE] TO DASH",
  "USE [RMB] TO OPEN YOUR SUMMONS",
  "USE [SCROLLWHEEL] TO SELECT A SUMMON",
  "USE [LMB] TO SUMMON"
]

const timer_speed = 3

var idx = -1

func _ready() -> void:
  modulate = Color.TRANSPARENT

func _next_tween() -> void:
  if idx == messages.size() - 1:
    $Timer.stop()
    return

  idx += 1
  text = messages[idx]

  var tween = get_tree().create_tween()
  tween.tween_property(self, "modulate", Color.WHITE, 0.2).set_trans(Tween.TRANS_LINEAR)
  tween.tween_callback(_reset_timer)

func _reset_timer():
  if $Timer.wait_time != timer_speed:
    $Timer.stop()
    $Timer.wait_time = timer_speed
    $Timer.start()

func _on_timer_timeout() -> void:
  var tween = get_tree().create_tween()
  tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2).set_trans(Tween.TRANS_LINEAR)
  tween.tween_callback(_next_tween)
