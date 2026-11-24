# iLQR Model Predictive Control

## iLQR Model Predictive Control (MPC)

This controller uses the trajectory optimization from the iLQR algorithm in a model predictive control (MPC) setting. This means that the controller recomputes an optimal trajectory (including the optimal sequence of control inputs) over a finite horizon at every time step, starting from the currently measured state. The first control input of this solution is applied to the system. As initial guess for the optimization the solution of the previous timestep is used (warm start), so that only few iLQR iterations are necessary per control step. For real time capability the iLQR MPC controller is implemented in C++.

Because the trajectory is replanned at every time step, the controller can both swing up the pendulum and stabilize it at the upright position without switching to a separate stabilizing controller.

## iterative LQR (iLQR)

The [iterative linear quadratic regularizer (iLQR)](https://ieeexplore.ieee.org/abstract/document/6907001) is an extension of the LQR controller. The LQR controller linearizes the dynamics at a given state and and assumes that these linear dynamics are valid at every other system state as well. In contrast to that, the iLQR optimization method has the ability to take the full system dynamics into account and plan ahead by optimizing over a sequence of control inputs.

The algorithm can be described as:

1. Set an initial state <img src="https://render.githubusercontent.com/render/math?math=x_0"> and an initial control sequence <img src="https://render.githubusercontent.com/render/math?math=\mathbf{U} = [u_0, u_1, ..., u_{N-1}]">, where <img src="https://render.githubusercontent.com/render/math?math=N"> is the number of steps that will optimized over (the time horizon).
2. Rollout the trajectory by applying the control sequence iteratively to the initial state.

The following steps are repeated until convergence:

3. Backward pass: Compute the derivatives of the cost function and the gains for the control sequence
4. Forward pass: Update the control sequence with the computed gains and rollout the new trajectory with the new control sequence. If the cost of the new trajectory is smaller than before, carry over the new control sequence and increase the gain factor. If not, keep the old trajectory and decrease the gain factor.

If the cost is below a specified threshold the algorithm stops.
