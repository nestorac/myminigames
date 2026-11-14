extends ColorRect
class_name Unit

var team: int = 0  # 0 player, 1 AI
var health: float = 100.0
var max_health: float = 100.0
var speed: float = 80.0
var attack_range: float = 60.0
var attack_damage: float = 15.0
var attack_cooldown: float = 0.0
var is_dead: bool = false

func _ready() -> void:
	size = Vector2(40, 40)
	pivot_offset = size / 2

func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		health = 0
		is_dead = true
		queue_free()

func find_nearest_enemy(units: Array) -> Unit:
	var nearest: Unit = null
	var min_dist := INF
	for u in units:
		if u == self or u.team == team or u.is_dead:
			continue
		var d := global_position.distance_to(u.global_position)
		if d < min_dist:
			min_dist = d
			nearest = u
	return nearest

func update_ai(delta: float, all_units: Array) -> void:
	if is_dead:
		return
	attack_cooldown = max(0, attack_cooldown - delta)
	var target := find_nearest_enemy(all_units)
	if target == null:
		return
	var dir := (target.global_position - global_position).normalized()
	var dist := global_position.distance_to(target.global_position)
	if dist > attack_range:
		global_position += dir * speed * delta
	elif attack_cooldown <= 0:
		target.take_damage(attack_damage)
		attack_cooldown = 1.0
