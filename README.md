# Four Buttons Riddle

## Description
The "Four Buttons Riddle" is a classic logic puzzle where you're presented with a table containing four buttons positioned around a central light. The objective is to bring all the buttons to the same state, either all on or all off. However, pressing any button causes the entire table to rotate by 90, 180, 270, or 360 degrees, potentially altering the button arrangement.

## Implementation
### Verilog Code
The provided Verilog code simulates the logic of the puzzle. It consists of three classes:

1. `buttons`: Represents the state of the buttons on the table. Each button has a random state (ON or OFF) and a function to display the current state.

2. `rotation`: Represents the rotation angle of the table. It ensures that the angle is restricted to 90, 180, 270, or 360 degrees.

3. `game`: Orchestrates the game's logic. It initializes the button states and rotation, runs the game, and simulates the button presses and table rotations until all buttons are in the same state.

### Execution
The `tb` module instantiates the `game` class and initiates the game simulation. The `run` task controls the game flow, while the `solve_problem` function iteratively attempts to solve the puzzle by toggling specific button combinations and checking if all buttons are in the same state. If not, it rotates the table and tries again until success.

## How to Use
1. Compile the Verilog code using a suitable compiler.
2. Run the simulation to observe the game execution.
3. Analyze the output to understand the button states and table rotations at each step.
4. Try modifying the code to experiment with different game strategies or optimizations.
