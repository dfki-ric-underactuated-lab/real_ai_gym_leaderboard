# DDP with TVLQR and LQR

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

## Time-varying Linear Quadratic Regulator (TVLQR)

This controller is designed to follow a precomputed trajectory
 from of a csv file to the simulator or the real pendulum. Particulary, the controller can process trajectories that have been found with help of the [trajectory optimization](https://github.com/dfki-ric-underactuated-lab/torque_limited_simple_pendulum/tree/master/software/python/simple_pendulum/trajectory_optimization) methods.

The Time-varying Linear Quadratic Regulator (TVLQR) is an extension to the regular [LQR controller](https://github.com/dfki-ric-underactuated-lab/torque_limited_simple_pendulum/tree/master/software/python/simple_pendulum/controllers/lqr). The LQR formalization is used for a time-varying linear dynamics function

<img src="https://render.githubusercontent.com/render/math?math=\dot{\mathbf{x}} =  \mathbf{A}(t)\mathbf{x} %2B \mathbf{B}(t)\mathbf{u}">

The TVLQR controller tries to stabilize the system along a nominal trajectory. For this, at every timestep the system dynamics are linearized around the state of the nominal trajectory <img src="https://render.githubusercontent.com/render/math?math=\mathbf{x}_0(t), \mathbf{u}_0(t)"> at the given timestep <img src="https://render.githubusercontent.com/render/math?math=t">. The LQR formalism then can be used to derive the optimal controller at timestep <img src="https://render.githubusercontent.com/render/math?math=t">:

<img src="https://render.githubusercontent.com/render/math?math=u(\mathbf{x}) = \mathbf{u}_0(t) - \mathbf{K}(t) \left( \mathbf{x} - \mathbf{x}_0(t)\right)">

For further reading, we recommend chapter 8 of this [Underactuated Robotics](http://underactuated.mit.edu/) lecture.

## LQR Controller

A linear quadratic regulator (LQR) can be used to stabilize the pendulum at the unstable fixpoint. For a linear system of the form

<img src="https://render.githubusercontent.com/render/math?math=\dot{\mathbf{x}} =  \mathbf{A}\mathbf{x} %2B \mathbf{B}\mathbf{u}">

and a infinite horizon cost function in quadratic form:

<img src="https://render.githubusercontent.com/render/math?math=J = \int_0^{\infty} \left( \mathbf{x}^T \mathbf{Q}\mathbf{x} %2B \mathbf{u}^T \mathbf{R} \mathbf{u} \right)\text{d}t, \quad \mathbf{Q} = \mathbf{Q} \succeq 0, \, \mathbf{R} = \mathbf{R} \succeq 0">

the (provably) optimal controller is

<img src="https://render.githubusercontent.com/render/math?math=u(\mathbf{x}) = -\mathbf{R}^{-1}\mathbf{B}^{T}\mathbf{S} \mathbf{x} = -\mathbf{K} \mathbf{x}">

where <img src="https://render.githubusercontent.com/render/math?math=\mathbf{S}"> has to fulfill the algebraic Riccati equation

<img src="https://render.githubusercontent.com/render/math?math=\mathbf{SA} %2B \mathbf{A}^{T}\mathbf{S} - \mathbf{SBR}^{-1}\mathbf{B}\mathbf{S} %2B \mathbf{Q} = 0.">

There are many solvers for the algebraic Riccati equation. In this library the solver from the scipy package is used.
