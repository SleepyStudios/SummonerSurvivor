extends Node2D

const SPAWN_OFFSET = 128
enum SPAWN_POSITION {
  TOP,
  BOTTOM,
  LEFT,
  RIGHT
}

var bob = preload ("res://scenes/bob.tscn")
var patterns: Array = [
  {
    "scene": bob,
    "amount": 1,
    "start": 1,
    "rate": 3,
    "end": 30
  }
]

@onready var creatures = $"../Creatures"
@onready var cam: Camera2D = $"../Player/Camera2D"

var time: int = 0

func _on_timer_timeout() -> void:
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

  print("summoning %s %s at %s,%s (%s)" % [pattern.amount, pattern.scene.get_state().get_node_name(0), rand_pos.x, rand_pos.y, SPAWN_POSITION.find_key(spawn_pos_type)])

  var enemy = pattern.scene.instantiate()
  enemy.position = rand_pos
  creatures.add_child(enemy)
