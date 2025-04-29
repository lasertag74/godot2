extends Area2D

export var heal_amount = 25

func _ready():
	set_process(false)
	set_physics_process(false)
	# Optional: play idle animation or bobbing

func _on_HealthPack_body_entered(body):
	if get_tree().is_network_server():
		if body.is_in_group("Player"):
			# Award healing on server only
			body.rpc("heal_from_pack", heal_amount)
			rpc("destroy")

sync func destroy():
	queue_free()
