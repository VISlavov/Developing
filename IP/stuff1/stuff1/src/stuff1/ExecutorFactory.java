package stuff1;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ExecutorFactory {

    public static int executeCorrectOperation(int operand1, int operand2, String operation) {
        CommonOperation op = null;

        switch (operation) {
            case "+":
                op = new PlusOperation(operand1, operand2);
                break;
            case "-":
                op = new MinusOperation(operand1, operand2);
                break;
            case "/":
                op = new DivideOperation(operand1, operand2);
                break;
            case "*":
                op = new MultiplyOperation(operand1, operand2);
                break;
            default:
                break;
        }

        return op.execute();
    }

    public static String findNextOperation(List <String> args, int lastOperationIndex) {
        for (int i = lastOperationIndex; i <= args.size() - 1; i++) {
            if(!isNumeric(args.get(i))) {
                return args.get(i);
            }
        }
        return null;
    }

    public static int evaluateExpression(String[] args) {
        int currentExecutionResult = 0;
        List <String> argsAsList = new ArrayList <String> (Arrays.asList(args));
        String currentOperation = findNextOperation(argsAsList, 1);
        int indexOfCurrentOperation = argsAsList.indexOf(currentOperation);
        int resultIndex = 0;
        while(true) {
            if(resultIndex == indexOfCurrentOperation) {
                resultIndex = 0;
            }
            
            currentExecutionResult = Integer.parseInt(argsAsList.get(resultIndex));
            
            for (int i = resultIndex + 1; i < indexOfCurrentOperation; i++) {
                currentExecutionResult = executeCorrectOperation(currentExecutionResult, Integer.parseInt(argsAsList.get(i)), currentOperation);
            }
            
            applyEvaluationToArgs(argsAsList, resultIndex, indexOfCurrentOperation, currentExecutionResult);
            
            currentOperation = findNextOperation(argsAsList, resultIndex);
            if(currentOperation == null) {
                break;
            }
            
            resultIndex ++;
            indexOfCurrentOperation = argsAsList.indexOf(currentOperation);
            currentExecutionResult = 0;
        }

        return Integer.parseInt(argsAsList.get(0));
    }
    
    public static void applyEvaluationToArgs(List <String> args, int resultIndex, int operationIndex, int result) {
        for(int i = resultIndex; i <= operationIndex; i++) {
            args.remove(resultIndex);
        }
        args.add(resultIndex, result + "");
    }

    public static boolean isNumeric(String str) {
        try {
            double d = Double.parseDouble(str);
        } catch (NumberFormatException nfe) {
            return false;
        }
        return true;
    }

}
