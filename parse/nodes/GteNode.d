module parse.nodes.GteNode;
import parse.nodes.node;
import parse.nodes.BinaryNode;

class GteNode : BinaryNode
{
	this(TokenLocation location, Node left, Node right)
	{
		super(location, left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" >= ");
		right.print();
		write(" )");
	}
}