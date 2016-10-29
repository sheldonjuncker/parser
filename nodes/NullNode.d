module parser.nodes.NullNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

/**
* The null node represents a node that has been removed from the AST.
*/
class NullNode : Node
{
	override bool isNull()
	{
		return true;
	}
}