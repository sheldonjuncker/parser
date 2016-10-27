module parse.nodes.AndNode;
import parse.nodes.node;
import parse.nodes.BinaryNode;

class AndNode : BinaryNode
{
	this(TokenLocation location, Node left, Node right)
	{
		super(location, left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" && ");
		right.print();
		write(" )");
	}
}