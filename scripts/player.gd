extends CharacterBody2D

const SPEED = 300.0

@onready var cam: Camera2D = $"Camera2D"
@onready var bg: Sprite2D = $"../BG"

func _ready() -> void:
	var rect: Rect2 = bg.get_rect()

	cam.limit_top = rect.position.y
	cam.limit_bottom = rect.position.y + rect.size.y
	cam.limit_left = rect.position.x
	cam.limit_right = rect.position.x + rect.size.x
	cam.limit_smoothed = true

func get_input() -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()
