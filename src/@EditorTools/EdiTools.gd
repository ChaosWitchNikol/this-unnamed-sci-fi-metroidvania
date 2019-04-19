extends Object
class_name EdiTools

var SmallBitFont = load("res://@EditorTools/SmallNumBit.ttf")





class OrderPrioritySorterer:
	static func sort(a, b):
		return a.order_priority > b.order_priority
static func sort_node_by_order_priority(nodes : Array) -> Array:
	nodes.sort_custom(OrderPrioritySorterer, "sort")
	return nodes


static func node_array_to_string(nodes : Array) -> String:
	var nodes_string = ""
	
	for node in nodes:
		nodes_string += node.name
	
	return nodes_string