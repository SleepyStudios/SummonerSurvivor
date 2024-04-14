@tool
extends Button

@export var creature_name: String
@export var creature_scene: String
@export var cost: int

@onready var player: Player = $"../../../Player"
@onready var cam: Camera2D = $"../../../Player/Camera2D"

func _ready() -> void:
	tooltip_text = "Summon %s (%s)" % [creature_name, cost]

func _process(_delta: float) -> void:
	(get_child(0) as TextureRect).modulate = Color(1, 1, 1, 50 / 255.0) if disabled else Color.WHITE
	
	if not Engine.is_editor_hint():
		disabled = player.souls < cost

func _on_pressed() -> void:
	print("res://scenes/%s.tscn %s %s" % [creature_scene, get_parent().position, player.position])
	var creature = load("res://scenes/%s.tscn" % [creature_scene]).instantiate()
	creature.position = get_parent().position - Vector2(get_viewport_rect().size.x * 0.5, get_viewport_rect().size.y * 0.5) + get_parent().MOUSE_OFFSET

	player.get_parent().add_child(creature)

	player.on_creature_summoned(creature_name, cost)
	get_parent().visible = false
