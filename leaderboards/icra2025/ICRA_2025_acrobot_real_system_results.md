<div align="center">
<img width="350" src="https://raw.githubusercontent.com/dfki-ric-underactuated-lab/real_ai_gym_leaderboard/main/data/acrobot/real_system_icra2025/acados_mpc/experiment01/video.gif">
<img width="350" src="https://raw.githubusercontent.com/dfki-ric-underactuated-lab/real_ai_gym_leaderboard/main/data/acrobot/real_system_icra2025/ar_eapo/experiment01/video.gif">
<img width="350" src="https://raw.githubusercontent.com/dfki-ric-underactuated-lab/real_ai_gym_leaderboard/main/data/acrobot/real_system_icra202/mcpilco/experiment01/video.gif">
<img width="350" src="https://raw.githubusercontent.com/dfki-ric-underactuated-lab/real_ai_gym_leaderboard/main/data/acrobot/real_system_icra202/vimppi/experiment01/video.gif">
<figcaption>Videos from left to right: Acados_MPC, AR_EAPO, MCPILCO, VIMPPI</figcaption>
</div>


## Rules

This leaderboard shows the final results from the RealAIGym competition at ICRA
2025.

The simulation leaderboard tests the global coverage of the double pendulums
state space of different control methods in simulation. The task for the
controller is to swingup and balance the acrobot and keep the end-effector
above the threshold line. At random times during the execution, the pendulum is
reset to a new initial state.

The model parameters identified by us with a least squares optimization of the
acrobot are:

  - Gravity: $g = 9.81 \, \frac{\text{m}}{\text{s}^2}$
  - First Link mass: $m_1 = 0.523 \, \text{kg}$
  - Second Link mass: $m_2 = 0.625 \, \text{kg}$
  - First actuator length: $l_1 = 0.2 \, \text{m}$
  - Second actuator length: $l_2 = 0.3 \, \text{m}$
  - First link center of mass: $r_1 = 0.2 \, \text{m}$
  - Second link center of mass: $r_2: 0.255 \, \text{m}$
  - First link inertia: $I_1 = 0.031 \, \text{kg m}^2$
  - Second link inertia: $I_2 = 0.050 \, \text{kg m}^2$
  - First actuator damping friction: $b_1 = 0.001 \, \frac{\text{kg m}}{s}$
  - Second actuator damping friction: $b_2 = 0.001 \, \frac{\text{kg m}}{s}$
  - First actuator coulomb friction: $c_{f1}: 0.16 \, \text{N m}$
  - Second actuator coulomb friction: $c_{f2}: 0.12 \, \text{N m}$
  - Motor Inertia: $I_r = 6.28e-05 \, \text{kg m}^2$
  - Gear ratio: $g_r: 6.0$
  - First Motor Torque limit $\tau_{max1} = 0.0 \, \text{N m}$
  - Second Motor Torque limit $\tau_{max2} = 6.0 \, \text{N m}$

More information about the dynamic model of the double pendulum can be found
here: [Double Pendulum
Dynamics](https://dfki-ric-underactuated-lab.github.io/double_pendulum/dynamics.html).
For a urdf file with this model see here: [URDF](https://github.com/dfki-ric-underactuated-lab/double_pendulum/tree/main/data/system_identification/identified_parameters/design_C.1/model_1.0).

The $0.5\,\text{Nm}$ torque limit on the passive joint can be used to compensate the
friction of the motor.

The actuators can be controlled with arbitrary control frequency of up to $500\, \text{Hz}$
and the experiment takes $10\,\text{s}$.
The initial acrobot configuration
is $x_0 = (0, 0, 0, 0)$ (hanging down) and the goal is the unstable
fixpoint at the upright configuration $x_g = (\pi, 0, 0, 0)$.
The upright position is considered to be reached when the end-effector is above
the threshold line at $h=0.45 \, \text{m}$ (origin at the mounting point).

## Scores

The scores are the fraction of the 60s runtime that the pendulum is in the goal
region, i.e. above the threshold line.

## Participating

This leaderboard is only for the results from the competition at ICRA 2025. For
participating checkout the [ongoing
leaderboard](https://dfki-ric-underactuated-lab.github.io/real_ai_gym_leaderboard/acrobot_real_system_perturbation_leaderboard_v2.html)
