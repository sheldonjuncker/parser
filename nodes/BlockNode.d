module parser.nodes.BlockNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

class BlockNode : Node
{
	Node[] stmts;

	this(TokenLocation location, Node[] stmts)
	{
		this.location = location;
		this.stmts = stmts;
	}

	override void print(int tabs=0)
	{
		writeln("{");
		
		foreach(Node node; stmts)
		{
			writeTabs("", tabs + 1);
			node.print(tabs + 1);
			write(";\n");
		}
		
		writeTabs("}", tabs);
	}
}