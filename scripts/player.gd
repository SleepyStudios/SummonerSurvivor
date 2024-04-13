extends CharacterBody2D

const BASE_SPEED = 300.0
const DASH_SPEED = 1500.0

var speed = BASE_SPEED
var can_dash = true

@onready var cam: Camera2D = $"Camera2D"
@onready var dash_timer: Timer = $"DashTimer"
@onready var dash_cooldown_timer: Timer = $"DashCooldownTimer"
@onready var bg: Sprite2D = $"../BG"
@onready var monuments_spawner: MonumentsSpawner = $"../Monuments"

func _ready() -> void:
	var rect: Rect2 = bg.get_rect()

	cam.limit_top = rect.position.y
	cam.limit_bottom = rect.position.y + rect.size.y
	cam.limit_left = rect.position.x
	cam.limit_right = rect.position.x + rect.size.x
	cam.limit_smoothed = true
	monuments_spawner.spawn()

func get_input() -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

	if can_dash and Input.is_action_just_released("dash"):
		speed = DASH_SPEED
		can_dash = false
		dash_timer.start()

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()

func _on_dash_timer_timeout() -> void:
	speed = BASE_SPEED
	dash_cooldown_timer.start()

func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
