module parse.nodes.IfNode;
import parse.nodes.node;

class IfNode : Node
{
	Node cond;
	Node stmt;

	this(Node cond, Node stmt)
	{
		this.cond = cond;
		this.stmt = stmt;
	}

	override void print()
	{
		write("if( ");
		cond.print();
		write(" )\n");
		stmt.print();
	}
}