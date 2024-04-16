class_name MonumentsSpawner extends Node2D

const SPAWN_OFFSET = 128
const SPAWN_BOUNDARY = 200

@onready var cam: Camera2D = $"../Player/Camera2D"
var scene = preload ("res://scenes/world/monument.tscn")

func spawn() -> void:
  var rng = RandomNumberGenerator.new()

  for i in 5:
    var spawned = false
    while not spawned:
      var rand_pos = Vector2(
        cam.get_screen_center_position().x + rng.randf_range(cam.limit_left + SPAWN_OFFSET, cam.limit_right - SPAWN_OFFSET),
        cam.get_screen_center_position().y + rng.randf_range(cam.limit_top + SPAWN_OFFSET, cam.limit_bottom - SPAWN_OFFSET)
      )

      var nodes_to_check = get_children().duplicate()
      nodes_to_check.append_array(get_tree().get_nodes_in_group("monument_spawn_avoid"))

      if not nodes_to_check.any(func (node: Node2D): return node.global_position.distance_to(rand_pos) <= SPAWN_BOUNDARY):
        var monument = scene.instantiate()
        monument.position = rand_pos
        add_child(monument)
        spawned = true
