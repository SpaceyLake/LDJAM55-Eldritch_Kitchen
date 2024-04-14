extends State
class_name WalkState

@export var character: Entity
@export var speed = 100.0
@export var nav_agent: NavigationAgent2D

var type: Interaction.types
var station: Node2D

func enter(_msg := {}):
	nav_agent.target_position = _msg["target"] 
	type = _msg["type"]
	station = _msg["station"]
	if !nav_agent.navigation_finished.is_connected(_on_finished):
		nav_agent.navigation_finished.connect(_on_finished)

func physics_update(_delta:float):
	var dir = character.to_local(nav_agent.get_next_path_position()).normalized()
	character.velocity = dir * speed
	
	character.human_renderer.update_direction(character.velocity.normalized())
	
	character.move_and_slide()

func _on_finished():
	character.human_renderer.update_direction(Vector2.ZERO)
	nav_agent.velocity = Vector2.ZERO
	if type == character.INTERACTION.LEAVE:
		character.queue_free()
	else:
		state_machine.transition_to("InteractState", { "type": type, "station": station })
