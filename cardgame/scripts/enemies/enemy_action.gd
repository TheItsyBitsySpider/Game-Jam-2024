class_name EnemyAction

var action: Callable
var amount: int
var target: Node2D
var stats: Character

func _init(action: String, amount: int, target: Node2D, stats: Character):
	self.action = Callable(self, action)
	self.amount = amount
	self.target = target
	self.stats = stats

func attack():
	if target is Puppet or Enemy:
		stats.sprite.position.x = -48
		if stats.weak > 0:
			amount = ceil(amount * .75)
		target.character.hit(amount + stats.strength)

func defend():
	if target is Puppet or Enemy:
		target.character.defense += amount

func buff_attack():
	if target is Puppet or Enemy:
		target.character.strength += amount

func debuff_vuln_weak():
	if target is Puppet or Enemy:
		target.character.weak += amount
		target.character.vulnerable += amount
