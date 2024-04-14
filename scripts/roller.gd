extends Summonable

const AGGRO_RANGE = 400
const BASE_SPEED = 150
const AGGRO_SPEED = 400

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var target: Creature
var player_target_offset: Vector2 = Vector2(48, 0)

func find_closest_enemy() -> Variant:
	var closest_enemy = null
	var closest_distance = INF
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var distance = position.distance_squared_to(enemy.position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy

	return closest_enemy

func _reset_to_running():
	target = null
	sprite.play("default")

func _physics_process(_delta: float) -> void:
	if dead:
		return

	if player and not target:
		velocity = ((player.position + player_target_offset) - position).normalized() * BASE_SPEED

	if target and is_instance_valid(target):
		if position.distance_to(target.position) > AGGRO_RANGE:
			_reset_to_running()
		else:
			velocity = (target.position - position).normalized() * AGGRO_SPEED
	else:
		_reset_to_running()

	if velocity.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

	move_and_slide()

	var enemy = find_closest_enemy()
	if enemy and not target and position.distance_to(enemy.position) <= AGGRO_RANGE:
		target = enemy
		sprite.play("rolling")

func _on_position_timer_timeout() -> void:
	player_target_offset *= -1
