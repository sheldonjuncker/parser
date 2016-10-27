module parse.nodes.LteNode;
import parse.nodes.node;
import parse.nodes.BinaryNode;

class LteNode : BinaryNode
{
	this(TokenLocation location, Node left, Node right)
	{
		super(location, left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" <= ");
		right.print();
		write(" )");
	}
}