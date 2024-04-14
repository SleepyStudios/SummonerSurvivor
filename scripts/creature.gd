class_name Creature extends CharacterBody2D

@export var kill_points: int
@export var speed = 250.0

@onready var player: Player = $"../Player"

var soul_pickup = preload ("res://scenes/soul_pickup.tscn")

func _can_move() -> bool:
	return true

func _on_death() -> void:
	var pickup = soul_pickup.instantiate()
	pickup.position = position
	player.get_parent().add_child(pickup)

func _physics_process(_delta: float) -> void:
	if player and _can_move():
		velocity = (player.global_position - global_position).normalized() * speed
		move_and_slide()
