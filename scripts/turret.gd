extends StaticBody2D

@onready var muzzle = $"Snout/Muzzle"
@onready var player = $"../Player"

var bullet_scene = preload("res://scenes/bullet.tscn")

var tmr_shoot = 0

func shoot():
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.position = muzzle.position
	bullet.launch(Vector2.RIGHT, 20, Bullet.SEARCH_GROUP.ENEMY)
	muzzle.add_child(bullet)
	
func _process(delta: float) -> void:
	tmr_shoot += delta
	if tmr_shoot >= 0.5:
		shoot()
		tmr_shoot = 0
