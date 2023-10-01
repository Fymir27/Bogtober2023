class_name Enemy extends CharacterBody2D

@export var _speed: float;	
@export var _damage: float;
@export var _target: Node2D;

func _ready():
	# print("Ready: " + str(name));
	pass;
	
func _physics_process(delta):
	var direction = _target.global_position - global_position;
	velocity = direction.normalized() * _speed;
	move_and_slide();
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i);
		handle_collision(collision);
	
	
func handle_collision(collision: KinematicCollision2D):	
	var player = collision.get_collider() as Player;	
	#print(player);
	player._hp_bar.value -= _damage;
	queue_free();
