<div align="center">
<img width="250" src="https://raw.githubusercontent.com/dfki-ric-underactuated-lab/real_ai_gym_leaderboard/main/data/pendubot/simulation_icra2025/vimppi/sim_video.gif">
<img width="250" src="https://raw.githubusercontent.com/dfki-ric-underactuated-lab/real_ai_gym_leaderboard/main/data/pendubot/simulation_icra2025/areapo/sim_video.gif">
<img width="250" src="https://raw.githubusercontent.com/dfki-ric-underactuated-lab/real_ai_gym_leaderboard/main/data/pendubot/simulation_icra2025/acados_mpc/sim_video.gif">
<img width="250" src="https://raw.githubusercontent.com/dfki-ric-underactuated-lab/real_ai_gym_leaderboard/main/data/pendubot/simulation_icra2025/mcpilco/sim_video.gif">
<figcaption>Videos from left to right: VIMPPI, AR_EAPO, Acados MPC, MC-PILCO</figcaption>
</div>

## Rules

This leaderboard shows the simulation results from the RealAIGym competition at ICRA
2025.
The simulation leaderboard tests the global coverage of the double pendulums
state space of different control methods in simulation. The task for the
controller is to swingup and balance the pendubot and keep the end-effector
above the threshold line. At random times during the execution, the pendulum is
reset to a new initial state.

The model parameters of the pendubot are:

  - Gravity: $g = 9.81 \, \frac{\text{m}}{\text{s}^2}$
  - First Link mass: $m_1 = 0.5234602302310271 \, \text{kg}$
  - Second Link mass: $m_2 = 0.6255677234174437 \, \text{kg}$
  - First actuator length: $l_1 = 0.2 \, \text{m}$
  - Second actuator length: $l_2 = 0.3 \, \text{m}$
  - First link center of mass: $r_1 = 0.2 \, \text{m}$
  - Second link center of mass: $r_2: 0.25569305436052964 \, \text{m}$
  - First link inertia: $I_1 = 0.031887199591513114 \, \text{kg m}^2$
  - Second link inertia: $I_2 = 0.05086984812807257 \, \text{kg m}^2$
  - First actuator damping friction: $b_1 = 0.0 \, \frac{\text{kg m}}{s}$
  - Second actuator damping friction: $b_2 = 0.0 \, \frac{\text{kg m}}{s}$
  - First actuator coulomb friction: $c_{f1}: 0.0 \, \text{N m}$
  - Second actuator coulomb friction: $c_{f2}: 0.0 \, \text{N m}$
  - Motor Inertia: $I_r = 0.0 \, \text{kg m}^2$
  - Gear ratio: $g_r: 6.0$
  - First Motor Torque limit $\tau_{max1} = 0.0 \, \text{N m}$
  - Second Motor Torque limit $\tau_{max2} = 6.0 \, \text{N m}$

More information about the dynamic model of the double pendulum can be found
here: [Double Pendulum
Dynamics](https://dfki-ric-underactuated-lab.github.io/double_pendulum/dynamics.html).
In the [Double Pendulum
Repository](https://github.com/dfki-ric-underactuated-lab/double_pendulum) the
parameters above are labeled as 'designC.1/model1.1'.
For a urdf file with this model see here:
[URDF](https://github.com/dfki-ric-underactuated-lab/double_pendulum/tree/main/data/system_identification/identified_parameters/design_C.1/model_1.1).

The pendubot is simulated with a Runge-Kutta 4 integrator with a timestep of $dt
= 0.002 \, \text{s}$ for $T = 60 \, \text{s}$. The initial pendubot
configuration is $x_0 = (0, 0, 0, 0)$ (hanging down) and the goal is the
unstable fixpoint at the upright configuration $x_g = (\pi, 0, 0, 0)$. The
upright position is considered to be reached when the end-effector is above the
threshold line at $h=0.45 \, \text{m}$ (origin at the mounting point) and stays
there until the end. At 15 random times during the execution the controller is
switched off for 0.2s and the pendulum is reset to a new initial state. After
the reset the controller is switched on again and the controller is supposed to
swing the pendulum up from the new initial state.
The leaderboard was evaluated with the numpy random seed 333.

## Scores

The score is the time the pendulum spends in the goal region divided by the
total runtime.

## Participating

This leaderboard is only for the results from the competition at ICRA 2025. For
participating checkout the [ongoing
leaderboard](https://dfki-ric-underactuated-lab.github.io/real_ai_gym_leaderboard/pendubot_real_system_perturbation_leaderboard_v2.html)
