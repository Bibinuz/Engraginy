class_name Materials extends Resource


@export var name : String
@export var max_stack : int
@export var is_flamable : bool
@export var energy : float

@export var icon : Image

var amount: int = 0

func add(n: int, is_node: bool = false, purity: ResourceNode.Purity = ResourceNode.Purity.IMPURE) -> int:
	amount += n *(1+(int(is_node)*purity))
	if amount > max_stack:
		var left_amount: int = amount-max_stack
		amount = max_stack
		return left_amount
	return 0
