extends Summonable

@onready var muzzle = $Snout/Muzzle

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
	bullet.position = muzzle.global_position
	bullet.launch(dir.normalized(), 40, Hitbox.SEARCH_GROUP.ENEMY)
	get_parent().add_child(bullet)

func _process(delta: float) -> void:
	if dead:
		return

	var enemy = find_closest_enemy()
	if enemy:
		$Snout.rotation = position.angle_to_point(enemy)

		tmr_shoot += delta
		if tmr_shoot >= 1.0:
			shoot(enemy - position)
			tmr_shoot = 0
