module parse.nodes.MulNode;
import parse.nodes.node;
import parse.nodes.BinaryNode;

class MulNode : BinaryNode
{
	this(TokenLocation location, Node left, Node right)
	{
		super(location, left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" * ");
		right.print();
		write(" )");
	}
}