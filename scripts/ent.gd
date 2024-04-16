extends Creature

const SHOOT_DISTANCE_FROM_PLAYER = 350

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var bullet_scene = preload("res://scenes/ent_bullet.tscn")

var reposition = false

func arrange_in_circle(n: int, r: float) -> Array:
  var output = []
  var offset = 2.0 * PI / n
  for i in range(n):
    var pos = r * Vector2.from_angle(i * offset)
    output.push_front(pos)

  return output

func _can_move() -> bool:
  return position.distance_to(player.position) > SHOOT_DISTANCE_FROM_PLAYER

func _physics_process(_delta: float) -> void:
  if dead or player.dead:
    return

  if player and _can_move():
    velocity = (player.position - position).normalized() * speed

  if velocity.x > 0:
    sprite.flip_h = true
  else:
    sprite.flip_h = false

  if not _can_move() and sprite.animation == "default":
    sprite.play("shooting")
    velocity = Vector2.ZERO
    $ShootTimer.start()
  elif _can_move() and sprite.animation == "shooting":
    reposition = true

  if position.distance_to(player.position) < 10 or reposition:
    velocity = Vector2.ZERO

  move_and_slide()

func on_death() -> void:
  super()

  var tween = get_tree().create_tween()
  tween.tween_property(sprite, "modulate", Color.TRANSPARENT, 0.35).set_trans(Tween.TRANS_LINEAR)
  tween.tween_callback(queue_free)

func _on_shoot_timer_timeout() -> void:
  for pos in arrange_in_circle(8, 10):
    var bullet: Bullet = bullet_scene.instantiate()
    bullet.position = global_position
    bullet.launch(pos.normalized(), 10)
    get_parent().add_child(bullet)

  $SFX.play()
  
  if reposition:
    sprite.play("default")
    $ShootTimer.stop()
    reposition = false
