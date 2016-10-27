module parser.nodes.node;
import lexer.token;
import semantic.info;

/**
* Represents a node of the AST.
*/
class Node
{
	///The location of the node
	TokenLocation location;

	///Semantic info about the node
	SemanticInfo semInfo;

	/**
	* Prints out a representation of a node.
	* Used in debugging to make sure that precedence was matched correctly.
	*/
	void print()
	{
		
	}
}