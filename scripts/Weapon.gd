extends Node2D

@export var player: Player
@export var force: float
@export var rotation_speed_attack: float
@export var rotation_speed_retract: float

@export var chain_lightning_bounces: int
@export var chain_lightning_damage: int
@export var chain_lightning_tester: ShapeCast2D
@export var chain_lightning_line: Lightning

var idle_rotation: float
var target_rotation: float
var rotation_speed: float
var attacking: bool


func _ready():
	$WeaponSprite/WeaponHitbox.monitoring = false
	idle_rotation = rotation
	chain_lightning_line.clear_points()


func _process(delta):
	if !$WeaponSprite/WeaponAnimations.is_playing():
		$WeaponSprite/WeaponHitbox.monitoring = false
		target_rotation = idle_rotation
		rotation_speed = rotation_speed_retract
		$WeaponSprite.scale.x = -1

	var diff = target_rotation - rotation
	var abs_diff = abs(diff)
	if abs_diff < 0.01:
		return
	var direction = diff / abs_diff
	var rotation_amount = direction * delta * rotation_speed
	if abs(rotation_amount) > abs_diff:
		rotation_amount = diff
	rotate(rotation_amount)


func _on_enemy_hit(body: Node2D):
	var enemy = body as Enemy
	if !enemy:
		return

	var xp_gained = enemy.inflictAttack(
		player.level, (enemy.global_position - player.global_position).normalized() * force
	)
	player.awardXp(xp_gained)

	if player.chain_lightning_unlocked:
		# print("lighnting");
		chain_lightning_line.clear_points()
		chain_lightning_bounce(enemy, chain_lightning_bounces, [])
		chain_lightning_line.play_animation()


func attack(point: Vector2):
	var current_rotaion = rotation
	look_at(point)
	target_rotation = rotation
	rotation_speed = rotation_speed_attack
	rotation = current_rotaion
	$WeaponSprite/WeaponHitbox.monitoring = true
	$WeaponSprite/WeaponAnimations.play("stab")


func chain_lightning_bounce(enemy: Enemy, bounces_left: int, excluded: Array[Enemy]):
	enemy.inflictAttack(chain_lightning_damage, Vector2())  # TODO knockback based on impact direction
	excluded.append(enemy)
	chain_lightning_line.add_point(enemy.global_position)

	if bounces_left <= 0:
		return bounces_left

	chain_lightning_tester.global_position = enemy.global_position
	chain_lightning_tester.force_shapecast_update()
	var nodes_found: Array[Enemy] = []
	for i in chain_lightning_tester.get_collision_count():
		var collider = chain_lightning_tester.get_collider(i)
		var next_enemy = collider as Enemy
		if next_enemy:
			nodes_found.append(next_enemy)

	if nodes_found.size() == 0:
		return bounces_left

	nodes_found.sort_custom(
		func compare_distance(node_a: Node2D, node_b: Node2D): var dist_a = (
			node_a.global_position.distance_to(enemy.global_position)
		) ; var dist_b = node_b.global_position.distance_to(enemy.global_position) ; return (
			dist_a < dist_b
		)
	)

	for i in nodes_found.size():
		var next_target = nodes_found[i]
		if excluded.find(next_target) >= 0:
			continue
		return chain_lightning_bounce(next_target, bounces_left - 1, excluded)

	return bounces_left
