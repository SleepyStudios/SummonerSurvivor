extends Node2D

const SPAWN_OFFSET = 128
enum SPAWN_POSITION {
  TOP,
  BOTTOM,
  LEFT,
  RIGHT
}

var imp = preload ("res://scenes/imp.tscn")
var shield_guy = preload ("res://scenes/shield_guy.tscn")
var slime = preload ("res://scenes/slime.tscn")

var patterns: Array = [
  {
    "scene": imp,
    "amount": 1,
    "rate": 8,
    "start": 1,
    "end": 30
  },
  {
    "scene": slime,
    "amount": 1,
    "rate": 3,
    "start": 15,
    "end": 45
  },
  {
    "scene": shield_guy,
    "amount": 1,
    "rate": 1,
    "start": 30,
    "end": 60
  }
]

@onready var player: Player = $"../Player"
@onready var cam: Camera2D = $"../Player/Camera2D"
@export var disabled: bool

var time: int = 0

func _on_timer_timeout() -> void:
  if disabled or player.dead:
    return

  time += 1

  for pattern in patterns:
    if time >= pattern.start and time <= pattern.end and time % pattern.rate == 0:
      spawn(pattern)

func spawn(pattern: Dictionary) -> void:
  var spawn_positions = SPAWN_POSITION.values().duplicate()
  spawn_positions.shuffle()
  var spawn_pos_type = spawn_positions[0]

  var rand_pos = cam.get_screen_center_position()

  match spawn_pos_type:
    SPAWN_POSITION.TOP:
      rand_pos = Vector2(randi() % int(get_viewport_rect().size.x), rand_pos.y - get_viewport_rect().size.y * 0.5 - SPAWN_OFFSET)
    SPAWN_POSITION.BOTTOM:
      rand_pos = Vector2(randi() % int(get_viewport_rect().size.x), rand_pos.y + get_viewport_rect().size.y * 0.5 + SPAWN_OFFSET)
    SPAWN_POSITION.LEFT:
      rand_pos = Vector2(rand_pos.x - get_viewport_rect().size.x * 0.5 - SPAWN_OFFSET, randi() % int(get_viewport_rect().size.y))
    SPAWN_POSITION.RIGHT:
      rand_pos = Vector2(rand_pos.x + get_viewport_rect().size.x * 0.5 + SPAWN_OFFSET, randi() % int(get_viewport_rect().size.y))

  print("PATTERN %s: spawning %s %s at %s,%s (%s)" % [patterns.find(pattern), pattern.amount, pattern.scene.get_state().get_node_name(0), rand_pos.x, rand_pos.y, SPAWN_POSITION.find_key(spawn_pos_type)])

  var enemy = pattern.scene.instantiate()
  enemy.position = rand_pos
  player.get_parent().add_child(enemy)
