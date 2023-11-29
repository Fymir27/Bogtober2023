class_name Player extends RigidBody2D

signal player_died
signal pause_requested

@export var _ui: UI
@export var _speed: float
@export var _sprite: Sprite2D
@export var _hit_delay: float
@export var chain_lightning_unlocked: bool
@export var symbiosis_unlocked: bool

var hit_timer: float
var level = 1


func _ready():
	hit_timer = _hit_delay
	_ui.set_level(level)


func _process(delta):
	handle_input()
	flip_sprite()
	hit_timer -= delta


func _physics_process(_delta):
	if hit_timer <= 0:
		hit_closest_enemy()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pause_requested.emit()


func handle_input():
	var direction = Vector2()
	if Input.is_key_pressed(KEY_LEFT) || Input.is_key_pressed(KEY_A) || Input.is_key_pressed(KEY_Q):
		direction.x = -1
	if Input.is_key_pressed(KEY_RIGHT) || Input.is_key_pressed(KEY_D):
		direction.x = 1
	if Input.is_key_pressed(KEY_UP) || Input.is_key_pressed(KEY_W) || Input.is_key_pressed(KEY_Z):
		direction.y = -1
	if Input.is_key_pressed(KEY_DOWN) || Input.is_key_pressed(KEY_S):
		direction.y = 1
	var direction_norm = direction.normalized()
	constant_force = direction_norm * _speed


func flip_sprite():
	if linear_velocity.x > 0:
		_sprite.flip_h = true
	else:
		if linear_velocity.x < 0:
			_sprite.flip_h = false


func deal_damage(amount: float):
	_ui.hp_bar.value -= amount
	if _ui.hp_bar.value <= 0:
		player_died.emit()
		set_process(false)
		set_physics_process(false)
		constant_force = Vector2()


func heal(amount: float):
	_ui.hp_bar.value += amount


func awardXp(amount):
	_ui.xp_bar.value += amount
	if _ui.xp_bar.value >= _ui.xp_bar.max_value:
		level_up()


func hit_closest_enemy():
	var bodies_hit = $AttackRange.get_overlapping_bodies()
	var closest: Node2D
	for body in bodies_hit:
		if (
			!closest
			|| (
				body.global_position.distance_to(global_position)
				< closest.global_position.distance_to(global_position)
			)
		):
			closest = body

	if !closest:
		return

	$Weapon.attack(closest.global_position)
	hit_timer = _hit_delay


func level_up():
	level += 1
	_hit_delay *= 0.9
	_ui.hp_bar.max_value += 2
	_ui.hp_bar.value += 2
	_ui.xp_bar.value -= _ui.xp_bar.max_value
	_ui.xp_bar.max_value += 10
	_ui.set_level(level)
	$LevelUpSound.play()
