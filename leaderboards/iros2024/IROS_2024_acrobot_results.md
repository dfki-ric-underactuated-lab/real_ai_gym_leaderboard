<div align="center">
<img width="400" src="https://raw.githubusercontent.com/dfki-ric-underactuated-lab/real_ai_gym_leaderboard/main/data/acrobot/real_system_iros2024/mcpilco/experiment07/video.gif">
<figcaption>Videos from left to right: MC-PILCO</figcaption>
</div>


## Rules

This leaderboard shows the final results from the RealAIGym competition at IROS
2024.

The real system leaderboard compares the performance of different control
methods on the real hardware. The task for the controller is to swingup and balance
the acrobot and keep the end-effector above the threshold line.

During the execution external perturbations in the form of Gaußian torque peaks
have been applied by the motors at both links. In total there were 4
perturbations, 2 at each joint, with a standard deviation between 0.05s and
0.1s and an amplitude between 0.5Nm and 0.75Nm. The perturbations were randomly
generated and different in all 10 trials. The perturbations are the same for
all controllers.

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

For the evaluation multiple criteria are evaluated and weighted to calculate an
overall score (Real AI Score). The criteria are:

  - **Swingup Success** $c_{success}$: Whether the swingup was successful, i.e. if the
    end-effector is above the threshold line in the end of the simulation.
  - **Swingup time** $c_{time}$: The time it takes for the acrobot to reach the goal region
    above the threhhold line and *stay there*. If the end-effector enters the
    goal region but falls below the line before the simulation time is over the
    swingup is not considered successful! The swingup time is the time when the
    end-effector enters the goal region and does not leave the region until the end.
  - **Energy** $c_{energy}$: The mechanical energy used during the execution. 
  - **Torque Cost** $c_{\tau, cost}$: A quadratic cost on the used torques ( $c_{\tau, cost} = \sum u^TRu$, with R
    = 1).
  - **Torque Smoothness** $c_{\tau, smooth}$: The standard deviation of the changes in the torque
    signal.
  - **Velocity Cost** $c_{vel, cost}$: A quadratic cost on the joint velocities that were reached
    during the execution ( $c_{vel} = \dot{q}^T Q \dot{q}$, with Q = identity)

These criteria are used to calculate the overall Real AI Score with the formula

$$
\begin{equation}
S = c_{success} \left( 1 -
\sum_{i \in \{ 'time', 'energy', '\tau, cost', '\tau, smooth', 'vel, cost' \}}
\tanh \left(\frac{c_{i}}{n_{i}}\right)\right)
\end{equation}
$$

The weights and normalizations are:

| Criterion         | normalization $n$ |
| ------------------|-------------------|
| Swingup Time      | 20.0              |
| Energy            | 60.0              |
| Torque Cost       | 100               |
| Torque Smoothness | 4.0               |
| Velocity Cost     | 400.0             |

The listed number for swingup time, energy, etc. in the leaderboard are the
scores for from the best attempt. The 'Best RealAIScore' is the score of that
attempt. The 'Average RealAIScore' is the average score over 10 attempts.
Unsuccessful swingups (where the end effector is not above the threshhold line
in the end of the experiment (i.e. after $10\,\text{s}$)) have a score of 0. 

## Participating

This leaderboard is only for the results from the competition at IROS 2024. For
participating checkout the [ongoing
leaderboard](https://dfki-ric-underactuated-lab.github.io/real_ai_gym_leaderboard/acrobot_real_system_perturbation_leaderboard_v2.html)
