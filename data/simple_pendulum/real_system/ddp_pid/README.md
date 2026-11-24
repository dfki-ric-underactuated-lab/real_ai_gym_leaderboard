# DDP with PID Control

## Feasibility-driven Differential Dynamic Programming (FDDP)

Differential dynamic programming (DDP) is a trajectory optimization method which, similar to iLQR, iteratively improves a control sequence with a backward pass (computing a local quadratic model of the cost-to-go and the corresponding feedback gains) and a forward pass (rolling out the updated control sequence). In contrast to iLQR, DDP also uses the second order derivatives of the dynamics.
The feasibility-driven variant (FDDP) [(C. Mastalli, 2019)](https://arxiv.org/abs/1909.04947) allows infeasible (i.e. not dynamically consistent) initial guesses and closes the gaps between the shooting nodes during the optimization. The box-constrained version (BOXFDDP) additionally enforces the torque limits of the system. The implementation uses [Crocoddyl](https://github.com/loco-3d/crocoddyl) and [Pinocchio](https://github.com/stack-of-tasks/pinocchio).

The cost function for the **running model** is written as:

<img src="https://render.githubusercontent.com/render/math?math=l = {\sum}_{n=1}^{T-1} \alpha_n \Phi_n(q,\dot{q},\Tau),">

with the following costs:

1. _**Torque minimization**_: Minimization of the joint torques for realistic dynamic motions.

    <img src="https://render.githubusercontent.com/render/math?math=\Phi_{1} =  \parallel \Tau (t) \parallel ^{2}_2">

2. _**Posture regularization**_: giving as input only the final reference posture.

    <img src="https://render.githubusercontent.com/render/math?math=\Phi_{2} = \parallel q(t)-q^{ref}(t_{s-1})\parallel ^{2}_2">

The cost function for the **terminal model** is applied only to the terminal node:

<img src="https://render.githubusercontent.com/render/math?math=l_T =  \alpha_T \parallel q(T)-q^{ref}(T)\parallel^{2}_{2}">

The weights <img src="https://render.githubusercontent.com/render/math?math=\alpha_i"> for this optimization problem are determined experimentally.

## Proportional–Integral–Derivative (PID) Control

This controller is designed to follow a precomputed trajectory
 from of a csv file to the simulator or the real pendulum. Particulary, the controller can process trajectories that have been found with help of the [trajectory optimization](https://github.com/dfki-ric-underactuated-lab/torque_limited_simple_pendulum/tree/master/software/python/simple_pendulum/trajectory_optimization) methods.

The torque is processed by the PID control terms via (with feed forward torque):

<img src="https://render.githubusercontent.com/render/math?math=u(t) = \tau %2B K_p e(t) %2B K_i \int_0^t e(t') \text{d}t' %2B K_d \frac{\text{d}e(t)}{\text{d}t}">

where <img src="https://render.githubusercontent.com/render/math?math=\tau"> is the feed forward torque from the precomputed trajectory and <img src="https://render.githubusercontent.com/render/math?math=e(t)"> is the position error at timestep t.
