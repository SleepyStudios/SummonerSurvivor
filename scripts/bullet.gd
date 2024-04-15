class_name Bullet extends StaticBody2D

var velocity: Vector2
@export var search_group: Hitbox.SEARCH_GROUP

func launch(direction: Vector2, speed: float):    
	velocity = direction * speed  
	$Sprite2D.rotation = direction.angle()

	if search_group == Hitbox.SEARCH_GROUP.PLAYER:
		set_collision_mask_value(2, false)
	elif search_group == Hitbox.SEARCH_GROUP.ENEMY:
		set_collision_mask_value(3, false)

func _physics_process(_delta: float):  
	var collision = move_and_collide(velocity)    

	if collision != null:
		if collision.get_collider().is_in_group("player" if search_group == Hitbox.SEARCH_GROUP.PLAYER else "enemy"):
			if collision.get_collider().is_in_group("enemy"):
				collision.get_collider().hitbox.handle_hit()
			else:
				collision.get_collider().on_hit()

		queue_free()
