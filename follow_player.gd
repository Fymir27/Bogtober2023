class_name Follow extends CharacterBody2D

@export var _speed: float;	
@export var _target: Node2D;

func _ready():
	# print("Ready: " + str(name));
	pass;
	
func _physics_process(delta):
	var direction = _target.global_position - global_position;
	velocity = direction.normalized() * _speed;
	move_and_slide();
