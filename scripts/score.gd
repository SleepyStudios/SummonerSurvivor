extends Node

var souls_collected = 0: set = _set_souls_collected
var soul_offerings = 0: set = _set_soul_offerings
var summons = 0: set = _set_summons
var enemies_killed = 0
var enemy_score = 0: set = _set_enemy_score
var time_score = 0

var score_tween_lock = false
var souls_tween_lock = false

var tween_size = Vector2(1.25, 1.25)
var tween_speed = 0.2

@onready var points_label = $"../Scene/UI/Labels/PointsLabel"
@onready var souls_label = $"../Scene/UI/Labels/SoulsLabel"

func _set_souls_collected(new_value):
  souls_collected = new_value
  _create_souls_tween()

func _set_soul_offerings(new_value):
  soul_offerings = new_value
  _create_score_tween()

func _set_summons(new_value):
  summons = new_value
  _create_score_tween()

func _set_enemy_score(new_value):
  enemy_score = new_value
  _create_score_tween()

func get_time_bonus() -> int:
  return int(time_score / 60.0) * 10

func base_calculation() -> int:
  return souls_collected + (soul_offerings * 3) + (summons * 5) + enemy_score

func get_current_score() -> int:
  return base_calculation()

func get_final_score() -> int:
  return base_calculation() + get_time_bonus()

func _create_score_tween():
  if score_tween_lock:
    return

  score_tween_lock = true

  var tween = get_tree().create_tween()
  tween.tween_property(points_label, "scale", tween_size, tween_speed).set_trans(Tween.TRANS_LINEAR)
  tween.tween_callback(_reset_score_tween)

func _reset_score_tween():
  var tween = get_tree().create_tween()
  tween.tween_property(points_label, "scale", Vector2.ONE, tween_speed).set_trans(Tween.TRANS_LINEAR)
  tween.tween_callback(func (): score_tween_lock = false)

func _create_souls_tween():
  if souls_tween_lock:
    return

  souls_tween_lock = true

  var tween = get_tree().create_tween()
  tween.tween_property(souls_label, "scale", tween_size, tween_speed).set_trans(Tween.TRANS_LINEAR)
  tween.tween_callback(_reset_souls_tween)

func _reset_souls_tween():
  var tween = get_tree().create_tween()
  tween.tween_property(souls_label, "scale", Vector2.ONE, tween_speed).set_trans(Tween.TRANS_LINEAR)
  tween.tween_callback(func (): souls_tween_lock = false)
