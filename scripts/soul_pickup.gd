extends Node2D

const ATTRACTION_DISTANCE = 220
const MAX_SPEED = 360

@onready var player: Player = $"../Player"

var velocity: Vector2

func _get_speed() -> float:
	if not player.can_pickup_souls():
		return 0

	var distance = position.distance_to(player.position)
	return lerp(MAX_SPEED, 16, clamp(distance / ATTRACTION_DISTANCE, 0, 1))

func _physics_process(_delta: float) -> void:
	if player:
		velocity = position.direction_to(player.position) * _get_speed()

	position += velocity * _delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and player.can_pickup_souls():
		player.on_pickup_soul()
		queue_free()
