class_name Enemy extends CharacterBody2D

@export var _speed: float;	
@export var _damage: float;
@export var _hit_delay: float;
@export var _target: Player;
@export var _sprite : Sprite2D;
@export var _hit_progress: ProgressBar;

var _hit_timer: float;

func _ready():	
	if (_hit_progress):
		_hit_progress.max_value = _hit_delay;
	pass;

func _process(delta):
	_hit_timer -= delta;
	if (_hit_progress):
		_hit_progress.value = _hit_progress.max_value - _hit_timer;
		
	
func _physics_process(_delta):
	if (!_target):
		return;
	var direction = _target.global_position - global_position;
	velocity = direction.normalized() * _speed;
	move_and_slide();
	flip_sprite();
	if (_target && _hit_timer <= 0):
		_try_attack();
	
func _try_attack():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i);
		handle_collision(collision);
	
func handle_collision(collision: KinematicCollision2D):	
	var player = collision.get_collider() as Player;	
	if (!player):
		return;	
	player.deal_damage(_damage);	
	_hit_timer = _hit_delay;
	
func flip_sprite():
	if (velocity.x > 0):
		_sprite.flip_h = true;	
	else: if (velocity.x < 0):
		_sprite.flip_h = false;
