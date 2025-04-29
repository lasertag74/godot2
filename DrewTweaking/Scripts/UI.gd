extends CanvasLayer

var player_ref = null

func _ready() -> void:
	Global.ui = self

func _exit_tree() -> void:
	Global.ui = null

func _process(_delta):
	if player_ref and is_instance_valid(player_ref):
		$HealthLabel.text = "HP: %d" % player_ref.hp
