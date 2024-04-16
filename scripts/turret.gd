extends Summonable

@onready var muzzle = $Muzzle
@onready var sprite = $AnimatedSprite2D

var bullet_scene = preload("res://scenes/friendly_bullet.tscn")

var tmr_shoot = 0

func find_closest_enemy() -> Variant:
	var closest_vector = null
	var closest_distance = INF
	
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not enemy.is_in_group("ignore_enemy"):
			var distance = position.distance_squared_to(enemy.position)
			if distance < closest_distance:
				closest_distance = distance
				closest_vector = enemy.position

	return closest_vector

func shoot(dir: Vector2) -> void:
	$ShootSFX.play()

	var bullet: Bullet = bullet_scene.instantiate()
	bullet.position = muzzle.global_position
	bullet.launch(dir.normalized(), 30)
	get_parent().add_child(bullet)

func _process(delta: float) -> void:
	if dead or player.dead:
		return

	var enemy = find_closest_enemy()
	if enemy:
		var dir = enemy - position
		if dir.x > 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false

		tmr_shoot += delta
		if tmr_shoot >= 1.0:
			shoot(dir)
			tmr_shoot = 0
