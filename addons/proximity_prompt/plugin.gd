@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("ProximityPrompt3D", "Sprite3D", preload("3D/proximity_prompt_3d.gd"), preload("3D/proximity_prompt_3d.png"))


func _exit_tree():
	remove_custom_type("ProximityPrompt3D")
