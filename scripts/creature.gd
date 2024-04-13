class_name Creature extends CharacterBody2D

@export var soul_key: String
@export var souls_required: int
@export var kill_points: int
@onready var player: CharacterBody2D = $"../../Player"

var speed = 250.0

func _physics_process(_delta: float) -> void:
	if player:
		velocity = (player.global_position - global_position).normalized() * speed
		move_and_slide()
