# Crowd Simulator 
# [About](https://ruichenhe.github.io/crowdSimulator/)
A course project for *CSCI 5611: Animation and Planning in Games*. **crowdSimulator** is full crowd simulation in which multiple agents are being simulated. Each agent in the system has its own goal, and their path are planned so that they can not only reach their goals, but also avoid collisions with each other and the obstacles in the environment. Instead of importing file for scene creation, random scene (both agents locations, and obstacle locations) are generated. Multiple modes are created to simulate different cases. For path planning, a PRM algorithm is implemented (extended from the after-class activity). For anticipatory collision avoidance, the basic TTC force has been implemented.

Note: The idea of TTC force is referenced from http://www.gameaipro.com/GameAIPro2/GameAIPro2_Chapter19_Guide_to_Anticipatory_Collision_Avoidance.pdf.

## Author: *Ruichen He*

## Demo1
![](https://github.com/RuichenHe/crowdSimulator/blob/main/doc/crowd_demo1.gif)

<img src="{{ "doc/crowd_demo1.gif" | prepend: site.baseurl | prepend: site.url}}" alt="crowd_demo1" />

In the first demo gif, it shows the basic mode (by pressing `r`), in which multiple agents are generated at random initial locations, and assigned random goals. In the scene, multiple random obstacles are generated as well. By pressing `SPACE`, the simulation can be played / replayed. During the movement of the agents, blue circle will represent the initial location while the red circle will represent the goal locaiton. Each green line represents the initial generated path from PRM. The moving direction of each moving agents is represented by a black line. 

## Demo2
![](https://github.com/RuichenHe/crowdSimulator/blob/main/doc/crowd_demo2.gif)

<img src="{{ "doc/crowd_demo2.gif" | prepend: site.baseurl | prepend: site.url}}" alt="crowd_demo2" />

In order to show the anticipatory collision avoidance better, a second mode (by pressing `1`) is presented. In this mode, multiple paired agents will be randomly placed in the scene. In the showing demo2, clear anticipatory collision avoidance behavior can be observed.

## Demo3
![](https://github.com/RuichenHe/crowdSimulator/blob/main/doc/crowd_demo3.gif)

<img src="{{ "doc/crowd_demo3.gif" | prepend: site.baseurl | prepend: site.url}}" alt="crowd_demo3" />

In the Demo3, the third mode is presented (by pressing `d`). This mode is an extension from mode2, with obstacles been added into the scene as well. 


## Demo4 (Art Contest)
![](https://github.com/RuichenHe/crowdSimulator/blob/main/doc/crowd_demo4.gif)

<img src="{{ "doc/crowd_demo4.gif" | prepend: site.baseurl | prepend: site.url}}" alt="crowd_demo4" />

In the Demo4, the last mode is presented (by pressing `2`). This mode is another demonstration of anticipatory collision avoidance, by placing paired agents around a circle with same distance. 

## Difficulties
The most difficult part during the implementation is the management of different classes, including Agent, Obstacle, and PRM planner. In addition, it take me some time to figure out what should be the optimal way to present the behavior of anticipatory collision avoidance.

# Future Work

Due to the limit of time, only the basic PRM and TTC force is implemented. Future works include:
+ Current PRM is not optimal, cannot provide optimal path plan. In the future, several other optimal path planning algorithms should be considered.
+ TTC force can further been extended to c-TTC or other more advanced algorithms for better anticipatory collision avoidance.

# Code
The source code is available to download [here](https://github.com/RuichenHe/crowdSimulator/)



