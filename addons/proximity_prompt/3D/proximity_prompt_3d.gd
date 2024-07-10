extends Sprite3D

enum ActivationType {
	Click, ## Activated by clicking
	KeyPress,  ## Activated by pressing the activation key
	Both, ## Activated by clicking, or a key press
	}

## The node that is required to be near the prompt to be functional.
@export var activation_node: Node3D

## The maximimum distance the activation node can be from the Proximity Prompt
@export var max_distance: float

## Activated by clicking, or an activation key.
@export var activation_type: ActivationType = ActivationType.Both

## Make sure to set this if you use requires_facing or requires_direct_look
@export var line_of_sight_node: Node3D

## The key to press which makes activates the Prompt.
@export var activation_key: Key = KEY_E

## Requires the proximity prompt to be visible to activate
@export var requires_facing: bool = true

## The tolerance for how forgiving the line of sight is.
@export var los_threshold: float = 0.5

## Requires you to look directly at the prompt to activate it
@export var requires_direct_look: bool = false

signal triggered

var distance: float
var can_interact: bool = false

func _process(delta):
	if activation_node:
		distance = activation_node.global_position.distance_to(global_position)
			
		can_interact = check_can_interact()
			
		visible = distance <= max_distance
		
func handle_activation():
	if not can_interact:
		return
	triggered.emit()

func check_can_interact() -> bool:
		if distance <= max_distance:
			if requires_facing and is_facing(line_of_sight_node):
				return true
			
		return false

func is_facing(target: Node3D, object: Node3D = self, threshold: float = los_threshold) -> bool:
	var target_forward = -target.global_transform.basis.z
	var direction_to_object = (object.global_transform.origin - target.global_transform.origin).normalized()
	var dot_product = target_forward.dot(direction_to_object)
	#print("Direction to Object: ", direction_to_object)
	return dot_product >= threshold

func _input(event):
	if event is InputEventMouseButton:
		if event.button_mask == MOUSE_BUTTON_LEFT:
			if activation_type == ActivationType.Click or ActivationType.Both:
				handle_activation()
	if event is InputEventKey:
		if event.keycode == activation_key:
			if activation_type == ActivationType.KeyPress or ActivationType.Both:
				handle_activation()
