extends Control
@export  var linked_node: Node = null
var valid_node: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if linked_node != null:
		if linked_node.has_signal("health_updated"):
			linked_node.health_updated.connect(_on_health_updated)
			valid_node = true
		if valid_node == true:
			#place code to get health value
			$ProgressBar.set_value(linked_node.health)
			pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_health_updated():
	$ProgressBar.set_value(linked_node.health)
