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

func _physics_process(_delta: float):  
	var collision = move_and_collide(velocity)    

	if collision != null:    
		queue_free()
