package stuff1;

public class MinusOperation extends CommonOperation implements OperationInterface{

	public MinusOperation(int operand1, int operand2) {
		super(operand1, operand2);
	}

	@Override
	public int execute() {
		return operand1 - operand2;
	}
}
