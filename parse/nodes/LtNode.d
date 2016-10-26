module parse.nodes.LtNode;
import parse.nodes.node;
import parse.nodes.BinaryNode;

class LtNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	

	override void print()
	{
		write("( ");
		left.print();
		write(" < ");
		right.print();
		write(" )");
	}
}