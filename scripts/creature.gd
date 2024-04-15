class_name Creature extends CharacterBody2D

@export var kill_points: int
@export var speed = 250.0
@export var max_health = 3

@onready var player: Player = $"../Player"
@onready var hitbox: Hitbox = $Hitbox

var health
var dead = false

var soul_pickup = preload ("res://scenes/soul_pickup.tscn")

func _ready() -> void:
	health = max_health
	hitbox.setup(health, on_hit)

func _can_move() -> bool:
	return not player.dead

func on_hit() -> void:
	if dead:
		return

	health -= 1
	if health < 1:
		on_death()

	$HitTweener.start_hit_tween()

func on_death() -> void:
	if dead:
		return

	dead = true
	player.add_score(kill_points)

	var pickup = soul_pickup.instantiate()
	pickup.position = position
	player.get_parent().add_child(pickup)

func _physics_process(_delta: float) -> void:
	if dead:
		return

	if player and _can_move():
		velocity = (player.position - position).normalized() * speed
		move_and_slide()
