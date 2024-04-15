class_name Hitbox extends Area2D

const HIT_RATE = 0.5

enum SEARCH_GROUP {
	PLAYER,
	ENEMY
}

signal on_hit
@export var search_group: SEARCH_GROUP
@export var does_physical_damage = true
@export var takes_physical_damage = true

@onready var health_bar = $HealthBar

var colliding_with_hitboxes: Array[Area2D] = []
var tmr_hit = 0

func _ready() -> void:
	if takes_physical_damage:
		area_entered.connect(_on_hitbox_entered)
		area_exited.connect(_on_hitbox_exited)

func setup(max_health: int, hit_connection: Callable) -> void:
	health_bar.init_health(max_health)
	on_hit.connect(hit_connection)

func search_group_name() -> String:
	return "enemy" if search_group == SEARCH_GROUP.ENEMY else "player_ally"

func _on_hitbox_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group(search_group_name()) and area.does_physical_damage:
		colliding_with_hitboxes.push_back(area)
		tmr_hit = HIT_RATE

func _on_hitbox_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group(search_group_name()):
		colliding_with_hitboxes = colliding_with_hitboxes.filter(func (a): return a != area)

func handle_hit() -> void:
	on_hit.emit()
	health_bar.health -= 1

func _process(delta: float) -> void:
	tmr_hit += delta
	if tmr_hit >= 0.5:
		for hitbox in colliding_with_hitboxes:
			handle_hit()

		tmr_hit = 0
