# Graph Search Controller

## Graph Search Controller

This controller computes a policy by searching for shortest paths in a graph which represents the discretized state space of the pendulum.

1. The state space <img src="https://render.githubusercontent.com/render/math?math=x = [\theta, \dot{\theta}]"> is discretized into a grid with a fixed position resolution (here 1 deg) and velocity resolution (position resolution divided by the graph timestep). The grid points are the nodes of the graph.
2. Two nodes are connected with an edge if the pendulum can move from one node to the other within one graph timestep while respecting the dynamics and the torque limit of the system. The torque which is necessary for this transition is stored with the edge and the edge cost encodes e.g. the required time/torque.
3. [Dijkstra's algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) is used to find the shortest paths from every node to the goal node <img src="https://render.githubusercontent.com/render/math?math=x_{goal} = [\pi, 0]">.

The result is a lookup table which stores for every node the next node on the shortest path and the corresponding torque. During execution the measured state is rounded to the nearest grid point and the torque from the lookup table is applied (with an additional compensation of the coulomb friction).
As the policy is defined in the whole (discretized) state space, the same controller performs the swingup and the stabilization at the upright position.
