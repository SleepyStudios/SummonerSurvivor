class_name Creature extends CharacterBody2D

@export var kill_points: int
@export var speed = 250.0

@onready var player: Player = $"../Player"

var dead = false

var soul_pickup = preload ("res://scenes/soul_pickup.tscn")

func _can_move() -> bool:
	return not player.dead

func on_death() -> void:
	if dead:
		return

	dead = true
	var pickup = soul_pickup.instantiate()
	pickup.position = position
	player.get_parent().add_child(pickup)

func _physics_process(_delta: float) -> void:
	if dead:
		return

	if player and _can_move():
		velocity = (player.position - position).normalized() * speed
		move_and_slide()
