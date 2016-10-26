module parse.nodes.WhileNode;
import parse.nodes.node;

class WhileNode : Node
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
		write("while( ");
		cond.print();
		write(" )\n");
		stmt.print();
	}
}