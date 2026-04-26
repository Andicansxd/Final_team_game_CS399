class_name heal extends Move

@export var heal_amount: float

func apply_change(owner: Battler, targets: Array[Battler]):
	for battler in targets:
		battler.heal(heal_amount)