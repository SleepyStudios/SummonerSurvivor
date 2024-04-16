extends Creature

const TELEPORT_DISTANCE_FROM_PLAYER = 200

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var bullet_scene = preload("res://scenes/mage_bullet.tscn")
var dir: Vector2 = Vector2.ZERO
var skip_shoot = true

func _can_move() -> bool:
  return false

func _process(_delta: float) -> void:
  dir = (player.position - position).normalized()

  if dir.x > 0:
    sprite.flip_h = true
  else:
    sprite.flip_h = false

func on_death() -> void:
  super()
  var tween = get_tree().create_tween()
  tween.tween_property(sprite, "modulate", Color.TRANSPARENT, 0.35).set_trans(Tween.TRANS_LINEAR)
  tween.tween_callback(queue_free)

func _on_shoot_timer_timeout() -> void:
  if skip_shoot:
    skip_shoot = false
  else:
    var muzzle = $MuzzleFlipped if sprite.flip_h else $MuzzleNotFlipped
    var bullet: Bullet = bullet_scene.instantiate()
    bullet.position = muzzle.global_position
    bullet.launch(dir, 10)
    player.get_parent().add_child(bullet)

  sprite.play("teleport_out")

func _on_animated_sprite_2d_animation_finished() -> void:
  if player.dead:
    return

  if sprite.animation == "teleport_out":
    var rng = RandomNumberGenerator.new()
    var rand_pos = Vector2(
      rng.randf_range(-TELEPORT_DISTANCE_FROM_PLAYER, TELEPORT_DISTANCE_FROM_PLAYER),
      rng.randf_range(-TELEPORT_DISTANCE_FROM_PLAYER, TELEPORT_DISTANCE_FROM_PLAYER)
    )

    position = player.position + rand_pos
    sprite.play("teleport_in")

  elif sprite.animation == "teleport_in":
    $SFX.play()
    $ShootTimer.start()

