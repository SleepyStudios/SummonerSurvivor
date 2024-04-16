extends Node2D

const ATTRACTION_DISTANCE = 220
const MAX_SPEED = 360

@onready var player: Player = $"../Player"

var velocity: Vector2
var picked_up = false

func _get_speed() -> float:
	var distance = position.distance_to(player.position)
	return lerp(MAX_SPEED, 16, clamp(distance / ATTRACTION_DISTANCE, 0, 1))

func _physics_process(_delta: float) -> void:
	if picked_up:
		return

	if player:
		velocity = position.direction_to(player.position) * _get_speed()

	position += velocity * _delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if picked_up:
		return

	if body.is_in_group("player"):
		player.on_pickup_soul()
		queue_free()
