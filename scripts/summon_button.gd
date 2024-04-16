extends Sprite2D

@export var creature_name: String
@export var creature_scene: String
@export var creature_icon: Texture2D
@export var cost: int

@onready var player: Player = $"../../Player"
@onready var label: Label = $Label

var summoning_effect_scene = preload("res://scenes/summoning_effect.tscn")

var selected = false
var disabled = false

func _ready() -> void:
	label.text = "Summon %s (%s)" % [creature_name, cost]
	label.visible = false
	($SummonIcon as Sprite2D).texture = creature_icon

func _check_disabled() -> bool:
	return player.souls < cost

func _process(_delta: float) -> void:
	$SummonIcon.modulate = Color(1, 1, 1, 100 / 255.0) if _check_disabled() else Color.WHITE
	var opacity = 0.8 if selected and not _check_disabled() else (110 / 255.0)
	var bit = 0.5 if _check_disabled() else 1.0
	self_modulate = Color(1, bit, bit, opacity)

func toggle() -> void:
	selected = not selected
	label.visible = selected
	
func press() -> void:
	if _check_disabled():
		return

	var spawn_pos = get_parent().position

	var summoning_effect = summoning_effect_scene.instantiate()
	summoning_effect.position = spawn_pos
	player.get_parent().add_child(summoning_effect)

	var creature = load("res://scenes/%s.tscn" % [creature_scene]).instantiate()
	creature.position = spawn_pos
	player.get_parent().add_child(creature)

	player.on_creature_summoned(creature_name, cost)
	get_parent().visible = false
