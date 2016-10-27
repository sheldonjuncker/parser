module parse.nodes.BinaryNode;
import parse.nodes.node;

class BinaryNode : Node
{
	Node left;
	Node right;

	this(TokenLocation location, Node left, Node right)
	{
		this.location = location;
		this.left = left;
		this.right = right;
	}
}