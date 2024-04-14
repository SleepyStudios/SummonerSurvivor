class_name HealthBar extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

var health = 0 : set = _set_health

func _set_health(new_health: int):
	var prev = health

	if new_health == 0:
		visible = false

	health = min(max_value, new_health)
	value = health

	if new_health < prev:
		timer.start()
	else:
		damage_bar.value = health

func init_health(_health: int):
	health = _health
	max_value = health
	value = health

	damage_bar.max_value = health
	damage_bar.value = health

func _on_timer_timeout() -> void:
	damage_bar.value = health
