class_name EnemyAction

var action_selected: Callable
var amount: int
var target: Node2D

func _init(action: String, amt: int, tar: Node2D):
	action_selected = Callable(self, action)
	amount = amt
	target = tar

func damage():
	if target is Puppet or Enemy:
		target.character.attacked(amount)

func defend():
	if target is Puppet or Enemy:
		target.character.defense += amount
