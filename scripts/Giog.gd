extends Enemy

@export var _aiming: bool = true;
@export var _attack_anchor: Node2D
@export var _attack_area: Area2D
@export var _detection_area: Area2D

var _original_speed: float


func _process(delta):
	super._process(delta)
	if _aiming:
		_attack_anchor.look_at(_target.global_position)


func _try_attack():
	if !is_player_in_range():
		return
	_hit_timer = 9999;
	$AnimationPlayer.play("area_attack")


func is_player_in_range():
	return _detection_area.overlaps_body(_target)


func attack():
	_hit_timer = _hit_delay
	for body in _attack_area.get_overlapping_bodies():
		var player = body as Player
		if !player:
			continue
		player.deal_damage(_damage)


func stop():
	_original_speed = _movement_speed
	_movement_speed = 0


func unstop():
	_movement_speed = _original_speed
