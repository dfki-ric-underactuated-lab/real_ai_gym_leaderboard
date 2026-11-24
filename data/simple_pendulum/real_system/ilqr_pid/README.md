# iterative LQR with PID Control

## iterative LQR (iLQR)

The [iterative linear quadratic regularizer (iLQR)](https://ieeexplore.ieee.org/abstract/document/6907001) is an extension of the LQR controller. The LQR controller linearizes the dynamics at a given state and and assumes that these linear dynamics are valid at every other system state as well. In contrast to that, the iLQR optimization method has the ability to take the full system dynamics into account and plan ahead by optimizing over a sequence of control inputs.

The algorithm can be described as:

1. Set an initial state <img src="https://render.githubusercontent.com/render/math?math=x_0"> and an initial control sequence <img src="https://render.githubusercontent.com/render/math?math=\mathbf{U} = [u_0, u_1, ..., u_{N-1}]">, where <img src="https://render.githubusercontent.com/render/math?math=N"> is the number of steps that will optimized over (the time horizon).
2. Rollout the trajectory by applying the control sequence iteratively to the initial state.

The following steps are repeated until convergence:

3. Backward pass: Compute the derivatives of the cost function and the gains for the control sequence
4. Forward pass: Update the control sequence with the computed gains and rollout the new trajectory with the new control sequence. If the cost of the new trajectory is smaller than before, carry over the new control sequence and increase the gain factor. If not, keep the old trajectory and decrease the gain factor.

If the cost is below a specified threshold the algorithm stops.

## Proportional–Integral–Derivative (PID) Control

This controller is designed to follow a precomputed trajectory
 from of a csv file to the simulator or the real pendulum. Particulary, the controller can process trajectories that have been found with help of the [trajectory optimization](https://github.com/dfki-ric-underactuated-lab/torque_limited_simple_pendulum/tree/master/software/python/simple_pendulum/trajectory_optimization) methods.

The torque is processed by the PID control terms via (with feed forward torque):

<img src="https://render.githubusercontent.com/render/math?math=u(t) = \tau %2B K_p e(t) %2B K_i \int_0^t e(t') \text{d}t' %2B K_d \frac{\text{d}e(t)}{\text{d}t}">

where <img src="https://render.githubusercontent.com/render/math?math=\tau"> is the feed forward torque from the precomputed trajectory and <img src="https://render.githubusercontent.com/render/math?math=e(t)"> is the position error at timestep t.
