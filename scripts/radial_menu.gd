@tool
class_name RadialMenu extends Control

@onready var player: Player = $"../Player"

const MOUSE_OFFSET = Vector2(44, 44)

func _ready() -> void:
	visible = false

func arrange_in_circle(n: int, r: float, center = Vector2.ZERO, start_offset = 0.0) -> Array:
	var output = []
	var offset = 2.0 * PI / n
	for i in range(n):
		var pos = r * Vector2.from_angle(i * offset + start_offset)
		output.push_front(pos + center)
	return output

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		var idx = 0
		for pos in arrange_in_circle(get_children().size(), 90.0):
			get_children()[idx].position = pos
			idx += 1

	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("open_summon_menu") and player.velocity == Vector2.ZERO:
			visible = true
			position = get_global_mouse_position() - MOUSE_OFFSET
