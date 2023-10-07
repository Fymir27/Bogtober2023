class_name Player extends CharacterBody2D

signal player_died;

@export var _speed : float;
@export var _hp_bar : ProgressBar;
@export var _sprite : Sprite2D;
@export var _hit_delay: float;

var hit_timer: float;


func _ready():
	hit_timer = _hit_delay;


func _process(delta):
	handle_input();
	flip_sprite();
	hit_timer -= delta;

func _physics_process(_delta):		
	if (hit_timer <= 0):
		hit_closest_enemy();
		hit_timer = _hit_delay;
	move_and_slide();
	
func handle_input():
	var direction = Vector2();
	if (Input.is_key_pressed(KEY_LEFT) || Input.is_key_pressed(KEY_A)):
		direction.x = -1;
	if (Input.is_key_pressed(KEY_RIGHT) || Input.is_key_pressed(KEY_D)):
		direction.x =  1;
	if (Input.is_key_pressed(KEY_UP) || Input.is_key_pressed(KEY_W)):
		direction.y = -1;
	if (Input.is_key_pressed(KEY_DOWN) || Input.is_key_pressed(KEY_S)):
		direction.y =  1;	
	var direction_norm = direction.normalized();
	velocity = direction_norm * _speed;
		
		
func flip_sprite():
	if (velocity.x > 0):
		_sprite.flip_h = true;	
	else: if (velocity.x < 0):
		_sprite.flip_h = false;

func deal_damage(amount: float):
	_hp_bar.value -= amount;
	if (_hp_bar.value <= 0):		
		player_died.emit();		

func hit_closest_enemy():
	var bodies_hit = $AttackRange.get_overlapping_bodies();
	var closest: Node2D;
	for body in bodies_hit:
		if (!closest || body.global_position.distance_to(global_position) < closest.global_position.distance_to(global_position)):
			closest = body;

	if (closest):
		$Weapon.attack(closest.global_position);	
	
