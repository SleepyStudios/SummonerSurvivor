extends Summonable

const AGGRO_RANGE = 300
const BASE_SPEED = 150
const AGGRO_SPEED = 400

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var target: Creature

func _reset_to_running():
	target = null
	sprite.play("default")

func _physics_process(_delta: float) -> void:
	if dead or not spawned or player.dead:
		return

	if player and not target:
		velocity = (player.position - position).normalized() * BASE_SPEED

	if target and is_instance_valid(target):
		if position.distance_to(target.position) > AGGRO_RANGE:
			_reset_to_running()
		else:
			velocity = (target.position - position).normalized() * AGGRO_SPEED
	else:
		_reset_to_running()

	if position.distance_to(target.position if target else player.position) < 32:
		velocity = Vector2.ZERO
		if sprite.animation == "default":
			sprite.stop()
	else:
		if not sprite.is_playing():
			sprite.play()

	if velocity.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

	move_and_slide()

	var enemy = _find_closest_enemy()
	if enemy and not target and position.distance_to(enemy.position) <= AGGRO_RANGE:
		target = enemy
		sprite.play("rolling")
