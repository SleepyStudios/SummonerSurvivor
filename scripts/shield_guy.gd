extends Creature

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(_delta: float) -> void:
  if velocity.x > 0:
      sprite.flip_h = true
      $LeftShield/CollisionShape2D.disabled = true
      $RightShield/CollisionShape2D.disabled = false
  else:
      sprite.flip_h = false
      $LeftShield/CollisionShape2D.disabled = false
      $RightShield/CollisionShape2D.disabled = true

func on_death() -> void:
  super()
  queue_free()
