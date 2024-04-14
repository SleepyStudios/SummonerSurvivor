@tool
class_name RadialMenu extends Node2D

@onready var player: Player = $"../Player"

const RADIUS = 120

var scroll_idx = 0
var tmr_can_scroll = 0
var can_scroll = true

func _ready() -> void:
	visible = false
	_toggle_current_scroll_idx_button()

func arrange_in_circle(n: int, r: float, center = Vector2.ZERO, start_offset = 0.0) -> Array:
	var output = []
	var offset = 2.0 * PI / n
	for i in range(n):
		var pos = r * Vector2.from_angle(i * offset + start_offset)
		output.push_front(pos + center)
	return output

func _scroll(dir: int):
	_toggle_current_scroll_idx_button()
	scroll_idx += dir
	_toggle_current_scroll_idx_button()
	can_scroll = false

func _unhandled_input(event: InputEvent):
	if event is InputEventPanGesture and can_scroll:
		if event.delta.y < 0:
			_scroll(-1)
		elif event.delta.y > 0:
			_scroll(1)

	if event is InputEventMouseButton and can_scroll:
		if event.event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_scroll(-1)
		elif event.event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_scroll(1)

func _toggle_current_scroll_idx_button() -> void:
	get_children()[scroll_idx % get_children().size()].toggle()

func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		position = get_global_mouse_position()

func _process(delta: float) -> void:	
	if Engine.is_editor_hint():
		var idx = 0
		for pos in arrange_in_circle(get_children().size(), RADIUS):
			get_children()[idx].position = pos
			idx += 1

	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("open_summon_menu"):
			visible = not visible

		if Input.is_action_just_pressed("choose_summon") and visible:
			get_children()[scroll_idx % get_children().size()].press()
			
		if visible:
			tmr_can_scroll += delta
			if tmr_can_scroll >= 0.3:
				can_scroll = true
				tmr_can_scroll = 0
