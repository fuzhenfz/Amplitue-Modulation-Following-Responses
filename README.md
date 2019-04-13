# Amplitue-Modulation-Following-Responses
Using a logistic function to fit the data of a series of simulated AMFRs with different modulation depth

(1) simulatedRAdepth.m  
Simulating AMFRs using one fm with a series of depth, for many times. The response strength (relative amplitude) is also calculated for individual simulation.
The computational model (and codes) for such a simulation was from another work, please see Nelson and Carney (2004) and Dau (2003).  
Dau, T., 2003. The importance of cochlear processing for the formation of auditory brainstem and frequency following responses. J. Acoust. Soc. Am. 113, 936–950.  
Nelson, P.C., Carney, L.H., 2004. A phenomenological model of peripheral and central neural responses to amplitude-modulated tones. J. Acoust. Soc. Am. 116, 2173–2186.  

  
(2) PlotFittingRAofSimulated.m  
Using logistic function to fit the RA data calculated in simulatedRAdepth.m, to find the modulation depth corresponding to half of the maximum RA, which is considered as a prediction of behavioral threshold for AM detection.  

These scripts are related to the following work  
Chen, J., Fu, Z., Wu, J., Wu, X., 2018. Attempt to predict temporal modulation transfer function by amplitude modulation following responses. Acta Acust united Ac 104, 821–824.  

Details about the simulation procedure, please see the mentioned literature. 
