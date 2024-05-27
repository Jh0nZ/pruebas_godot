extends RigidBody3D

var mouseSensitivity := 0.001
var twistInput := 0.0
var pitchInput := 0.0

@onready var twistPivot = $twistPivot
@onready var pitchPivot = $twistPivot/pitchPivot

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("mode_forward", "move_back")
	apply_central_force(twistPivot.basis * input * 1200 * delta)
	#var input = Input.get_action_strength("ui_up")
	#apply_central_force(input * Vector3.FORWARD * 1200.0 * delta)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	twistPivot.rotate_y(twistInput)
	pitchPivot.rotate_x(pitchInput)
	pitchPivot.rotation.x = clamp(
		pitchPivot.rotation.x,
		deg_to_rad(-30),
		deg_to_rad(30)
	)
	twistInput = 0.0
	pitchInput = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twistInput = -event.relative.x * mouseSensitivity
			pitchInput = -event.relative.y * mouseSensitivity
