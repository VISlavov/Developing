package stuff1;

public class PlusOperation extends CommonOperation implements OperationInterface{

	public PlusOperation(int operand1, int operand2) {
		super(operand1, operand2);
	}

	@Override
	public int execute() {
		return operand1 + operand2;
	}
	
}
