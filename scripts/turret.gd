extends StaticBody2D

@onready var muzzle = $"Snout/Muzzle"
@onready var player = $"../Player"

var bullet_scene = preload("res://scenes/bullet.tscn")

var tmr_shoot = 0

func find_closest_enemy() -> Variant:
	var closest_vector = null
	var closest_distance = INF
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
			var distance = position.distance_squared_to(enemy.position)
			if distance < closest_distance:
				closest_distance = distance
				closest_vector = enemy.position

	return closest_vector

func shoot(dir: Vector2) -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.position = muzzle.position
	bullet.launch(dir.normalized(), 30, Bullet.SEARCH_GROUP.ENEMY)
	add_child(bullet)

func _process(delta: float) -> void:
	var dir = find_closest_enemy()
	if dir:
		$"Snout".rotation = dir.angle()

		tmr_shoot += delta
		if tmr_shoot >= 0.5:
			shoot(dir)
			tmr_shoot = 0
