class_name Summonable extends CharacterBody2D

@export var max_health = 3

@onready var player: Player = $"../Player"
@onready var hitbox: Hitbox = $Hitbox

var health = max_health
var dead = false

func _ready() -> void:
	health = max_health
	hitbox.setup(health, on_hit)

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
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.6).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(queue_free)
