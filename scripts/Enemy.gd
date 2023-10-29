class_name Enemy extends RigidBody2D

@export var _movement_speed: float
@export var _damage: float;
@export var _health: float;
@export var _xp: float;
@export var _hit_delay: float;
@export var _target: Player;
@export var _sprite : Sprite2D;
var _hit_timer: float;


func _process(delta):
	_hit_timer -= delta;		
	
func _physics_process(_delta):

	var target_direction = _target.global_position - global_position;
	constant_force = target_direction.normalized() * _movement_speed;
	
	flip_sprite();

	if (_target && _hit_timer <= 0):
		_try_attack();
	
func _try_attack():
	for body in get_colliding_bodies():
		handle_collision(body);

func handle_collision(body: Node2D):	
	var player = body as Player;	
	if (!player):
		return;
	player.deal_damage(_damage);	
	_hit_timer = _hit_delay;
	
func flip_sprite():	
	if (abs(constant_force.angle_to(linear_velocity)) > PI / 2):
		return; # knocked back
	if (linear_velocity.x > 10):
		_sprite.flip_h = true;	
	else: if (linear_velocity.x < -10):
		_sprite.flip_h = false;

# returns xp gained
func inflictAttack(damage: float, knock_back: Vector2) -> float:	
	if (_health == 0):
		return 0; # prevent killing again (e.g. chain lightning)
	_health -= damage;
	if (_health <= 0):
		queue_free();	
		return _xp;
	apply_impulse(knock_back);	
	return 0;
	
