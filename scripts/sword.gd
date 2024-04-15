extends Summonable

const AGGRO_RANGE = 400
const SPEED = 20
const ROT_SPEED = 340

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
  if dead or not spawned:
    return

  if target and is_instance_valid(target) and position.distance_to(target.position) < AGGRO_RANGE:
    rotation = velocity.angle() - deg_to_rad(90)
    velocity = (target.position - position).normalized() * SPEED
  else:
    target = null
    rotation = 0
    velocity = Vector2.ZERO

  var collision = move_and_collide(velocity)
  if collision != null:
    if collision.get_collider().is_in_group("enemy_shield"):
      hitbox.does_physical_damage = false
      on_death()

  var enemy = _find_closest_enemy()
  if enemy and not target and position.distance_to(enemy.position) <= AGGRO_RANGE:
    target = enemy

func _on_hitbox_area_entered(area: Area2D) -> void:
  if area.get_parent().is_in_group("enemy") and not dead:
    on_death()

func _process(delta):
  if target or not spawned:
    return

  time += delta
  position.y = initial_y + sin(time * period) * amplitude
