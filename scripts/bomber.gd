extends Summonable

const SPEED = 200
const AGGRO_RANGE = 250

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var boom_timer: Timer = $BoomTimer

var ready_to_explode = false
var nodes_to_hit_in_explosion = []
var target: Creature

func _on_boom_timer_timeout() -> void:
	sprite.play("exploding")

func _physics_process(_delta: float) -> void:
	if dead or not spawned or sprite.animation == "exploding":
		return

	if player and not target:
		velocity = (player.position - position).normalized() * SPEED

	if target and is_instance_valid(target):
			velocity = (target.position - position).normalized() * SPEED
	else:
		target = null

	if position.distance_to(target.position if target else player.position) < 32:
		velocity = Vector2.ZERO

	if velocity.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

	var enemy = _find_closest_enemy()
	if enemy and not target and position.distance_to(enemy.position) <= AGGRO_RANGE:
		target = enemy
		sprite.play("blinking")
		ready_to_explode = true

	move_and_slide()

func _on_animated_sprite_2d_animation_changed() -> void:
	if not sprite:
		return

	if sprite.animation == "blinking":
			boom_timer.start()
	elif sprite.animation == "exploding":
		$ExplosionSFX.play()

		for node in nodes_to_hit_in_explosion:
			node.hitbox.handle_hit()

		on_death()

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "exploding":
		queue_free()

func _on_explosion_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not body.is_in_group("ignore_enemy"):
		nodes_to_hit_in_explosion.push_back(body)

func _on_explosion_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and not body.is_in_group("ignore_enemy"):
		nodes_to_hit_in_explosion = nodes_to_hit_in_explosion.filter(func (node): return node != body)

func on_death() -> void:
	if dead:
		return

	dead = true
	sprite.animation = "exploding"
