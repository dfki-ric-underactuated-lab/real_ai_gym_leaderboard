## Rules

The robustness leaderboard compares the performance of different control
methods by perturbing the simulation e.g. with noise or delay. The task for the
controller is to swingup and balance the pendubot even with these perturbations.

<div align="center">
<img width="400" src="https://raw.githubusercontent.com/dfki-ric-underactuated-lab/real_ai_gym_leaderboard/main/data/pendubot/robustness_v2/ilqr_ilqrmpc_lqr/score_plot.png">
</div>

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
For a urdf file with this model see here: [URDF](https://github.com/dfki-ric-underactuated-lab/double_pendulum/tree/main/data/system_identification/identified_parameters/design_C.1/model_1.1).

The pendubot is simulated with a Runge-Kutta 4 integrator with a timestep of $dt
= 0.002 \, \text{s}$ for $T = 10 \, \text{s}$. The initial pendubot configuration
is $x_0 = (0.0, 0.0, 0.0, 0.0)$ (hanging down) and the goal is the unstable
fixpoint at the upright configuration $x_g = (\pi, 0.0, 0.0, 0.0)$.
The upright position is considered to be reached when the end-effector is above
the threshold line at $h=0.45 \, \text{m}$ (origin at the mounting point) and
stays there until the end.

## Scores

For the evaluation multiple criteria are evaluated and weighted to calculate an
overall score (Real AI Score). The criteria are:

  - **Model inaccuracies** $c_{model}$: The model parameters, that have been determined with
    system identification, will never be perfectly accurate. To asses
    inaccuracies in these parameters, we vary the independent model parameters
    one at the time in the simulator while using the original model parameters in
    the controller.
  - **Measurement noise** $c_{vel, noise}$: The controllers' outputs depend on the measured system
    state.  In the case of the QDDs, the online velocity measurements are noisy.
    Hence, it is important for the transferability that a controller can handle
    at least this amount of noise in the measured data.  The controllers are
    tested with and without a low-pass noise filter.
  - **Torque noise** c_{\tau, noise}$: Not only the measurements are noisy, but also the torque that
    the controller outputs is not always exactly the desired value. 
  - **Torque response** $c_{\tau, response}$: The requested torque of the controller will in general not
    be constant but change during the execution. The motor, however, is sometimes
    not able to react immediately to large torque changes and will instead
    overshoot or undershoot the desired value.  This behavior is modelled by
    applying the torque $\tau = \tau_{t-1} + k_{resp} (\tau_{des} -
    \tau_{t-1})$ instead of the desired torque $\tau_{des}$.  Here,
    $\tau_{t-1}$ is the applied motor torque from the last time step and
    $k_{resp}$ is the factor which scales the responsiveness.
    $k_{resp} = 1$ means the torque response is perfect while
    $k_{resp} \neq 1$ means the motor is over/undershooting the desired
    torque. 
  - **Time delay** $c_{delay}$: When operating on a real system there will always be time delays
    due to communication and reaction times. 
  - **Random Perturbations** $c_{pert}$: A randomly generated sequence of
    Gaußian perturbations is added to the applied torque.

For each criterion the quantities are varied in $N=21$ steps (for the model
inaccuracies for each independent model parameter) and the score is the
percentage of successful swingups. 50 random perturbations profiles are
generated and evaluated.

These criteria are used to calculate the overall Real AI Score with the formula

$$
S = \frac{1}{6} \left(
    c_{model} + 
    c_{vel, noise} +  
    c_{\tau, noise} +  
    c_{\tau, response} +  
    c_{delay} + 
    c_{pert} \right)
$$

## Participating

If you want to participate in this leaderboard with your own controller have a
look at the [leaderboard
explanation](https://github.com/dfki-ric-underactuated-lab/double_pendulum/tree/main/leaderboard/robustness/pendubot)
in the double pendulum repository.  The leaderboard is automatically
periodically updated based on the controllers that have been contributed to that
repository.
