module parser.nodes.IfNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

class IfNode : Node
{
	Node cond;
	Node stmt;

	this(TokenLocation location, Node cond, Node stmt)
	{
		this.location = location;
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