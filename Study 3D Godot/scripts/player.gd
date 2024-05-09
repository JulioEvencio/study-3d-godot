extends CharacterBody3D
class_name Player

@onready var _head := get_node("Head")
@onready var _interaction_ray_cast := get_node("Head/InteractionRayCast")

var is_hitting := false

var _normal_speed := 3.0
var _sprint_speed := 5.0
var _speed := 3.0
var _jump_velocity := 6.0
var _gravity := 0.2
var _mouse_sensitivity := 0.002

func _input(event : InputEvent):
	if event is InputEventMouseMotion:
		_look_around(event.relative)

func _unhandled_key_input(event : InputEvent):
	if event.is_action_pressed("escape"):
		get_tree().quit()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta : float):
	_check_interaction()

func _physics_process(_delta : float) -> void:
	_move()

func _look_around(relative : Vector2) -> void:
	rotate_y(-relative.x * _mouse_sensitivity)
	_head.rotate_x(-relative.y * _mouse_sensitivity)
	_head.rotation_degrees.x = clampf(_head.rotation_degrees.x, -90, 90)

func _move() -> void:
	if not is_on_floor():
		velocity.y -= _gravity
	elif Input.is_action_just_pressed("jump"):
		velocity.y = _jump_velocity
	else:
		_speed = _sprint_speed if Input.is_action_pressed("sprint") else _normal_speed
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	velocity.x = direction.x * _speed
	velocity.z = direction.z * _speed
	
	move_and_slide()

func _check_interaction() -> void:
	if _interaction_ray_cast.is_colliding():
		var collider = _interaction_ray_cast.get_collider()
		
		if not collider is Interactable:
			return
		
		if Input.is_action_just_pressed("interact"):
			_interaction_ray_cast.get_collider().start_interaction()
		
		if not is_hitting:
			is_hitting = true
			EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.InteractionPrompt, collider.prompt)
	elif is_hitting:
		is_hitting = false
		EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.InteractionPrompt)
