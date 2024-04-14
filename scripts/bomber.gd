extends Creature

const EXPLODE_TRIGGER_DISTANCE = 150


@onready var sprite: AnimatedSprite2D = $"AnimatedSprite2D"
@onready var boom_timer: Timer = $"BoomTimer"

var ready_to_explode = false
var player_in_explosion = false

func _process(_delta: float) -> void:
	if not ready_to_explode and position.distance_to(player.position) <= EXPLODE_TRIGGER_DISTANCE:
			sprite.play("blinking")
			ready_to_explode = true
	if velocity.x > 0:
			sprite.flip_h = true
	else:
			sprite.flip_h = false

	if dead and sprite.animation != "exploding":
		sprite.animation = "exploding"

func _on_boom_timer_timeout() -> void:
	sprite.play("exploding")

func _can_move() -> bool:
	return sprite.animation != "exploding"

func _on_animated_sprite_2d_animation_changed() -> void:
	if not sprite:
		return

	if sprite.animation == "blinking":
			boom_timer.start()
	elif sprite.animation == "exploding":
		if player_in_explosion:
			player.on_hit()

		on_death()

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "exploding":
		queue_free()

func _on_explosion_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_explosion = true

func _on_explosion_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_explosion = false
