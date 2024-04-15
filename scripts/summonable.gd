class_name Summonable extends CharacterBody2D

@export var max_health = 3

@onready var player: Player = $"../Player"
@onready var hitbox: Hitbox = $Hitbox

var health = max_health
var dead = false
var spawned = false

func _ready() -> void:
	health = max_health
	hitbox.setup(health, on_hit)

	scale = Vector2.ZERO
	modulate = Color.TRANSPARENT

	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.3).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(_handle_spawned)

func _handle_spawned():
	spawned = true
	$SFX.play()

func _find_closest_enemy() -> Variant:
	var closest_enemy = null
	var closest_distance = INF
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not enemy.is_in_group("ignore_enemy"):
			var distance = position.distance_squared_to(enemy.position)
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemy

	return closest_enemy

func on_hit() -> void:
	if dead:
		return

	health -= 1
	if health < 1:
		on_death()

	$HitTweener.start_hit_tween()

func _handle_death() -> void:
	pass

func on_death() -> void:
	if dead:
		return

	dead = true

	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(queue_free)
