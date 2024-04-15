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
var ent = preload ("res://scenes/ent.tscn")
var mage = preload ("res://scenes/mage.tscn")

var patterns: Array = [
  {
    "scene": slime,
    "amount": 1,
    "rate": 3,
    "start": 1,
    "end": 60
  },
  {
    "scene": imp,
    "amount": 1,
    "rate": 10,
    "start": 30,
    "end": 120
  },
  {
    "scene": shield_guy,
    "amount": 1,
    "rate": 20,
    "start": 60,
    "end": 180
  },
  {
    "scene": slime,
    "amount": 2,
    "rate": 4,
    "start": 60,
    "end": INF
  },
  {
    "scene": ent,
    "amount": 1,
    "rate": 5,
    "start": 90,
    "end": 300
  },
  {
    "scene": mage,
    "amount": 1,
    "rate": 30,
    "start": 120,
    "end": 240
  },
  {
    "scene": imp,
    "amount": 1,
    "rate": 5,
    "start": 120,
    "end": INF
  },
  {
    "scene": shield_guy,
    "amount": 1,
    "rate": 10,
    "start": 180,
    "end": INF
  },
  {
    "scene": mage,
    "amount": 1,
    "rate": 15,
    "start": 240,
    "end": INF
  },
  {
    "scene": ent,
    "amount": 3,
    "rate": 10,
    "start": 300,
    "end": INF
  },
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
