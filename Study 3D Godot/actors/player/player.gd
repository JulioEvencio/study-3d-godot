extends CharacterBody3D

@export var normal_speed := 3.0
@export var sprint_speed := 5.0
@export var jump_velocity := 4.0
@export var gravity := 0.2
@export var mouse_sensitivity := 0.005

@onready var head: Node3D = $Head
@onready var interaction_ray_cast: RayCast3D = $Head/InteractionRayCast

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_around(event.relative)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta: float) -> void:
	interaction_ray_cast.check_interaction()

func _physics_process(_delta: float) -> void:
	move()

func look_around(relative: Vector2) -> void:
	rotate_y(-relative.x * mouse_sensitivity)
	head.rotate_x(-relative.y * mouse_sensitivity)
	head.rotation_degrees.x = clampf(head.rotation_degrees.x, -90, 90)

func move() -> void:
	var is_sprinting: bool
	
	if is_on_floor():
		is_sprinting = Input.is_action_pressed("sprint")
		
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
	else:
		velocity.y -= gravity
		is_sprinting = false
	
	var speed := normal_speed if not is_sprinting else sprint_speed
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	move_and_slide()
