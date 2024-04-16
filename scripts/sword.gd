extends Summonable

const AGGRO_RANGE = 400
const SPEED = 20

var target: Creature

var move_speed = 100
var amplitude = 50
var period = 2
var time = 0
var initial_y = 0

func _ready() -> void:
  super()
  initial_y = position.y

func _physics_process(_delta: float) -> void:
  if dead or not spawned or player.dead:
    return

  if target and is_instance_valid(target) and position.distance_to(target.position) < AGGRO_RANGE:
    rotation = velocity.angle() - deg_to_rad(90)
    velocity = (target.position - position).normalized() * SPEED
  else:
    if target:
      initial_y = position.y

    if is_instance_valid(target):
      target.remove_from_group("sword_target")

    target = null
    velocity = Vector2.ZERO

  var collision = move_and_collide(velocity)
  if collision != null:
    if collision.get_collider().is_in_group("enemy_shield"):
      on_death()

  var enemy = _find_closest_enemy()
  if enemy and not enemy.is_in_group("sword_target") and not target and position.distance_to(enemy.position) <= AGGRO_RANGE:
    target = enemy
    target.add_to_group("sword_target")
    $SFX.play()

func _process(delta):
  if target or not spawned:
    return

  time += delta
  position.y = initial_y + sin(time * period) * amplitude
  rotation_degrees = lerp_angle(rotation_degrees, 0, 0.5 * delta)

func on_death() -> void:
  super()

  hitbox.does_physical_damage = false

  if target and is_instance_valid(target):
    target.remove_from_group("sword_target")
