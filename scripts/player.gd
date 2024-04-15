class_name Player extends CharacterBody2D

const BASE_SPEED = 300.0
const DASH_SPEED = 1500.0
const MAX_HEALTH = 5

@onready var cam: Camera2D = $Camera2D
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var monuments_spawner: MonumentsSpawner = $"../Monuments"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ui: UI = $"../UI"
@onready var hitbox: Hitbox = $Hitbox

var dash_sprite = preload("res://scenes/dash_sprite.tscn")

var speed = BASE_SPEED
var can_dash = true
var souls = 10
var health = MAX_HEALTH
var tmr_dash_sprite = 0
var dead = false
var score = 0

func _ready() -> void:
	var world_size = Vector2($"../BG".region_rect.size.x * 4 * 0.5, $"../BG".region_rect.size.y * 4 * 0.5)

	cam.limit_top = -world_size.y
	cam.limit_bottom = world_size.y
	cam.limit_left = -world_size.x
	cam.limit_right = world_size.x
	cam.limit_smoothed = true
	monuments_spawner.spawn()

	hitbox.setup(health, on_hit)

func get_input() -> void:
	if dead:
		velocity = Vector2.ZERO
		return

	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

	if velocity != Vector2.ZERO:
		sprite.play("walking")

		if velocity.x > 0:
				sprite.flip_h = true
		else:
				sprite.flip_h = false
	else:
		sprite.play("default")

	if can_dash and Input.is_action_just_pressed("dash"):
		speed = DASH_SPEED
		$DashSFX.play()
		can_dash = false
		dash_timer.start()

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()

func _spawn_dash_sprite():
	if velocity != Vector2.ZERO:
		var ds = dash_sprite.instantiate()
		ds.position = position
		ds.find_child("AnimatedSprite2D").flip_h = sprite.flip_h
		get_parent().add_child(ds)

func _process(delta: float) -> void:
	if speed == DASH_SPEED:
		tmr_dash_sprite += delta
		if tmr_dash_sprite >= 0.035:
			_spawn_dash_sprite()
			tmr_dash_sprite = 0

func _on_dash_timer_timeout() -> void:
	speed = BASE_SPEED
	dash_cooldown_timer.start()

func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true

func add_score(amount) -> void:
	score += amount

func on_hit() -> void:
	if dead:
		return

	health -= 1
	if health < 1:
		dead = true
		ui.on_player_death()
		sprite.stop()

	$HitTweener.start_hit_tween()

func on_pickup_soul() -> void:
	souls += 1
	add_score(1)
	$SoulPickupSFX.play()

func on_heal(requirement: int) -> void:
	souls -= requirement
	health = MAX_HEALTH
	hitbox.health_bar.health = health

func on_creature_summoned(_creature_name: String, requirement: int) -> void:
	souls -= requirement
