class_name EnemyAction

var action: Callable
var amount: int
var target: Node2D

func _init(action: String, amount: int, target: Node2D):
	self.action = Callable(self, action)
	self.amount = amount
	self.target = target

func attack():
	if target is Puppet or Enemy:
		target.character.hit(amount)

func defend():
	if target is Puppet or Enemy:
		target.character.defense += amount
