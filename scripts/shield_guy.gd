extends Creature

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(_delta: float) -> void:
  if velocity.x > 0:
      sprite.flip_h = true
  else:
      sprite.flip_h = false

func on_death() -> void:
  super()
  queue_free()
