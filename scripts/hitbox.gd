class_name Hitbox extends Area2D

const HIT_RATE = 0.5

enum SEARCH_GROUP {
	PLAYER,
	ENEMY
}

signal on_hit
@export var search_group: SEARCH_GROUP
@export var does_physical_damage = true

@onready var health_bar = $HealthBar

var enemies_colliding_with_count = 0
var tmr_hit = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func setup(max_health: int, hit_connection: Callable) -> void:
	health_bar.init_health(max_health)
	on_hit.connect(hit_connection)

func search_group_name() -> String:
	return "enemy" if search_group == SEARCH_GROUP.ENEMY else "player_ally"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(search_group_name()) and body.hitbox.does_physical_damage:
		enemies_colliding_with_count += 1
		tmr_hit = HIT_RATE

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group(search_group_name()):
		enemies_colliding_with_count -= 1

func handle_hit() -> void:
	on_hit.emit()
	health_bar.health -= 1

func _process(delta: float) -> void:
	tmr_hit += delta
	if tmr_hit >= 0.5:
		for i in enemies_colliding_with_count:
			handle_hit()

		tmr_hit = 0
