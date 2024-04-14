class_name Bullet extends StaticBody2D

enum SEARCH_GROUP {
	PLAYER,
	ENEMY
}

var velocity: Vector2
var search_group: SEARCH_GROUP

func launch(direction: Vector2, speed: float, group: SEARCH_GROUP):    
	velocity = direction * speed  
	search_group = group
	$"Sprite2D".rotation = direction.angle()

	if search_group == SEARCH_GROUP.PLAYER:
		set_collision_mask_value(2, false)
	elif search_group == SEARCH_GROUP.ENEMY:
		set_collision_mask_value(3, false)

func _physics_process(_delta: float):  
	var collision = move_and_collide(velocity)    

	if collision != null:
		if collision.get_collider().is_in_group("player" if search_group == SEARCH_GROUP.PLAYER else "enemy"):
			if search_group == SEARCH_GROUP.ENEMY:
				collision.get_collider().on_death()

		queue_free()
