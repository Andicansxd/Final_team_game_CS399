class_name Attack extends Move

@export var base_damage: float

func apply_change(owner: Battler, targets: Array[Battler]):
	print("help")
	for battler in targets:
		battler.damage(base_damage * owner.strength)